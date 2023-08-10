#!/bin/bash

echo "i am frontend"

yum install nginx -y

user_id =$(id -u)
if [[ user_id -eq 0 ]]; then
  echo "you have signed ad root user"
else
  echo "kindly switch into root user to make changes"
fi     

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