#!/usr/bin/zsh
# Source Library/Functions
. ./function_library

# Non-zsh apt packages installed via 01_install-setup.sh bash script
# ~/.zshrc updated below, after install of `oh-my-zsh`
sudo apt install -y  zsh zsh-syntax-highlighting zsh-autosuggestions

# set zsh as default shell
DEFAULT_SHELL=$(getent passwd $USER | awk -F: '{print $NF}')
if [[ $DEFAULT_SHELL == $(which zsh) ]]; then
  echo "ZSH already default shell for $USER."
else
  chsh -s $(which zsh) $USER
  get_status "Updating default shell"
fi

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
