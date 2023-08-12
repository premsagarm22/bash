#!/bin/bash

echo "i am frontend"
echo " looking for frontend"
user_id=$(id -u)

if [ $user_id -ne 0 ]; then
  echo -e "\e[32m you needs to be sudo user \t Example: sudo <filename> \e[0m"
  echo "hi"