#!/bin/bash
# Ubuntu Initial Setup Script (Part 1)
# Installs UFW, APT packages, Flatpaks, Snaps, and ZSH
# Idempotent - safe to re-run without reinstalling packages
set -e

# =============================================================================
# Color and print functions (bash versions)
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_status() { echo -e "${YELLOW}[*]${NC} $1"; }
print_success() { echo -e "${GREEN}[+]${NC} $1"; }
print_skip() { echo -e "${CYAN}[SKIP]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }

print_header() {
    echo ""
    echo -e "${BOLD}$1${NC}"
    echo "$(printf '=%.0s' $(seq 1 ${#1}))"
}

# =============================================================================
# Detection functions (bash versions)
# =============================================================================

is_apt_installed() {
    dpkg -s "$1" &>/dev/null
}

is_snap_installed() {
    snap list "$1" &>/dev/null
}

is_flatpak_installed() {
    flatpak list --app 2>/dev/null | grep -qi "$1"
}

is_ufw_enabled() {
    sudo ufw status 2>/dev/null | grep -q "Status: active"
}

# =============================================================================
# Package lists
# =============================================================================

APT_PACKAGES=(
    bat
    flatpak
    python3
    python3-pip
    python3-venv
    xclip
    gnome-tweaks
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
)

FLATPAK_APPS=(
    "com.github.johnfactotum.Foliate:foliate"
)

SNAP_APPS=(
    glow
)

# =============================================================================
# Status Detection
# =============================================================================

print_header "Ubuntu Setup v2.0 - Initial Installation"

# Check UFW
if is_ufw_enabled; then
    UFW_STATUS="installed"
else
    UFW_STATUS="not_installed"
fi

# Count installed APT packages
APT_INSTALLED=0
APT_MISSING=()
for pkg in "${APT_PACKAGES[@]}"; do
    if is_apt_installed "$pkg"; then
        (( APT_INSTALLED++ )) || true
    else
        APT_MISSING+=("$pkg")
    fi
done

# Check Flatpak apps
FLATPAK_MISSING=()
for app_entry in "${FLATPAK_APPS[@]}"; do
    app_id="${app_entry%%:*}"
    app_name="${app_entry##*:}"
    if ! is_flatpak_installed "$app_name"; then
        FLATPAK_MISSING+=("$app_name")
    fi
done

# Check Snap apps
SNAP_MISSING=()
for app in "${SNAP_APPS[@]}"; do
    if ! is_snap_installed "$app"; then
        SNAP_MISSING+=("$app")
    fi
done

# =============================================================================
# Display Status Summary
# =============================================================================

echo ""

# UFW status
if [[ "$UFW_STATUS" == "installed" ]]; then
    echo -e "${GREEN}[+]${NC} UFW firewall        : Enabled"
else
    echo -e "${RED}[-]${NC} UFW firewall        : Not enabled"
fi

# APT packages status
if [[ ${#APT_MISSING[@]} -eq 0 ]]; then
    echo -e "${GREEN}[+]${NC} APT packages        : All installed (${APT_INSTALLED}/${#APT_PACKAGES[@]})"
else
    echo -e "${RED}[-]${NC} APT packages        : ${APT_INSTALLED}/${#APT_PACKAGES[@]} installed"
fi

# Flatpak status
if [[ ${#FLATPAK_MISSING[@]} -eq 0 ]]; then
    echo -e "${GREEN}[+]${NC} Flatpak apps        : All installed"
else
    echo -e "${RED}[-]${NC} Flatpak apps        : ${#FLATPAK_MISSING[@]} missing"
fi

# Snap status
if [[ ${#SNAP_MISSING[@]} -eq 0 ]]; then
    echo -e "${GREEN}[+]${NC} Snap apps           : All installed"
else
    echo -e "${RED}[-]${NC} Snap apps           : ${#SNAP_MISSING[@]} missing"
fi

echo ""

# =============================================================================
# Build Action List
# =============================================================================

ACTIONS=()

[[ "$UFW_STATUS" == "not_installed" ]] && ACTIONS+=("Enable UFW firewall")
[[ ${#APT_MISSING[@]} -gt 0 ]] && ACTIONS+=("Install ${#APT_MISSING[@]} APT package(s)")
[[ ${#FLATPAK_MISSING[@]} -gt 0 ]] && ACTIONS+=("Install ${#FLATPAK_MISSING[@]} Flatpak app(s)")
[[ ${#SNAP_MISSING[@]} -gt 0 ]] && ACTIONS+=("Install ${#SNAP_MISSING[@]} Snap app(s)")

# Check if anything to do
if [[ ${#ACTIONS[@]} -eq 0 ]]; then
    echo -e "${GREEN}Nothing to do - all components installed!${NC}"
    exit 0
fi

# Show actions
echo "Actions to perform:"
for action in "${ACTIONS[@]}"; do
    echo "  - $action"
done
echo ""

# Confirm before proceeding
read -p "Proceed? [Y/n]: " response
if [[ "$response" =~ ^[Nn] ]]; then
    echo "Aborted."
    exit 0
fi

echo ""

# =============================================================================
# Execute Actions
# =============================================================================

# Enable UFW
if [[ "$UFW_STATUS" == "not_installed" ]]; then
    print_status "Enabling UFW with default settings..."
    sudo ufw enable
    print_success "UFW enabled"
else
    print_skip "UFW - already enabled"
fi

# Install APT packages
if [[ ${#APT_MISSING[@]} -gt 0 ]]; then
    print_status "Updating apt cache..."
    sudo apt update

    print_status "Upgrading existing packages..."
    sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt autoclean

    print_status "Installing missing packages: ${APT_MISSING[*]}"
    sudo apt install -y "${APT_MISSING[@]}"
    print_success "APT packages installed"
else
    print_skip "APT packages - all installed"
fi

# Install Flatpak apps
if [[ ${#FLATPAK_MISSING[@]} -gt 0 ]]; then
    # Ensure flathub is configured
    print_status "Configuring Flathub repository..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    for app in "${FLATPAK_MISSING[@]}"; do
        print_status "Installing Flatpak: $app"
        flatpak install -y flathub "$app"
        print_success "Installed $app"
    done
else
    print_skip "Flatpak apps - all installed"
fi

# Install Snap apps
if [[ ${#SNAP_MISSING[@]} -gt 0 ]]; then
    for app in "${SNAP_MISSING[@]}"; do
        print_status "Installing Snap: $app"
        sudo snap install "$app"
        print_success "Installed $app"
    done
else
    print_skip "Snap apps - all installed"
fi

# =============================================================================
# Complete
# =============================================================================

echo ""
print_success "Initial setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run ./02_configure_os.zsh to configure ZSH and install themes"
echo "  2. Optional: Run ./python_setup.zsh for Python development tools"
exit 0
