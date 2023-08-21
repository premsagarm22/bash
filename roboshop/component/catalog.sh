#!/bin/bash

set -e

user_id=$(id -u)
component=catalog
appuser=roboshop


if [ $user_id -ne 0 ]; then
  echo -e "\e[32m script is executed by the root user or with sudo privilege \e[0m"
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

echo -e "\e[35m configuring t}${component \e[0m"

echo -n "installing ${component} :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
statusfunction $?

echo -n "installing Nodejs :"
yum install nodejs -y
statusfunction $?

id ${appuser}
if [ $? --ne 0]; then
echo -n "creating application user account :"''
  useradd roboshop
  statusfunction $?
fi    