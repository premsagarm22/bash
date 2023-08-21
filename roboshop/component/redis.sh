#!/bin/bash

if [ $user_id -ne 0 ]; then
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

echo -n "installing redis repo: " 
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
statusfunction $?

echo -n "installing redis : " 
yum install redis-6.2.11 -y
statusfunction $?

echo -n "updating bind ip-address: "
cd /etc/redis.conf
sed -ie "s/127.0.0.1/0.0.0.0g"
statusfunction $?

echo -n "updating bind ip-address: "
cd  /etc/redis/redis.conf
sed -ie "s/127.0.0.1/0.0.0.0g"
statusfunction $?

echo -n "starting database : "
systemctl enable redis
systemctl start redis
systemctl status redis -l
statusfunction $?
