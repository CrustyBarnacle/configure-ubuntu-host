#!/usr/bin/zsh
# Install Hyprland and ecosystem on Ubuntu 25.10+
# Uses cppiber's PPA: https://launchpad.net/~cppiber/+archive/ubuntu/hyprland
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
    print_error() { echo "[!] $1"; }
    is_apt_installed() { dpkg -s "$1" &>/dev/null; }
    is_hyprland_installed() { command -v Hyprland &>/dev/null; }
    is_hyprland_ppa_configured() { grep -q "cppiber/hyprland" /etc/apt/sources.list.d/*.list 2>/dev/null; }
fi

print_header "Hyprland Window Manager Setup"

# Check Ubuntu version (require 25.10+)
VERSION_ID=$(grep VERSION_ID /etc/os-release | cut -d'"' -f2)
MAJOR_VERSION=$(echo "$VERSION_ID" | cut -d'.' -f1)
MINOR_VERSION=$(echo "$VERSION_ID" | cut -d'.' -f2)

if [[ $MAJOR_VERSION -lt 25 ]] || [[ $MAJOR_VERSION -eq 25 && $MINOR_VERSION -lt 10 ]]; then
    print_error "This script requires Ubuntu 25.10 or newer."
    echo "Detected version: $VERSION_ID"
    exit 1
fi

echo "Ubuntu $VERSION_ID detected."
echo ""

# Package list
HYPRLAND_PACKAGES=(
    hyprland
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    xdg-desktop-portal-hyprland
)

# Check current status
PACKAGES_INSTALLED=0
PACKAGES_MISSING=()
for pkg in "${HYPRLAND_PACKAGES[@]}"; do
    if is_apt_installed "$pkg"; then
        (( PACKAGES_INSTALLED++ )) || true
    else
        PACKAGES_MISSING+=("$pkg")
    fi
done

# Display status
if is_hyprland_ppa_configured; then
    echo -e "${GREEN}[+]${NC} Hyprland PPA        : Configured"
    PPA_STATUS="configured"
else
    echo -e "${RED}[-]${NC} Hyprland PPA        : Not configured"
    PPA_STATUS="not_configured"
fi

if [[ ${#PACKAGES_MISSING[@]} -eq 0 ]]; then
    echo -e "${GREEN}[+]${NC} Hyprland packages   : All installed (${PACKAGES_INSTALLED}/${#HYPRLAND_PACKAGES[@]})"
else
    echo -e "${RED}[-]${NC} Hyprland packages   : ${PACKAGES_INSTALLED}/${#HYPRLAND_PACKAGES[@]} installed"
fi

echo ""

# Nothing to do?
if [[ "$PPA_STATUS" == "configured" && ${#PACKAGES_MISSING[@]} -eq 0 ]]; then
    echo -e "${GREEN}Nothing to do - Hyprland fully installed!${NC}"
    exit 0
fi

# Build action list
ACTIONS=()
[[ "$PPA_STATUS" == "not_configured" ]] && ACTIONS+=("Add Hyprland PPA")
[[ ${#PACKAGES_MISSING[@]} -gt 0 ]] && ACTIONS+=("Install ${#PACKAGES_MISSING[@]} Hyprland package(s)")

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

# Add PPA
if [[ "$PPA_STATUS" == "not_configured" ]]; then
    print_status "Adding Hyprland PPA..."
    sudo add-apt-repository -y ppa:cppiber/hyprland
    sudo apt update
    print_success "Hyprland PPA added"
else
    print_skip "Hyprland PPA - already configured"
fi

# Install packages
if [[ ${#PACKAGES_MISSING[@]} -gt 0 ]]; then
    print_status "Installing Hyprland packages..."
    sudo apt install -y "${PACKAGES_MISSING[@]}"
    print_success "Hyprland packages installed"
else
    print_skip "Hyprland packages - all installed"
fi

echo ""
print_success "Hyprland installation complete!"
echo ""
echo "Post-install steps:"
echo "  1. Log out and select 'Hyprland' from your display manager"
echo "  2. Create config at ~/.config/hypr/hyprland.conf"
echo "  3. See https://wiki.hyprland.org for configuration guide"
