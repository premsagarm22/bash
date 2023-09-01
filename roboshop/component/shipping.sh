#!/bin/bash 
set -e
component=shipping

# This is how we import the functions that are declared in a different file using source 
source component/common.sh
JAVA # calling nodejs function.

echo -e "\n \e[35m ${component} Installation Is Completed \e[0m \n"