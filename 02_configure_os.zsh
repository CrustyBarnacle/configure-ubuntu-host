#!/usr/bin/zsh
set -e

# set zsh as default shell
DEFAULT_SHELL=$(getent passwd $USER | awk -F: '{print $NF}')
if [[ $DEFAULT_SHELL == $(which zsh) ]]; then
  echo "ZSH already default shell for $USER."
else
  chsh -s $(which zsh) $USER
fi

# Create custom dirs
CUSTOM_DIRS=(
    ~/Bin
    ~/Projects
    )
for dir in $CUSTOM_DIRS;
    if [[ ! -d "$dir" ]]; then
    echo "Creating $dir"
    mkdir "$dir"
    else
    echo "$dir exists"
    fi

# Other install methods (curl/Git/Wget/scripts)
# install VScodium
echo "Install vscodium? (y/n)"
read 'choice?>> '

if [[ ${choice} == 'y' ]]; then
  ./install_vscodium.zsh
else
  echo "Not installing vscodium."
fi

# Configure ZSH
./configure_shell.zsh

echo "Configuration complete."
exit 0
