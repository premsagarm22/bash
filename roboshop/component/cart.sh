#!/bin/bash

COMPONENT=cart
APPUSER="roboshop"
LOGFILE="/tmp/${COMPONENT}.log"

if [ $? -ne 0 ]; then
  echo "you needs to be perform through root directory"
  exit 1
fi

statusfunction() {

    if [ $? -eq 0 ]; then
       echo -e "\e[33m sucessfully installed \e[0m"
    else
       echo -e "\e[31m failed \e[0m"  
       exit 1
    fi
}

echo -n "downloanding cart compoNent:"
curl --silent --location yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y|sudo bash -
yum install nodejs -y
statusfunction $?


echo -n "adding user :"
id ${APPUSER}  &>> ${LOGFILE} 
if [ $? -ne 0 ]; then
  useradd roboshop
  echo "creating ${APPUSER} account"
else
  echo -e "please be non-root user"
  exit 3  
fi
statusfunction $?

echo -n "adding the COMPONENTs inside the ${user} user account:"
curl -s -L -o /tmp/cart.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
cd /home/roboshop
unzip -o /tmp/${COMPONENT}.zip
mv ${COMPONENT}-main cart
cd ${COMPONENT}
npm install
sed -ie "s/REDIS_ENDPOINT/172.31.41.73/g" /home/roboshop/${COMPONENT}/systemd.servicee
sed -ie "s/CATALOGUE_ENDPOINT/172.31.45.192/g" /home/roboshop/${COMPONENT}/systemd.servicee
statusfunction $?


echo -n "moving the system file"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl start ${COMPONENT}
systemctl enable ${COMPONENT}
systemctl status ${COMPONENT} -l
statusfunction $?


