#!/usr/bin/zsh
# KVM/QEMU virtualization setup
# https://ubuntu.com/blog/kvm-hyphervisor
# Idempotent - safe to re-run
set -e

# Source shared library if available
SCRIPT_DIR="${0:A:h}"
if [[ -f "${SCRIPT_DIR}/lib/common.zsh" ]]; then
    source "${SCRIPT_DIR}/lib/common.zsh"
else
    # Minimal fallback
    print_status() { echo "[*] $1"; }
    print_success() { echo "[+] $1"; }
    print_skip() { echo "[SKIP] $1"; }
    print_warning() { echo "[!] $1"; }
    is_apt_installed() { dpkg -s "$1" &>/dev/null; }
    is_kvm_installed() { command -v virt-manager &>/dev/null; }
fi

print_header "KVM/QEMU Virtualization Setup"

# Package lists
KVM_PACKAGES=(
    bridge-utils
    cpu-checker
    libvirt-clients
    libvirt-daemon
    qemu-system
    qemu-kvm
    virt-manager
)

# Check current status
PACKAGES_INSTALLED=0
PACKAGES_MISSING=()
for pkg in "${KVM_PACKAGES[@]}"; do
    if is_apt_installed "$pkg"; then
        (( PACKAGES_INSTALLED++ )) || true
    else
        PACKAGES_MISSING+=("$pkg")
    fi
done

# Display status
echo ""
if [[ ${#PACKAGES_MISSING[@]} -eq 0 ]]; then
    echo -e "${GREEN}[+]${NC} KVM/QEMU packages   : All installed (${PACKAGES_INSTALLED}/${#KVM_PACKAGES[@]})"
else
    echo -e "${RED}[-]${NC} KVM/QEMU packages   : ${PACKAGES_INSTALLED}/${#KVM_PACKAGES[@]} installed"
fi

# Check if user is in libvirt group
if groups "$USER" | grep -q "libvirt"; then
    echo -e "${GREEN}[+]${NC} User groups         : libvirt membership OK"
    IN_LIBVIRT_GROUP="true"
else
    echo -e "${RED}[-]${NC} User groups         : Not in libvirt group"
    IN_LIBVIRT_GROUP="false"
fi

echo ""

# Nothing to do?
if [[ ${#PACKAGES_MISSING[@]} -eq 0 && "$IN_LIBVIRT_GROUP" == "true" ]]; then
    echo -e "${GREEN}Nothing to do - KVM/QEMU fully configured!${NC}"
    exit 0
fi

# Build action list
ACTIONS=()
[[ ${#PACKAGES_MISSING[@]} -gt 0 ]] && ACTIONS+=("Install ${#PACKAGES_MISSING[@]} KVM package(s)")
[[ "$IN_LIBVIRT_GROUP" == "false" ]] && ACTIONS+=("Add user to libvirt group")

echo "Actions to perform:"
for action in "${ACTIONS[@]}"; do
    echo "  - $action"
done
echo ""

# Confirm
if ! prompt_yn "Proceed?" "y" 2>/dev/null; then
    read "response?Proceed? [Y/n]: "
    if [[ "$response" =~ ^[Nn] ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo ""

# Install packages
if [[ ${#PACKAGES_MISSING[@]} -gt 0 ]]; then
    print_status "Installing KVM/QEMU packages..."
    sudo apt install -y "${PACKAGES_MISSING[@]}"
    print_success "KVM/QEMU packages installed"
else
    print_skip "KVM/QEMU packages - all installed"
fi

# Check KVM support
print_status "Checking KVM support..."
if kvm-ok; then
    print_success "KVM acceleration available"
else
    print_warning "KVM acceleration may not be available"
fi

# Add user to libvirt group
if [[ "$IN_LIBVIRT_GROUP" == "false" ]]; then
    print_status "Adding $USER to libvirt group..."
    sudo usermod -aG libvirt "$USER"
    print_success "Added to libvirt group"
    print_warning "Log out and back in for group membership to take effect"
else
    print_skip "User already in libvirt group"
fi

echo ""
print_success "KVM/QEMU setup complete!"
echo ""
echo "To start using virtualization:"
echo "  1. Log out and back in (for group membership)"
echo "  2. Run 'virt-manager' to launch the graphical VM manager"
