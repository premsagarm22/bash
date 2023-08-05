#!/bin/bash 

# There are 4 types of command available : 

# 1) Binary                   ( /bin  , /sbin )
# 2) Aliases                  ( Alises are shortcuts,  alias net="netstat -tulpn" )
# 3) Shell Built-in Commands  
# 4) Functions                # Functions are nothing but a set of command that can be written in a sequence and can be called n number of times as per your choice.



# How to declare a function ?

# This is how we can declare a function 
# f() {
#    echo hai
# }

# This is how we call a function
# f

# sample() {
#     echo Hai from sample function
#     echo Sample function is completed
# }


# sample 

# echo sample call is completed 

# sample 

hai() {
    echo "I am hai function"
    echo "I am here to tell you HAI"
    echo "I am completed"
}

stat() {
    echo "Number of sessions opened are $(who | wc -l)"
    echo "Todays date is $(date +%F)"
    echo "Avg CPU Utilization in last 5 minutes $(uptime | awk -F : '{print $NF}' | awk -F , '{print $2}')"

    # calling another function
    hai 
}

stat