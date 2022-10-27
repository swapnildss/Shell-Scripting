#! /bin/bash

set -e

Component=catalogue
logfile=/tmp/$Component.log
UN=roboshop
Update () {
    if [ $1 -eq 0 ]; then
        echo -e "\e[32m Success \e[0m"

    else

        echo -e "\e[31m failure \e[0m"
    
    fi

            }

echo -n "Download NodeJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $logfile
Update $?

echo -n "Install NodeJS"
yum install nodejs -y &>> $logfile
Update $?

# echo -n "User Creation"
# useradd roboshop
# Update $?

echo -n "Install the code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip" &>> $logfile
Update $?

echo -n "Unzip the code"

cd /home/$UN
unzip /tmp/catalogue.zip &>> $logfile
mv catalogue-main/ catalogue
cd /home/$UN/catalogue
npm install &>> $logfile
Update $?



# vim systemd.servce



# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l

