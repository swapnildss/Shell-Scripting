#! /bin/bash
set -e

Component=mysql
logfile=/tmp/$Component.log
DB=RoboShop@1
Update (){
    if [ $1 -eq 0 ]; then
        echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
    fi
}

echo -n "Download the Mysql"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/$Component/main/$Component.repo &>> $logfile
Update $?

echo -n "Install the Mysql"
yum install mysql-community-server -y &>> $logfile
Update $?

echo -n "Start the Mysql"
systemctl enable mysqld 
systemctl start mysqld
Update $?

echo -n "Get the Passowrd"
DB_PD=$(grep 'A temporary password' /var/log/mysqld.log | awk -F ' ' '{print $NF}')
echo -e "\e[34m $DB_PD \e[0m"
Update $?

echo -n "MYSQL Setup"
mysql_secure_installation
Update $?

echo -n "login MYSQL"
mysql -uroot -p$DB
uninstall plugin validate_password;
Update $?

echo -n "Export DB"
curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip"
Update $?

echo -n "Export DB in Mysql"
cd /tmp
unzip mysql.zip
cd mysql-main
mysql -u root -p$DB <shipping.sql
Update $?

echo -e "\e[32m Setup completed \e[0m"