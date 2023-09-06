#!/bin/bash

# ami id
# type of instance 
# security_group
# instance_you_need
# DNS record hosted zone id

AMI_ID="ami-0c1d144c8fdd8d690"
INSTANCE_TYPE="t3.micre"
SECURITY_GROUP="sg-071baaff364d61305"
COMPONENT=$1
if { -z $1 ]; then
  echo -e "\e33m COMPONENT name is needed\e[0m"
  echo -e "\e[35m ex;usage $bash ec2.sh \e[0m"
  exit 1
fi  

aws ec2 run-instances --image-id ${AMI_ID} --count 1 --instance-type ${INSTANCE_TYPE} --security-group-ids ${SECURITY_GROUP} --subnet-id subnet-6e7f829e 

#EACH AND EVERY RESOURCE THAT WE CREATE IN ENTERPRISE(ORGANISATION LEVEL) WILL HAVE TAGS.
# BU,ENV,APP:COST_CENTER

--tag-specification 'Resourcetype=instance,tags=[{key=Name,Value=${COMPONENT}}]'