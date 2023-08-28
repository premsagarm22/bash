#!/bin/bash 

set -e
# Validate the user who is running the script is a root user or not.
component=rabbitmq

source components/common.sh

echo -e "\e[35m Configuring ${component} ......! \e[0m \n"

echo -n "Configuring ${component} repositories:"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> ${log}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>> ${log}
stat $? 

echo -n "Installing ${component} :"
yum install rabbitmq-server -y  &>> ${log}
stat $? 

echo -n "Starting ${component}:"
systemctl enable rabbitmq-server   &>> ${log}
systemctl start rabbitmq-server    &>> ${log}
stat $? 

sudo rabbitmqctl list_users | grep roboshop &>> ${log}
if [ $? -ne 0 ] ; then 
    echo -n "Creating ${component} user account :"
    rabbitmqctl add_user roboshop roboshop123 &>> ${log}
    stat $? 
fi 

echo -n "Configuring the permissions :"
rabbitmqctl set_user_tags roboshop administrator     &>> ${log}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"     &>> ${log}
stat $?

echo -e "\e[35m ${component} Installation Is Completed \e[0m \n"