#!/usr/bin/zsh
# Install Hyprland and ecosystem on Ubuntu 25.10+
# Uses cppiber's PPA: https://launchpad.net/~cppiber/+archive/ubuntu/hyprland
set -e

# Check Ubuntu version (require 25.10+)
VERSION_ID=$(grep VERSION_ID /etc/os-release | cut -d'"' -f2)
MAJOR_VERSION=$(echo "$VERSION_ID" | cut -d'.' -f1)
MINOR_VERSION=$(echo "$VERSION_ID" | cut -d'.' -f2)

if [[ $MAJOR_VERSION -lt 25 ]] || [[ $MAJOR_VERSION -eq 25 && $MINOR_VERSION -lt 10 ]]; then
  echo "Error: This script requires Ubuntu 25.10 or newer."
  echo "Detected version: $VERSION_ID"
  exit 1
fi

echo "Ubuntu $VERSION_ID detected. Proceeding with Hyprland installation..."

# Add cppiber's Hyprland PPA
echo "Adding Hyprland PPA..."
sudo add-apt-repository -y ppa:cppiber/hyprland
sudo apt update

# Install Hyprland and full ecosystem
echo "Installing Hyprland and ecosystem packages..."
sudo apt install -y \
  hyprland \
  hyprpaper \
  hyprlock \
  hypridle \
  hyprpicker \
  xdg-desktop-portal-hyprland

echo ""
echo "Hyprland installation complete!"
echo ""
echo "Post-install steps:"
echo "  1. Log out and select 'Hyprland' from your display manager"
echo "  2. Create config at ~/.config/hypr/hyprland.conf"
echo "  3. See https://wiki.hyprland.org for configuration guide"
