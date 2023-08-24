#!/bin/bash

if [ $? -ne 0 ]; then
  echo "you needs to be perform through root directory"
  exit 1
fi

statusfunction(){

    if [ $? -eq 0 ]; then
       echo -e "\e[33m sucessfully installed \e[0m"
    else
       echo -e "\e[31m failed \e[0m"  
       exit 1
    fi
}

echo -n "downloanding cart compoment:"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
statusfunction $?

echo -n "downloading nodje component: "
yum install nodejs -y
statusfunction $?


echo -n "adding user :"
user=roboshop
if [ $user -ne 0 ]; then
  echo "creating ${user} account"
fi
statusfunction $?

echo -n "adding the components inside the ${user} user account:"
 curl -s -L -o /tmp/cart.zip "https://github.com/stans-robot-project/cart/archive/main.zip"
cd /home/roboshop
unzip /tmp/cart.zip
mv cart-main cart
cd cart
npm install
statusfunction $?

echo -n "making updation of ip address:"
sed -ie "s/REDIS_ENDPOINT/172.31.41.73/g" /home/roboshop/cart/systemd.service
sed -ie "s/CATALOGUE_ENDPOINT/172.31.45.192/g" /home/roboshop/cart/systemd.service
statusfunction $?


echo -n "moving the system file"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl start cart
systemctl enable cart
systemctl status cart -l
statusfunction $?


