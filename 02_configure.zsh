#!/usr/bin/zsh
# Non-zsh apt packages installed via 01_install-setup.sh bash script
# ~/.zshrc updated below, after install of `oh-my-zsh`
sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions

# python pip pipx poetry
echo 'Installing pip/x, poetry...'
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# reload zsh to get updated PATH
. ~/.zshrc
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

# oh-my-zsh
echo 'oh-my-zsh install...'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install fonts for powerlevel10k
install_fonts_MesloLGS.zsh

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# sed delimeter "|" used for clarity
sed -ie 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k\/powerlevel10k"|' ~/.zshrc
exec zsh # Powerline10k wizard should start automatically
# p10k configure

# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${$HOME}/.zshrc
echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${$HOME}/.zshrcS