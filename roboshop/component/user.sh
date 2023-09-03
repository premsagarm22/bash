#!/bin/bash 

set -e 

USER_ID=$(id -u)
COMPONENT=user
APPUSER=roboshop
LOGFILE="/tmp/${COMPONENT}.log"

if [ $USER_ID -ne 0 ]; then
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

echo -e "\e[35m configuring t}${COMPONENT} \e[0m"

echo -n "installing ${COMPONENT} :"
curl --silent --location  -o https://rpm.nodesource.com/setup_16.x |sudo bash - &>> ${LOGFILE}

echo -n "installing Nodejs :"
yum install nodejs -y
statusfunction $?

id ${APPUSER} &>> ${LOGFILE}

if [ $? -ne 0 ]; then
  echo -n "creating application user account :"
  useradd roboshop
  statusfunction $?
fi    

echo -n "downlaoding the ${COMPONENT} : "
curl -s -L -o /tmp/user.zip "https://github.com/stans-robot-project/user/archive/main.zip"
cd /home/roboshop
unzip -o /tmp/user.zip
statusfunction $?

echo -n "changing the ownership : "
rm -rf ${COMPONENT}
mv ${COMPONENT}-main ${COMPONENT}
chown -R ${APPUSER}:${APPUSER} /home/${APPUSER}/${COMPONENT}/
statusfunction $?

echo -n "generating the ${COMPONENT} artifacts :"
cd /home/${APPUSER}/${COMPONENT}/
npm install 
statusfunction $?

echo -n "updating the ${COMPONENT} systemfile "
sed -ie 's/MONGO_ENDPOINT/mongodb.roboshop-internal/' /home/roboshop/echo -n "updating the ${COMPONENT} systemfile "
/systemd.service
sed -ie 's/REDIS_ENDPOINT/redis.roboshop-internal/' /home/roboshop/echo -n "updating the ${COMPONENT} systemfile "
/systemd.service
statusfunction $?


echo -n "starting the ${COMPONENT} service :"
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
systemctl daemon-reload
systemctl enable user
systemctl restart user
statusfunction $?

set -x
# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l

# NOTE: You should see the log saying `connected to MongoDB`, then only your catalogue
# will work and can fetch the items from MongoDB

# Ref Log:
# {"level":"info","time":1656660782066,"pid":12217,"hostname":"ip-172-31-13-123.ec2.internal","msg":"MongoDB connected","v":1}