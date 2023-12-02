#!/bin/bash

# COMPONENT=cart
# APPUSER="roboshop"
# LOGFILE="/tmp/${COMPONENT}.log"

# if [ $? -ne 0 ]; then
#   echo "you needs to be perform through root directory"
#   exit 1
# fi

# statusfunction() {

#     if [ $? -eq 0 ]; then
#        echo -e "\e[33m sucessfully installed \e[0m"
#     else
#        echo -e "\e[31m failed \e[0m"  
#        exit 1
#     fi
# }

# echo -n "downloanding cart compoNent:"
# curl --silent --location https://rpm.nodesource.com/setup_16.x |sudo bash - &>> ${LOGFILE}
# yum install nodejs -y
# statusfunction $?


# echo -n "adding user :"
# id ${APPUSER}  &>> ${LOGFILE} 
# if [ $? -ne 0 ]; then
#   useradd roboshop
#   echo "creating ${APPUSER} account"
# else
#   echo -e "please be non-root user"
#   exit 3  
# fi
# statusfunction $?

# echo -n "adding the COMPONENTs inside the ${user} user account:"
# curl -s -L -o /tmp/cart.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
# cd /home/roboshop
# unzip -o /tmp/${COMPONENT}.zip
# mv ${COMPONENT}-main cart
# npm install
# sed -ie "s/REDIS_ENDPOINT/redis.roboshop-internal/g" /home/roboshop/${COMPONENT}/systemd.servicee
# sed -ie "s/CATALOGUE_ENDPOINT/catalogue.roboshop-internal/g" /home/roboshop/${COMPONENT}/systemd.servicee
# statusfunction $?


# echo -n "moving the system file"
# mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/cart.service
# systemctl daemon-reload
# systemctl start ${COMPONENT}
# systemctl enable ${COMPONENT}
# systemctl status ${COMPONENT} -l
# statusfunction $?


#!/bin/bash 

COMPONENT=cart

# This is how we import the functions that are declared in a different file using source 
source component/common.sh
NODEJS # calling nodejs function.

echo -e "\n \e[35m ${COMPONENT} Installation Is Completed \e[0m \n"