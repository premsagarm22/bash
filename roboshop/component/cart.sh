#!/bin/bash

component=cart
appuser="roboshop"
log="/tmp/${component}.log"

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

echo -n "downloanding cart compoment:"
curl --silent --location yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
yum install nodejs -y| sudo bash -
statusfunction $?


echo -n "adding user :"
id ${APPUSER}  &>> ${LOGFILE} 
if [ $? -ne 0 ]; then
  useradd roboshop
  echo "creating ${user} account"
else
  echo -e "please be non-root user"
  exit 3  
fi
statusfunction $?

echo -n "adding the components inside the ${user} user account:"
curl -s -L -o /tmp/cart.zip "https://github.com/stans-robot-project/cart/archive/main.zip"
cd /home/roboshop
unzip -o /tmp/cart.zip
mv cart-main cart
cd cart
npm install
sed -ie "s/REDIS_ENDPOINT/172.31.41.73/g" /home/roboshop/cart/systemd.servicee
sed -ie "s/CATALOGUE_ENDPOINT/172.31.45.192/g" /home/roboshop/cart/systemd.servicee
statusfunction $?


echo -n "moving the system file"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl start cart
systemctl enable cart
systemctl status cart -l
statusfunction $?


