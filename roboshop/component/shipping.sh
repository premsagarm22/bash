#!/bin/bash 
set -e
component=shipping
appuser=roboshop
log="/tmp/${component}.log"

user_id=$(id -u)

if [ $user_id -ne 0 ]; then
  echo -e "\e[32m script is executed by the root user or with sudo privilege \e[0m"
  exit 1
fi

statusfunction() {
    if [ $? -eq 0 ]; then 
        echo -e "\e[32m success \e[0m"
    else 
        echo -e "\e[31m failure \e[0m"
        exit 2
    fi
}

maven() {

yum install java-11-openjdk.x86_64 java-11-openjdk-devel.x86_64 -y

VERSION=$(curl -s https://maven.apache.org/download.cgi  | grep Downloading |awk '{print $NF}' |awk -F '<' '{print $1}')
cd /opt
curl -s https://archive.apache.org/dist/maven/maven-3/${VERSION}/binaries/apache-maven-${VERSION}-bin.zip -o /tmp/apache-maven-${VERSION}-bin.zip
unzip /tmp/apache-maven-${VERSION}-bin.zip
mv apache-maven-${VERSION} maven
ln -s /opt/maven/bin/mvn /bin/mvn

}

echo -n "installing java11 : "
maven
statusfunction $?
