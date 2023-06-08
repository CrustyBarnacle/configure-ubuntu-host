#!/bin/bash
# Enable UFW
sudo ufw enable

# APT packages to install
# `bat` conflicts with another binary, and is installed as `/usr/bin/batcat`
echo 'Updating apt cache and installing apt packages...'
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade && sudo apt autoremove -y \
&& sudo apt autoclean && sudo fwupdmgr get-devices && sudo fwupdmgr get-updates && sudo fwupdmgr update \
&& sudo apt install -y bat gnome-tweaks python3 python3-pip python3.10-venv xclip zsh

# Flatpak apps
echo 'Installing flatpak applications...'
flatpak install -y foliate joplin

# set zsh as default
chsh -s $(which zsh)
