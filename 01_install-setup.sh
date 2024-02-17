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
&& sudo apt autoclean && sudo fwupdmgr get-devices && sudo fwupdmgr get-updates && sudo fwupdmgr update \
&& sudo apt install -y bat gnome-tweaks bpython python3 python3-pip python3.10-venv xclip zsh
get_status "Update of apt cache and package installations"

# Flatpak apps
echo 'Installing flatpak applications...'
flatpak install -y foliate joplin
get_status "Flatpak app install"

# set zsh as default shell
DEFAULT_SHELL=$(getent passwd $USER | awk -F: '{print $NF}')
if [[ $DEFAULT_SHELL == $(which zsh) ]]; then
  echo "ZSH already default shell for $USER."
else
  chsh -s $(which zsh) $USER
  get_status "Updating default shell"
fi

exit 0
