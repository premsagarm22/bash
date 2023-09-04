#!/bin/bash 

set -e
# Validate the user who is running the script is a root user or not.
COMPONENT=rabbitmq

source component/common.sh

echo -e "\e[35m Configuring ${COMPONENT} ......! \e[0m \n"

echo -n "Configuring ${COMPONENT} repositories:"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> ${LOGFILE}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>> ${LOGFILE}
statusfunction $? 

echo -n "Installing ${COMPONENT} :"
yum install rabbitmq-server -y  &>> ${LOGFILE}
statusfunction $? 

echo -n "Starting ${COMPONENT}:"
systemctl enable rabbitmq-server   &>> ${LOGFILE}
systemctl start rabbitmq-server    &>> ${LOGFILE}
statusfunction $? 

sudo rabbitmqctl list_users | grep roboshop &>> ${LOGFILE}
if [ $? -ne 0 ] ; then 
    echo -n "Creating ${COMPONENT} user account :"
    rabbitmqctl add_user roboshop roboshop123 &>> ${LOGFILE}
    statusfunction $? 
fi 

echo -n "Configuring the permissions :"
rabbitmqctl set_user_tags roboshop administrator     &>> ${LOGFILE}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"     &>> ${LOGFILE}
statusfunction $?

echo -e "\e[35m ${COMPONENT} Installation Is Completed \e[0m \n"
set -x