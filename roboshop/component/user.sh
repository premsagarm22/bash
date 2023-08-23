#!/bin/bash 

user_id=$(id -u)
component=user
appuser=roboshop
log="/tmp/${component}.log"

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

echo -e "\e[35m configuring t}${component} \e[0m"

echo -n "installing ${component} :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -

echo -n "installing Nodejs :"
yum install nodejs -y
statusfunction $?

id ${appuser} &>> ${log}

if [ $? -ne 0 ]; then
  echo -n "creating application user account :"
  useradd roboshop
  statusfunction $?
fi    

echo -n "downlaoding the ${component} : "
curl -s -L -o /tmp/user.zip "https://github.com/stans-robot-project/user/archive/main.zip"
cd /home/roboshop
unzip -o /tmp/user.zip
statusfunction $?

echo -n "changing the ownership : "
mv ${component}-main ${component}
chown -R ${appuser}:${appuser} /home/${appuser}/${component}/
statusfunction $?

echo -n "generating the ${component} artifacts :"
cd /home/${appuser}/${component}/
npm install 
statusfunction $?

echo -n "updating the ${component} systemfile "
sed -ie 's/MONGO_ENDPOINT/mongodb.roboshop-internal/' /home/roboshop/user/systemd.service
sed -ie 's/REDIS_ENDPOINT/redis.roboshop-internal/' /home/roboshop/user/systemd.service
statusfunction $?


echo -n "starting the catalogue service :"
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
systemctl daemon-reload
systemctl enable user
systemctl restart user
statusfunction $?

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l

# NOTE: You should see the log saying `connected to MongoDB`, then only your catalogue
# will work and can fetch the items from MongoDB

# Ref Log:
# {"level":"info","time":1656660782066,"pid":12217,"hostname":"ip-172-31-13-123.ec2.internal","msg":"MongoDB connected","v":1}