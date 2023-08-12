#!/bin/bash

echo "i am frontend"

user_id=$(id -u)

if [ $user_id -ne 0 ]; then
  echo -e "\e[32m you needs to be sudo user \t Example: sudo <filename>\e[0m]"
# yum install nginx -y
# systemctl enable nginx 
# systemctl start nginx 

# curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

# cd /usr/share/nginx/html
# rm -rf * 
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-master README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf
# systemctl restart nginx