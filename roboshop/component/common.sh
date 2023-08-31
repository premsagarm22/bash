#!/bin/bash

#all the common functions are declared here

appuser="roboshop"
log="/tmp/${component}.log"

user_id=$(id -u)

if [ $user_id -ne 0 ]; then
  echo -e "\e[32m script is executed by the root user or with sudo privilege \e[0m"
  exit 1
fi

statusfunction() {
    if [ $? -eq 0 ]; then 
        echo -e "\e[32m success \e[0m"
    fi
}


statusfunction() {

    if [ $? -eq 0 ]; then
       echo -e "\e[33m sucessfully installed \e[0m"
    else
       echo -e "\e[31m failed \e[0m"  
       exit 1
    fi
}

#creating user function
create_user() {

id ${appuser} &>> ${log}
if [ $? -ne 0 ]; then
  echo -n "creating application user account :"
  useradd roboshop
  statusfunction $?
fi    
}

#downloading component and extracting 
downloading_and_extracting() {
echo -n "downlaoding the ${component} : "
curl -s -L -o /tmp/${component}.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
cd /home/${appuser}
rm -rf ${component}  &>> ${log}
unzip -o /tmp/${component}.zip
statusfunction $?

mv ${component}-main ${component}
chown -R ${appuser}:${appuser} /home/${appuser}/${component}/
statusfunction $?

}

config_service() {
echo -n "updating the ${component} systemfile: "
# sed -ie 's/MONGO_DNSNAME/mongodb.roboshop-internal/g' /home/${appuser}/${component}/systemd.service
sed -ie 's/REDIS_ENDPOINT/172.31.41.73/g' /home/${appuser}/${component}/systemd.service
sed -ie 's/CATALOGUE_ENDPOINT/172.31.45.192/g' /home/${appuser}/${component}/systemd.service
mv /home/${appuser}/${component}/systemd.service /etc/systemd/system/${component}.service
echo -n "changing the ownership : "
statusfunction $?


echo -n "starting the ${component} service: "
systemctl daemon-reload
systemctl start ${component}  &>> ${log}
systemctl enable ${component}  &>> ${log}
systemctl status ${component} -l  &>> ${log}
statusfunction $?

}
#creating nodejs
Nodejs() {
echo -e "\e[35m configuring t}${component} \e[0m"

echo -n "installing ${component} :"
curl --silent --location yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y|sudo bash -
statusfunction $?


echo -n "installing Nodejs :"
yum install nodejs -y
statusfunction $?

create_user       #calls create_user function that creates user account
downloading_and_extracting   #download and extract the component


echo -n "generating the ${component} artifacts :"
cd /home/${appuser}/${component}/
npm install  &>> ${log}
statusfunction $?  

config_service

}

MVN_PACKAGE() {
        echo -n "Generating the ${component} artifacts :"
        cd /home/${appuser}/${component}/
        mvn clean package   &>> ${log}
        mv target/${component}-1.0.jar ${component}.jar
        stat $?
}

JAVA() {
        echo -e "\e[35m Configuring ${component} ......! \e[0m \n"

        echo -n "Installing maven:"
        yum install maven -y    &>> ${log}
        stat $? 

        create_user              # calls CREATE_USER function that creates user account.

        downloading_and_extracting     # Downloads and extracts the components

        MVN_PACKAGE

        config_service

}

PYTHON() {
        echo -e "\e[35m Configuring ${component} ......! \e[0m \n"

        echo -n "Installing python:"
        yum install python36 gcc python3-devel -y &>> ${log}
        stat $? 

        create_user              # calls CREATE_USER function that creates user account.

        downloading_and_extracting     # Downloads and extracts the components

        echo -n "Generating the artifacts"
        cd /home/${appuser}/${component}/ 
        pip3 install -r requirements.txt    &>> ${log} 
        stat $?

        user_id=$(id -u roboshop)
        GROUPID=$(id -g roboshop)

        echo -n "Updating the uid and gid in the ${component}.ini file"
        sed -i -e "/^uid/ c uid=${user_id}" -e "/^gid/ c gid=${GROUPID}" /home/${appuser}/${component}/${component}.ini
        stat $?

        config_service
}
