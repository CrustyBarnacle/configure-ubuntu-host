# Removing oh-my-zsh - going rogue! :-p

# Install fonts for powerlevel10k
./install_fonts_MesloLGS.zsh
if [ -e ~/.zshrc ]; then
  cp ~/.zshrc ~/.zshrc.bak
fi

cat <<- EOF > ~/.zshrc
# ~/.zshrc
# CrustyBarnacle
# March 10, 2023
# Base ZSH prompt configuration

PROMPT='%F{040}%n%f @ %F{156}%~%f -> '
RPROMPT='%*'
EOF

# ZSH custom folder
mkdir -p $HOME/.zsh/custom
ZSH_CUSTOM=$HOME/.zsh/custom

# Install powerlevel10k
THEME_REPO=$HOME/.zsh/custom/themes/powerlevel10k
if [[ -d $THEME_REPO ]]; then
  echo "Theme already installed."
else
  echo "Installing theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $THEME_REPO
fi

# Add Powerline10k theme
echo 'source $HOME/.zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
exec zsh # Powerline10k wizard should start automatically - uncomment next line if otherwise
# p10k configure

# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $HOME/.zshrc

# Package management aliases
# Create/append to `aliases_apt.zsh`
cat <<- EOF >> ${ZSH_CUSTOM:-$HOME/.zsh/custom}/aliases_apt.zsh
# Package manager aliases (apt, firmware, flatpak)

# APT
alias au="sudo apt update"
alias upgrade="sudo apt upgrade -y && sudo apt dist-upgrade && sudo apt autoremove -y"
alias clean="sudo apt autoclean"
alias apt-all="au && upgrade && clean"

# Firmware
alias fwu="sudo fwupdmgr get-devices && sudo fwupdmgr get-updates && sudo fwupdmgr update -y"

# Flatpak
alias fpu="flatpak update && flatpak upgrade --assumeyes && flatpak remove --unused --assumeyes"
EOF

cat <<- EOF >> ${ZSH_CUSTOM:-$HOME/.zsh/custom}/path.zsh
export PATH=$PATH:~/.local/bin
EOF
