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
        sudo groupadd $username 
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
        sudo useradd -m -g $username -G wheel -s /bin/bash -c "main_user" -p $pass $username
        echo "$username created, home directory created, added to wheel and $username group, default shell set to /bin/bash"
        echo "$username password set"
        sudo hostnamectl set-hostname $name_of_machine
    else
        groupadd $username 
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
        useradd -m -g $username -G wheel -s /bin/bash -c "main_user" -p $pass $username
        echo "$username created, home directory created, added to wheel and $username group, default shell set to /bin/bash"
        echo "$username password set"
        hostnamectl set-hostname $name_of_machine
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