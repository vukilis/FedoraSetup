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

###### Repo VirtualBox ######
cat <<EOF | sudo tee /etc/yum.repos.d/virtualbox.repo 
[virtualbox]
name=Fedora $releasever - $basearch - VirtualBox
baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/36/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.virtualbox.org/download/oracle_vbox.asc
EOF

########## Update ##########
#sudo dnf search -y virtualbox
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
for pkg in `cat $SCRIPT_DIR/pkg-files/dnf-pkgs.txt`
do sudo dnf -y install $pkg
done

########## Setup zshhistory ##########  !!! replace to terminal_zsh_script !!!
touch "$HOME/.cache/zshhistory"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
sudo cp -r $SCRIPT_DIR/dotfiles/zsh/. $HOME
sudo cp -r $SCRIPT_DIR/fonts/* /usr/share/fonts/
fc-cache -f -v
sudo chsh $USER -s /bin/zsh
source ~/.zshrc

########## Setup lf file manager ##########
wget https://github.com/gokcehan/lf/releases/download/r8/lf-linux-amd64.tar.gz
tar xvf lf-linux-amd64.tar.gz
sudo mv lf /usr/local/bin
rm -rf lf-linux-amd64.tar.gz

########## Setup Python ##########
pip3 install --user virtualenvwrapper
mkdir ~/.virtualenvs/
source ~/.zshrc
mkvirtualenv -p python3.9 test

########## Setup virtualBox ##########
sudo usermod -a -G vboxusers $USER
newgrp vboxusers
id $USER

########## Setup QEMU ##########
egrep -c '(vmx|svm)' /proc/cpuinfo
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
sudo virsh net-start default
sudo virsh net-autostart default
sudo adduser vukilis libvirt
sudo adduser vukilis libvirt-qemu

########## Restart services ##########
systemctl --user daemon-reload
systemctl --user restart pipewire

########## Check version ##########
code -v
python --version
pip -V