date="$(date +%D)"
session_count=$(who | wc -l)
echo -e"\e[32mtoday date is $date\e[0m]"
echo "Number of users joined seesion are $session_count"