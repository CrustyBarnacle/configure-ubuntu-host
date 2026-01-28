#!/usr/bin/zsh
# Install Pop!_OS Shell tiling extension
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
    is_pop_shell_installed() { [[ -d "$HOME/.local/share/gnome-shell/extensions/pop-shell@system76.com" ]]; }
fi

print_header "Pop!_OS Shell Tiling Extension"

# Build dependencies
BUILD_DEPS=(
    git
    node-typescript
    make
    gnome-shell-extension-prefs
)

# Check dependencies
DEPS_INSTALLED=0
DEPS_MISSING=()
for pkg in "${BUILD_DEPS[@]}"; do
    if is_apt_installed "$pkg"; then
        ((DEPS_INSTALLED++))
    else
        DEPS_MISSING+=("$pkg")
    fi
done

# Display status
echo ""
if [[ ${#DEPS_MISSING[@]} -eq 0 ]]; then
    echo -e "${GREEN}[+]${NC} Build dependencies  : All installed (${DEPS_INSTALLED}/${#BUILD_DEPS[@]})"
else
    echo -e "${RED}[-]${NC} Build dependencies  : ${DEPS_INSTALLED}/${#BUILD_DEPS[@]} installed"
fi

if is_pop_shell_installed; then
    echo -e "${GREEN}[+]${NC} Pop Shell extension : Installed"
    EXTENSION_STATUS="installed"
else
    echo -e "${RED}[-]${NC} Pop Shell extension : Not installed"
    EXTENSION_STATUS="not_installed"
fi

echo ""

# Nothing to do?
if [[ ${#DEPS_MISSING[@]} -eq 0 && "$EXTENSION_STATUS" == "installed" ]]; then
    echo -e "${GREEN}Nothing to do - Pop Shell fully installed!${NC}"
    echo ""
    echo "To enable: Open 'Extensions' app and enable Pop Shell"
    exit 0
fi

# Build action list
ACTIONS=()
[[ ${#DEPS_MISSING[@]} -gt 0 ]] && ACTIONS+=("Install ${#DEPS_MISSING[@]} build dependencies")
[[ "$EXTENSION_STATUS" == "not_installed" ]] && ACTIONS+=("Clone and build Pop Shell")

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

# Install build dependencies
if [[ ${#DEPS_MISSING[@]} -gt 0 ]]; then
    print_status "Installing build dependencies..."
    sudo apt install -y "${DEPS_MISSING[@]}"
    print_success "Build dependencies installed"
else
    print_skip "Build dependencies - all installed"
fi

# Clone and build
if [[ "$EXTENSION_STATUS" == "not_installed" ]]; then
    PROJECTS_DIR="$HOME/Projects"
    mkdir -p "$PROJECTS_DIR"

    SHELL_DIR="$PROJECTS_DIR/shell"

    if [[ -d "$SHELL_DIR" ]]; then
        print_skip "Pop Shell repo - already cloned"
    else
        print_status "Cloning Pop Shell repository..."
        git clone --depth=1 https://github.com/pop-os/shell.git "$SHELL_DIR"
        print_success "Pop Shell repo cloned"
    fi

    print_status "Building and installing Pop Shell..."
    cd "$SHELL_DIR"
    make local-install
    print_success "Pop Shell installed"
else
    print_skip "Pop Shell - already installed"
fi

echo ""
print_success "Pop Shell setup complete!"
echo ""
echo "To enable:"
echo "  1. Open the 'Extensions' application"
echo "  2. Enable 'Pop Shell'"
echo "  3. You may need to log out and back in"
