#!/bin/bash
# Source Library/Functions
. ./function_library

# Enable UFW (default incoming:deny, outgoing:allow)
echo "Enabling UFW with default settings..."
sudo ufw enable
get_status "Enabling UFW"

# APT packages to install
# `bat` conflicts with another binary, and is installed as `/usr/bin/batcat`
echo 'Updating apt cache and installing apt packages...'
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade && sudo apt autoremove -y \
&& sudo apt autoclean \
&& sudo apt install -y bat flatpak python3 python3-pip python3-venv xclip
get_status "Update of apt cache and package installations"

# Flatpak apps
echo 'Installing flatpak applications...'
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y foliate joplin
get_status "Flatpak app install"

exit 0
