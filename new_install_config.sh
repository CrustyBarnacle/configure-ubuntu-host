#!/bin/bash
# Enable UFW
sudo ufw enable

# APT packages to install
# `bat` conflicts with another binary, and is installed as `/usr/bin/batcat`
echo 'Installing apt packages...'
sudo apt update && sudo apt install -y bat gnome-tweaks python3 python3-pip python3.10-venv xclip zsh

# Flatpak apps
echo 'Installing flatpak applications...'
flatpak install -y foliate joplin

# set zsh as default
chsh -s $(which zsh)
