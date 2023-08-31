#!/bin/bash

component=mysql

source components/common.sh

echo -e "\e[35m Configuring ${component} ......! \e[0m \n"

echo -n "Configuring ${component} repo :"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
stat $?

echo -n "Installing ${component}  :"
yum install mysql-community-server -y   &>>  ${log}
stat $?

echo -n "Starting ${component}:" 
systemctl enable mysqld   &>>  ${log}
systemctl start mysqld    &>>  ${log}
stat $?

echo -n "Extracting the default mysql root password :"
DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk -F " " '{print $NF}')
stat $? 

# This should happen only once and that too for the first time, when it runs for the second time, jobs fails.
# We need to ensure that this runs only once.

echo "show databases;" | mysql -uroot -pRoboShop@1 &>>  ${log}
if [ $? -ne 0 ]; then 
    echo -n "Performing default password reset of root account:"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1'" | mysql  --connect-expired-password -uroot -p$DEFAULT_ROOT_PASSWORD &>>  ${log}
    stat $?
fi 

echo "show plugins;" | mysql -uroot -pRoboShop@1 | grep validate_password  &>>  ${log}
if [ $? -eq 0 ]; then 
    echo -n "Uninstalling Password-validate plugin :"
    echo "uninstall plugin validate_password" | mysql -uroot -pRoboShop@1 &>>  ${log}
    stat $?
fi 


echo -n "Downloading the $component schema:"
curl -s -L -o /tmp/${component}.zip "https://github.com/stans-robot-project/${component}/archive/main.zip"
stat $? 

echo -n "Extracting the $component Schema:"
cd /tmp  
unzip -o /tmp/${component}.zip   &>> ${log}
stat $? 

echo -n "Injecting the schema:"
cd ${component}-main 
mysql -u root -pRoboShop@1 <shipping.sql     &>>  ${log} 
stat $? 

echo -e "\e[35m ${component} Installation Is Completed"