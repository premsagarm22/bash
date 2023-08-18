#!/bin/bash 

user_id=$(id -u)

if [ $user_id -ne 0 ]; then
  echo -e "\e[32m script is executed by the root user or with sudo privilege \e[0m"
  exit 1
fi

echo -e "\e[35m configuring frontend \e[0m \n"
echo "installing frontend "
yum install nginx -y
echo $?

