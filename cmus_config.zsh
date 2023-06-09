#!/usr/bin/zsh
# cmus setup (install if not already available)

# Install cmus
if [ cmus ]; then
  echo cmus alredy installed
  echo  $(which cmus)
else
  echo Installing cmus...
  sudo apt install -y cmus
fi

# Clone somafm repo, get stations, and create cmus playlist
cd ~/Documents/Projects

if [ ! -d "somafm" ]; then
  git clone --depth=1 https://github.com/CrustyBarnacle/somafm.git
fi

cd ./somafm

if [  ! -f "pyproject.toml" ]; then
  poetry init -n
fi

poetry install
poetry run python3 somafm.py | sed 's/https/http/' > ~/.config/cmus/playlists/soma_channels_http.pl
S