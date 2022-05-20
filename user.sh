#!/bin/bash

####################################################################
#oooooo     oooo             oooo          .o  oooo   o8o           
# `888.     .8'              `888        o888  `888   `"'           
#  `888.   .8'   oooo  oooo   888  oooo   888   888  oooo   .oooo.o 
#   `888. .8'    `888  `888   888 .8P'    888   888  `888  d88(  "8 
#    `888.8'      888   888   888888.     888   888   888  `"Y88b.  
#     `888'       888   888   888 `88b.   888   888   888  o.  )88b 
#      `8'        `V88V"V8P' o888o o888o o888o o888o o888o 8""888P' 
####################################################################


user(){
    if [ $(whoami) != "root" ]; then
        sudo groupadd -g 1001 $group 
        sudo useradd -m -u 1001 -G wheel,$group  -s /bin/bash -c "main_user" $username
        echo "$username created, home directory created, added to wheel and $group group, default shell set to /bin/bash"
        #mkhomedir_helper username
        sudo echo "$username:$password" | chpasswd
        echo "$username password set"

        sudo echo $name_of_machine > /etc/hostname
    else
        echo "You are logged as root"
    fi
}

while true
do 
    read -p "Please enter username: " username
    if [[ "${username,,}" =~ ^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$ ]]
    then 
        break
    fi 
    echo "Incorrect username."
done 

while true
do 
    read -p "Please enter group: " group
    if [[ "${group,,}" =~ ^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$ ]]
    then 
        break
    fi 
    echo "Incorrect group."
done 

read -p "Please enter password: " password

while true
do 
    read -p "Please name your machine: " name_of_machine
    # hostname regex (!!couldn't find spec for computer name!!)
    if [[ "${name_of_machine,,}" =~ ^[a-z][a-z0-9_.-]{0,62}[a-z0-9]$ ]]
    then 
        break 
    fi 
    # if validation fails allow the user to force saving of the hostname
    read -p "Hostname doesn't seem correct. Do you still want to save it? (y/n)" force 
    if [[ "${force,,}" = "y" ]]
    then 
        break 
    fi 
done 

user