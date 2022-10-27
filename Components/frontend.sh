# ! /bin/bash
set -e


Component=nginx
logfile= /tmp/$Component.log

echo -n "Installing Webserver"

yum install $Component -y &>> $logfile

echo -n "Enable Webserver"
systemctl enable $Component

echo -n "Start Webserver"
systemctl start $Component

echo -n "Zip the Frontend Code"

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" &>> $logfile

echo -n "Copy & Paste the code"

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip &>> $logfile
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf


echo -e "\e[32m Installation done \e[0m"