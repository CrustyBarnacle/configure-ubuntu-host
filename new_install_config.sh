#!/bin/bash
# APT packages to install
echo 'Installing apt packages...'
sudo apt install -y bat python3 python3-pip python3.10-venv xclip zsh

# Flatpak apps
echo 'Installing flatpak applications...'
flatpak install -y foliate joplin

# python pip pipx poetry
echo 'Installing pip/x, poetry...'
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# reload zsh to get updated PATH
# But... we're in BASH :-p
#. ~/.zshrc
. ~/.bashrc
pipx install poetry

# Create custom dirs
echo 'Creating ~/Bin, ~/Projects'
mkdir ~/Bin ~/Projects

# Other install methods (curl/Git/Wget)
# oh-my-zsh
echo 'oh-my-zsh install...'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"