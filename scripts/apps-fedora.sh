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

###### Repo pkgs ######
repo_pkgs(){
  #VisualStudioCode
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  #pgAdmin4
  sudo rpm -i https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-fedora-repo-2-1.noarch.rpm
  #Docker
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  #Terraform
  sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/$release/hashicorp.repo
}

###### Repo MongoDB ######
cat <<EOF | sudo tee /etc/yum.repos.d/mongodb-org-5.0.repo
[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
EOF

######### Update ##########
repo_pkgs
sudo dnf check-update

###### Install pkgs #######
for pkg in `cat ../pkg-files/dnf-pkgs.txt`
do sudo dnf -y install $pkg
done

###### Setup Python #######
sudo pip3 install virtualenvwrapper
mkvirtualenv -p python3.9 test

######### Install AWS CLI ##########
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

######### Start MongoDB ##########
sudo systemctl daemon-reload
sudo systemctl enable mongod
sudo systemctl start mongod

######### Check version ##########
code -v
psql --version
docker -v
terraform -v
python --version
pip -V
mongod --version
aws --version