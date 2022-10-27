#! /bin/bash
set -e

Component=mongod
logfile=/tmp/$Component.log
Update() {
    if [$1 -eq 0] ; then
        echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failure \e[0m"
    fi
        }

echo -n "Download the Package"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo &>> $logfile
Update $?

echo -n "Install MongoDB"
yum install -y mongodb-org
Update $?

echo -n "Enable Mongo Service"
systemctl enable $Component
Update $?

echo -n "Update the IP from conf file"
sed -i -e s/127.0.0.1/0.0.0.0 /etc/$Component.conf
Update $?

echo -n "Start MongoD"
systemctl start $Component
Update $?


echo -n "Download the schema"

curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip" &>> $logfile
Update $?

echo -n "Inject the schema."
cd /tmp
unzip mongodb.zip
cd mongodb-main
mongo < catalogue.js
mongo < users.js
Update $?

echo - e "\e[32m Installation done succesfully \e[0m"