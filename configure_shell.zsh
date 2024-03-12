# Removing oh-my-zsh - going rogue! :-p

# Install fonts for powerlevel10k
install_fonts_MesloLGS.zsh
mkdir

# ZSH custom folder
mkdir $HOME/.zsh/custom
echo "ZSH_CUSTOM=$HOME/.zsh/custom"

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.zsh/custom}/themes/powerlevel10k
# sed delimeter "|" used for clarity
sed -ie 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k\/powerlevel10k"|' ~/.zshrc
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
alias fpu="flatpak update --assumeyes && flatpak upgrade --assumeyes"
EOF

cat <<- EOF >> ${ZSH_CUSTOM:-$HOME/.zsh/custom}/path.zsh
export PATH=$PATH:~/.local/bin
EOF
