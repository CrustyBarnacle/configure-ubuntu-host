#!/usr/bin/zsh
# Source Library/Functions
. ./function_library

# Non-zsh apt packages installed via 01_install-setup.sh bash script
# ~/.zshrc updated below, after install of `oh-my-zsh`
sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions

# python pip pipx poetry
echo 'Installing pip/x, poetry...'
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# reload zsh to get updated PATH
exec zsh
pipx install poetry

# Create custom dirs
CUSTOM_DIRS=(
    ~/Bin
    ~/Projects
    )
for dir in $CUSTOM_DIRS;
    if [ ! -d "$dir" ]; then
    echo "Creating $dir"
    mkdir "$dir"
    else
    echo "$dir exists"
    fi

# Other install methods (curl/Git/Wget/scripts)
# install VScodium
install_vscodium.zsh
get_status "Installing vscodium..."

# Configure ZSH
configure_shell.zsh
get_status "ZSH setup..."