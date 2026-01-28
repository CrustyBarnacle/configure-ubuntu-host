#!/usr/bin/zsh
# CrustyBarnacle
# Nerd font for powerline10k (MesloLGS NF)
# https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
# Idempotent - skips download if fonts already installed
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
fi

FONT_DIR="$HOME/.local/share/fonts"
FONTS=(
    'MesloLGS NF Regular.ttf'
    'MesloLGS NF Bold.ttf'
    'MesloLGS NF Italic.ttf'
    'MesloLGS NF Bold Italic.ttf'
)
URL_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master/"

# Check if all fonts are already installed
all_fonts_installed() {
    for font in "${FONTS[@]}"; do
        if [[ ! -f "${FONT_DIR}/${font}" ]]; then
            return 1
        fi
    done
    return 0
}

# If all fonts are installed, skip
if all_fonts_installed; then
    print_skip "MesloLGS fonts - all 4 fonts already installed"
    exit 0
fi

print_status "Installing MesloLGS fonts..."

# Create fonts directory
mkdir -p "$FONT_DIR"

# Create temp directory for downloads
TEMP_DIR=$(mktemp -d)
trap "rm -rf '$TEMP_DIR'" EXIT

# Download and install only missing fonts
cd "$TEMP_DIR"

for font in "${FONTS[@]}"; do
    if [[ -f "${FONT_DIR}/${font}" ]]; then
        print_skip "${font} - already installed"
    else
        print_status "Downloading ${font}..."
        wget -q "${URL_BASE}${font// /%20}" -O "$font"
        cp "$font" "$FONT_DIR/"
        print_success "Installed ${font}"
    fi
done

# Rebuild font cache
print_status "Rebuilding font cache..."
fc-cache -f

print_success "MesloLGS fonts installation complete"
echo ""
echo "Note: You may need to manually set the font in your terminal application."
echo "Font name: MesloLGS NF"
