#!/bin/bash

set -e

COMPONENT=catalogue

#this is how we import the function that are declared in a different file using source

source COMPONENT/common.sh

NODEJS  #calling function

echo -e "\n \e[35m ${COMPONENT} installing is completed \e[0m \n"

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l

# NOTE: You should see the log saying `connected to MongoDB`, then only your catalogue
# will work and can fetch the items from MongoDB

# Ref Log:
# {"level":"info","time":1656660782066,"pid":12217,"hostname":"ip-172-31-13-123.ec2.internal","msg":"MongoDB connected","v":1}