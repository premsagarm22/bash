#!/bin/bash 

set -e

USER_ID=$(id -u)
COMPONENT=mongodb
LOGFILE="/tmp/${COMPONENT}.log"

if [ $USER_ID -ne 0 ]; then
  echo -e "\e[32m script is executed by the root user or with sudo privilege \e[0m"
  exit 1
fi

statusfunction(){

    if [ $1 -eq 0 ]; then
       echo -e "\e[33m sucessfully installed \e[0m"
    else
       echo -e "\e[31m failed \e[0m"  
       exit 2
    fi
}


echo -e "\e[35m configuring ${COMPONENT}\e[0m"

echo -n "configuring ${COMPONENT}  repo:"

curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
statusfunction $?

echo "hi hello"
echo -n "installing ${COMPONENT} :  "
yum install -y mongodb-org 
statusfunction $?

echo -n "Enabling the ${COMPONENT} visibility :"
sed  -ie 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
statusfunction $?

echo -n "starting mongodb: "
systemctl enable mongod
systemctl start mongod
statusfunction $?

echo -n "Downloading the ${COMPONENT} schema: "
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip" 
statusfunction $?

echo -n "Extracing the ${COMPONENT} Schema:"
cd /tmp 
unzip -o ${COMPONENT}.zip &>> ${LOGFILE} 
statusfunction $?

echo -n "Injecting ${COMPONENT} Schema:"
cd ${COMPONENT}-main
mongo < catalogue.js    &>>  ${LOGFILE}
mongo < users.js        &>>  ${LOGFILE}
statusfunction $?

echo -e "\e[35m ${COMPONENT} Installation Is Completed \e[0m \n"

# for i in {1..12};do
#   touch "$i"
# done  