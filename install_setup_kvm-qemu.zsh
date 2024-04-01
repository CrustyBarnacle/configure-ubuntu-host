#!/usr/bin/zsh
# https://ubuntu.com/blog/kvm-hyphervisor

# Source Library/Functions
. ./function_library

# Install the required packages
sudo apt -y install bridge-utils cpu-checker libvirt-clients libvirt-daemon qemu-system qemu-kvm

# Add the repository:
kvm-ok
get_status "Check kvm_ok"

# Install virt-manager (Graphical desktop application for managing virtual machines)
sudo apt -y install virt-manager
get_status "Install virt-manager"
