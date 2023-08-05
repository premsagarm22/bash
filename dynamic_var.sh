date="$(date +%D)"
session_count=$(who | wc -l)
echo -e "\e[32m today date is $date \e[0m"
echo -e "Number of users joined seesion are \e[32m $session_count \e[0m"