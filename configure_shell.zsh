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

# Package management aliases
# Create/append to `aliases_apt.zsh`
cat <<- EOF >> ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/aliases_apt.zsh
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

cat <<- EOF >> ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/path.zsh
export PATH=$PATH:~/.local/bin
EOF