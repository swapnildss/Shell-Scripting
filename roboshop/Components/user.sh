#! /bin/bash

Component=user
logfile=/tmp/$Component.log
Update(){
    if [ $1 -eq 0 ]; then
        echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failure \e[0m"
    fi
}

echo -n "Download Node JS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $logfile
Update $?

echo -n "Install NodeJS"
yum install nodejs -y &>> $logfile
Update $?

echo -n "User Creation"
useradd roboshop
Update $?

echo -n "Project Setup"
curl -s -L -o /tmp/user.zip "https://github.com/stans-robot-project/user/archive/main.zip" &>> $logfile
cd /home/roboshop
unzip /tmp/user.zip &>> $logfile
mv user-main user
cd /home/roboshop/user
npm install
Update $?

echo -n "update the IP"
sed -i -e 's/REDIS_ENDPOINT/172.31.31.69/' -e 's/MONGO_ENDPOINT/172.31.95.58/'/home/roboshop/user/systemd.service
# $ vim /home/roboshop/user/systemd.service
# Update `REDIS_ENDPOINT` with Redis Server IP
# Update `MONGO_ENDPOINT` with MongoDB Server IP
Update $?


echo -n "Create Service"
mv /home/roboshop/user/systemd.service /etc/systemd/system/$Component.service
systemctl daemon-reload
systemctl start $Component
systemctl enable $Component
Update $?

echo -e "\e[32m Successfully User setup done \e[0m"
