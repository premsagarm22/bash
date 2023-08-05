date="$(date +%D)"
session_count=$(who | wc -l)
echo "today date is $date"
echo "Number of users joined seesion are $session_count"