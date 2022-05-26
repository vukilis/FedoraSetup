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

clear

# Location #
set -a
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Fedora, VM-Fedora ? #

echo -ne "\e[1;31m
----------------------------------------------------------------------------
                        Automated Fedora Setup Script
                            MadeBy: Vuk1lis™
                        https://github.com/vukilis
----------------------------------------------------------------------------
\e[1;33m"

PS3="Choose your option: "
menu=("Fedora Desktop" "Fedora Work")

select option in "${menu[@]}" "Quit"; do 
    case "$REPLY" in
    1) echo -e "\033[1;32mYou chose $option\n\033[1;36m" 
        if [ $(cat /proc/sys/kernel/hostname) != "Vuk1lisPC" ]; then
        bash $SCRIPT_DIR/scripts/user.sh
        fi
        bash $SCRIPT_DIR/scripts/dotfiles.sh
        bash $SCRIPT_DIR/scripts/fedora.sh
        break;;
    2) echo -e "\033[1;32mYou chose $option\n\033[1;36m" 
        if [ $(cat /proc/sys/kernel/hostname) != "Vuk1lisPC" ]; then
        bash $SCRIPT_DIR/scripts/user.sh
        fi
        bash $SCRIPT_DIR/scripts/dotfiles.sh
        bash $SCRIPT_DIR/scripts/fedora.sh
        break;;
    *) echo -e "\033[1;31m- $REPLY is invalid option. Try another one. -\033[1;36m";;
    esac
done


# if [ $(cat /proc/sys/kernel/hostname) != "Vuk1lisPC" ]; then
# bash ./scripts/user.sh