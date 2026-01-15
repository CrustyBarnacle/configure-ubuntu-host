#!/usr/bin/zsh
# https://ubuntu.com/blog/kvm-hyphervisor
set -e

# Install the required packages
sudo apt install -y bridge-utils cpu-checker libvirt-clients libvirt-daemon qemu-system qemu-kvm

# Check KVM support
kvm-ok

# Install virt-manager (Graphical desktop application for managing virtual machines)
sudo apt install -y virt-manager

# Add user to groups to run VMs without sudo/root privileges
# TODO
