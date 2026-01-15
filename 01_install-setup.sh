#!/bin/bash
set -e

# Enable UFW (default incoming:deny, outgoing:allow)
echo "Enabling UFW with default settings..."
sudo ufw enable

# APT packages to install
# `bat` conflicts with another binary, and is installed as `/usr/bin/batcat`
echo 'Updating apt cache and installing apt packages...'
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade && sudo apt autoremove -y \
&& sudo apt autoclean \
&& sudo apt install -y bat flatpak python3 python3-pip python3-venv xclip gnome-tweaks

# Flatpak apps
echo 'Installing flatpak applications...'
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Uncomment joplin below if you want to install it.
flatpak install -y foliate #joplin

# ZSH install
echo 'Instaling zsh, autosuggestions, syntax-highlighting...'
# ~/.zshrc updated below, after install of `oh-my-zsh`
sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions

echo "Setup complete."
exit 0
