#!/bin/bash

# ami id
# type of instance 
# security_group
# instance_you_need
# DNS record hosted zone id

AMI_ID="ami-007e7b9e7234f7f8d"
INSTANCE_TYPE="t3.micro"
SECURITY_GROUP="sg-071baaff364d61305"
COMPONENT=$1
if [ -z $1 ]; then
  echo -e "\e[33m COMPONENT name is needed\e[0m"
  echo -e "\e[35m ex;usage $bash launch-ec2.sh \e[0m"
  exit 1
fi  

#   aws ec2 run-instances --image-id ${AMI_ID} --count 1 --instance-type ${INSTANCE_TYPE} --security-group-ids ${SECURITY_GROUP} --subnet-id subnet-6e7f829e 

#EACH AND EVERY RESOURCE THAT WE CREATE IN ENTERPRISE(ORGANISATION LEVEL) WILL HAVE TAGS.
# BU,ENV,APP:COST_CENTER

# aws ec2 run-instances --image-id ami-0c1d144c8fdd8d690 --instance-type ${INSTANCE_TYPE} --security-group-ids ${SECURITY_GROUP} --tag-specification "ResourceType=instance,Tags=[{key=Name,Value=1}]"
aws ec2 run-instances --image-id ami-0c1d144c8fdd8d690 --instance-type t3.micro --security-group-ids sg-071baaff364d61305  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=lab}]"
