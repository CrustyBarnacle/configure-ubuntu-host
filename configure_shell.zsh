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