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

########## Repo pkgs ##########
repo_pkgs(){
  #VisualStudioCode
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}

########## Update ##########
repo_pkgs
#sudo dnf check-update
sudo dnf -y update

########## Install rpm fusion ##########
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y groupupdate core

########## Install flatpak ##########
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

########## Install media codec ##########
sudo dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf -y groupupdate sound-and-video

########## Install pkgs ##########
for pkg in `cat ../pkg-files/dnf-pkgs.txt`
do sudo dnf -y install $pkg
done

########## Setup Python ##########
sudo pip3 install virtualenvwrapper
mkvirtualenv -p python3.9 test

########## Setup zshhistory ##########
touch "$HOME/.cache/zshhistory"
echo source ~/.zshrc
chsh $USER -s /bin/zsh

########## Restart services ##########
systemctl --user restart pipewire

########## Check version ##########
code -v
python --version
pip -V