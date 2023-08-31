#!/bin/bash

COMPONENT=mysql

source components/common.sh

echo -e "\e[35m Configuring ${COMPONENT} ......! \e[0m \n"

echo -n "Configuring ${COMPONENT} repo :"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
statusfunction $?

echo -n "Installing ${COMPONENT}  :"
yum install mysql-community-server -y     &>>  ${LOGFILE}
statusfunction $?

echo -n "Starting ${COMPONENT}:" 
systemctl enable mysqld   &>>  ${LOGFILE}
systemctl start mysqld    &>>  ${LOGFILE}
statusfunction $?

echo -n "Extracting the default mysql root password :"
DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk -F " " '{print $NF}')
statusfunction $? 

# This should happen only once and that too for the first time, when it runs for the second time, jobs fails.
# We need to ensure that this runs only once.

echo "show databases;" | mysql -uroot -pRoboShop@1 &>>  ${LOGFILE}
if [ $? -ne 0 ]; then 
    echo -n "Performing default password reset of root account:"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1'" | mysql  --connect-expired-password -uroot -p$DEFAULT_ROOT_PASSWORD &>>  ${LOGFILE}
    statusfunction $?
fi 

echo "show plugins;" | mysql -uroot -pRoboShop@1 | grep validate_password  &>>  ${LOGFILE}
if [ $? -eq 0 ]; then 
    echo -n "Uninstalling Password-validate plugin :"
    echo "uninstall plugin validate_password" | mysql -uroot -pRoboShop@1 &>>  ${LOGFILE}
    statusfunction $?
fi 


echo -n "Downloading the $COMPONENT schema:"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
statusfunction $? 

echo -n "Extracting the $COMPONENT Schema:"
cd /tmp  
unzip -o /tmp/${COMPONENT}.zip   &>> $LOGFILE
statusfunction $? 

echo -n "Injecting the schema:"
cd ${COMPONENT}-main 
mysql -u root -pRoboShop@1 <shipping.sql     &>>  ${LOGFILE} 
statusfunction $? 


echo -e "\e[35m ${COMPONENT} Installation Is Completed \e[0m \n"