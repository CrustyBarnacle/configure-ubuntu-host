#!/usr/bin/env zsh
# Apple SuperDrive udev rule configuration
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
    is_apt_installed() { dpkg -s "$1" &>/dev/null; }
    is_superdrive_configured() { [[ -f /etc/udev/rules.d/91-superdrive.rules ]]; }
fi

print_header "Apple SuperDrive Configuration"

# Check status
echo ""
if is_apt_installed "sg3-utils"; then
    echo -e "${GREEN}[+]${NC} sg3-utils           : Installed"
    SG3_STATUS="installed"
else
    echo -e "${RED}[-]${NC} sg3-utils           : Not installed"
    SG3_STATUS="not_installed"
fi

if is_superdrive_configured; then
    echo -e "${GREEN}[+]${NC} udev rule           : Configured"
    UDEV_STATUS="configured"
else
    echo -e "${RED}[-]${NC} udev rule           : Not configured"
    UDEV_STATUS="not_configured"
fi

echo ""

# Nothing to do?
if [[ "$SG3_STATUS" == "installed" && "$UDEV_STATUS" == "configured" ]]; then
    echo -e "${GREEN}Nothing to do - SuperDrive fully configured!${NC}"
    exit 0
fi

# Build action list
ACTIONS=()
[[ "$SG3_STATUS" == "not_installed" ]] && ACTIONS+=("Install sg3-utils")
[[ "$UDEV_STATUS" == "not_configured" ]] && ACTIONS+=("Create udev rule")

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

# Install sg3-utils
if [[ "$SG3_STATUS" == "not_installed" ]]; then
    print_status "Installing sg3-utils..."
    sudo apt install -y sg3-utils
    print_success "sg3-utils installed"
else
    print_skip "sg3-utils - already installed"
fi

# Create udev rule
if [[ "$UDEV_STATUS" == "not_configured" ]]; then
    print_status "Creating udev rule..."
    cat <<- 'EOF' | sudo tee /etc/udev/rules.d/91-superdrive.rules > /dev/null
# Initialise Apple SuperDrive
ACTION=="add", ATTRS{idProduct}=="1500", ATTRS{idVendor}=="05ac", DRIVERS=="usb", RUN+="/usr/bin/sg_raw %r/sr%n EA 00 00 00 00 00 01"
EOF
    print_success "udev rule created"

    print_status "Reloading udev rules..."
    sudo udevadm control --reload-rules
    print_success "udev rules reloaded"
else
    print_skip "udev rule - already configured"
fi

echo ""
print_success "SuperDrive configuration complete!"
echo ""
echo "The SuperDrive will now initialize automatically when connected."
