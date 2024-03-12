#!/usr/bin/zsh
# CrustyBarnacle
# Nerd font for powerline10k (MesloLGS NF)
# https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

fonts=(
     'MesloLGS NF Regular.ttf'
     'MesloLGS NF Bold.ttf'
     'MesloLGS NF Italic.ttf'
     'MesloLGS NF Bold Italic.ttf'
)

url="https://github.com/romkatv/powerlevel10k-media/raw/master/"

# Fetch Nerds Meslo ttf font files
for font in $fonts; do
wget ${font/#/$url};
done

if [ ! -d "~/.local/share/fonts/" ]; then
  mkdir -p ~/.local/share/fonts/
fi

for font in $fonts; do
cp $font ~/.local/share/fonts/;
done

# rebuild font cache
fc-cache -f

# manually add/change font for individual applications as needed
# looking at you Gnome Terminal :-/
