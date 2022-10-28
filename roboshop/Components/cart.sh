#!/bin/bash

Component=cart
logfile=/tmp/$Component.log
Update(){
    if [ $1 -eq 0 ]; then
        echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[32m Failure \e[0m"
    fi
}

echo -n "Install Node Js"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $logfile
yum install nodejs -y &>> $logfile
Update $?

echo -n "User Creation"
useradd roboshop
Update $?

echo -n "Code Export"
curl -s -L -o /tmp/cart.zip "https://github.com/stans-robot-project/cart/archive/main.zip" &>> $logfile
cd /home/roboshop
unzip /tmp/cart.zip &>> $logfile
mv cart-main cart
cd cart
npm install &>> $logfile
Update $?

echo -n "Ip update"
sed -i -e 's/REDIS_ENDPOINT/172.31.31.69/' -e 's/CATALOGUE_ENDPOINT/172.31.88.134/' /home/roboshop/cart/systemd.service
Update $?

echo -n "Ip update"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl start $Component
systemctl enable $Component
systemctl status cart -l
Update $?

echo -e "\e[32m Steps are done \e[0m"
