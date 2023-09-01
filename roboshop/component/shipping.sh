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
unzip -o /tmp/apache-maven-${VERSION}-bin.zip
rm -rf apache-maven-${VERSION}
mv apache-maven-${VERSION} maven
ln -s /opt/maven/bin/mvn /bin/mvn
}

echo -n "installing java11 : "
maven
statusfunction $?

echo -n "creating the user:"
id ${appuser} &>> ${log}
if [ $? -ne 0 ]; then
  echo -n "creating application user account :"
  useradd roboshop
  statusfunction $?
fi    

echo -n "downloading the repo: "
cd /home/roboshop
curl -s -L -o /tmp/shipping.zip "https://github.com/stans-robot-project/shipping/archive/main.zip"
unzip -o /tmp/shipping.zip
mv shipping-main shipping
cd shipping
mvn clean package 
mv target/shipping-1.0.jar shipping.jar
statusfunction $?

echo -n "updating ip address: "
sed -ie "s/CARTENDPOINT/cart.roboshop-internal/" -e "s/DBHOST/mongodb.roboshop-internal/" /home/${appuser}/${component}/systemd.service
statusfunction $?

echo -n "copying systemd files into running as service:"
mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
systemctl daemon-reload
systemctl start shipping 
systemctl enable shipping
systemctl status shipping -l 

# ( You should see a message stating, that shipping started )

# Ref: Started ShippingServiceApplication in `X` seconds

