# ! /bin/bash
set -e


Component=nginx
logfile= /tmp/$Component.log

echo -n "Installing Webserver"
yum install $Component -y &>> $logfile
systemctl enable $Component
systemctl start $Component



# curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"


# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf