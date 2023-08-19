#!/bin/bash 

user_id=$(id -u)
component=mongodb
log=/tmp/${component}.log

if [ $user_id -ne 0 ]; then
  echo -e "\e[32m script is executed by the root user or with sudo privilege \e[0m"
  exit 1
fi

echo -e "\e[35m configuring ${component}\e[0m"

echo -n "installing ${component} :"
yum install nginx -y >> /tmp/$component.log

statusfunction(){

    if [ $1 -eq 0 ]; then
       echo -e "\e[33m sucessfully installed \e[0m"
    else
       echo -e "\e[31m failed \e[0m"  
       exit 2
    fi
}

statusfunction $?

# curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
statusfunction $?

echo -n "downloading ${component}"

yum install -y ${component}-org
# systemctl enable ${component
# systemctl start ${component}


statusfunction $?

