#! /bin/bash

Component=redis
logfile=/tmp/$Component.log
Update() {
    if [ $1 -eq 0 ]; then
     echo -e "\e[32m Success \e[0m"

    else
     echo -e "\e[31m Failure \e[0m"

    fi
}

echo -n "Download the code"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/$Component.repo &>> $logfile
Update $?

echo -n "Install Redis"
yum install redis-6.2.7 -y &>> $logfile
Update $?

echo -n "IP Updation on config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
Update $?

echo -n "start the Redis"
systemctl enable redis
systemctl start redis
systemctl status redis -l
Update $?

echo -e "\e[32m Successfully Redis Configured \e[0m"