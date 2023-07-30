#!/usr/bin/env zsh
# Install required utilities, identify drive device, and create udev rule to initialize the drive

# Install sg3 Utils
sudo apt install -y sg3-utils

# Identify drive
DRIVE_DEV=$(ls /dev | grep sr)

# Create UDEV rule to initialze drive when connected
cat <<- EOF | sudo tee  /etc/udev/rules.d/91-superdrive.rules > /dev/null
# Initialise Apple SuperDrive
ACTION=="add", ATTRS{idProduct}=="1500", ATTRS{idVendor}=="05ac", DRIVERS=="usb", RUN+="/usr/bin/sg_raw %r/sr%n EA 00 00 00 00 00 01"
EOF