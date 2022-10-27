# ! /bin/bash
set -e


Component=nginx
logfile=/tmp/$Component.log
Update() {
    if [ $1 -eq 0 ]; then 
        echo -e "\e[32m Success \e[0m"
    else 
        echo -e "\e[31m Failure \e[0m"
    fi 
}

echo -n "Installing Webserver"

yum install $Component -y &>> $logfile
Update$

echo -n "Enable Webserver"
systemctl enable $Component
Update$

echo -n "Start Webserver"
systemctl start $Component
Update$

echo -n "Zip the Frontend Code"

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" &>> $logfile
Update$

echo -n "Copy & Paste the code"

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip &>> $logfile
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
Update$

echo -e "\e[32m Installation done \e[0m"