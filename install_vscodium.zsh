#!/usr/bin/zsh
# Install VScodium - Open source VS Code alternative
# https://vscodium.com/#install
# Idempotent - skips if already installed
set -e

# Source shared library if available (may be called standalone)
SCRIPT_DIR="${0:A:h}"
if [[ -f "${SCRIPT_DIR}/lib/common.zsh" ]]; then
    source "${SCRIPT_DIR}/lib/common.zsh"
else
    # Minimal fallback if lib not available
    print_status() { echo "[*] $1"; }
    print_success() { echo "[+] $1"; }
    print_skip() { echo "[SKIP] $1"; }
    is_vscodium_installed() { command -v codium &>/dev/null; }
    is_vscodium_key_installed() { [[ -f /usr/share/keyrings/vscodium-archive-keyring.gpg ]]; }
    is_vscodium_repo_configured() { [[ -f /etc/apt/sources.list.d/vscodium.list ]]; }
fi

# Check if VScodium is already installed
if is_vscodium_installed; then
    print_skip "VScodium - already installed ($(codium --version | head -1))"
    exit 0
fi

print_status "Installing VScodium..."

# Add the GPG key (if not already present)
if is_vscodium_key_installed; then
    print_skip "VScodium GPG key - already installed"
else
    print_status "Adding VScodium GPG key..."
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
        | gpg --dearmor \
        | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg 2>/dev/null
    print_success "GPG key added"
fi

# Add the repository (if not already present)
if is_vscodium_repo_configured; then
    print_skip "VScodium repository - already configured"
else
    print_status "Adding VScodium repository..."
    echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
        | sudo tee /etc/apt/sources.list.d/vscodium.list > /dev/null
    print_success "Repository added"
fi

# Update apt cache and install VScodium
print_status "Installing VScodium package..."
sudo apt update
sudo apt install -y codium

print_success "VScodium installed successfully"
