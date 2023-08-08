#/bin/bash 

echo "Demo on if and if-else and else-if usage"

ACTION=$1 

if [ "$ACTION" == "start" ]; then   
    echo -e "\e[32m Starting Payment \e[0m"
    exit  0

elif [ "$ACTION" == "stop" ]; then 
    echo -e "\e[31m Stopping Payment \e[0m"
    exit 1

elif [ "$ACTION" == "restart" ]; then 
    echo -e "\e[35m Restarting Payment \e[0m"
    exit 2

else 
    echo -e "\e[35m Valid Options are start or stop or restart \e[0m"
    echo -e "\e[33m Example Usage \e[0m \n \t bash scriptName stop"
    exit 3
fi