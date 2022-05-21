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

sed -n '/'$INSTALL_TYPE'/q;p' ~/Desktop/UltimateSetup/pkg-files/dnf-pkgs.txt | while read line
do
  if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]; then
    # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
    continue
  fi
  echo "INSTALLING: ${line}"
  dnf -y ${line}
done