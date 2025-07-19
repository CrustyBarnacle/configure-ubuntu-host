#!/usr/bin/zsh
# Install dependencies and clone source and install Pop!_OS shell

# Build Dependencies
sudo apt install -y git node-typescript make gnome-shell-extension-prefs


# Clone shell repo and build the package
cd ~/Projects

if [ ! -d "shell" ]; then
  git clone --depth=1 https://github.com/pop-os/shell.git
fi

cd ./shell
make local-install