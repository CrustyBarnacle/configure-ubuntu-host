#!/usr/bin/zsh
# cmus setup - music player with SomaFM playlist
# Requires: poetry (run python_setup.zsh first)
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
    is_cmus_installed() { command -v cmus &>/dev/null; }
    is_poetry_installed() { command -v poetry &>/dev/null; }
fi

print_header "cmus Music Player Setup"

# Check for poetry dependency
if ! is_poetry_installed; then
    print_error "poetry is required but not installed."
    echo "Please run ./python_setup.zsh first."
    exit 1
fi

# Install cmus if not present
if is_cmus_installed; then
    print_skip "cmus - already installed ($(which cmus))"
else
    print_status "Installing cmus..."
    sudo apt install -y cmus
    print_success "cmus installed"
fi

# Ensure Projects directory exists
PROJECTS_DIR="$HOME/Projects"
if [[ ! -d "$PROJECTS_DIR" ]]; then
    print_status "Creating $PROJECTS_DIR..."
    mkdir -p "$PROJECTS_DIR"
fi

# Clone somafm repo if not present
SOMAFM_DIR="$PROJECTS_DIR/somafm"
if [[ -d "$SOMAFM_DIR" ]]; then
    print_skip "somafm repo - already cloned"
else
    print_status "Cloning somafm repository..."
    git clone --depth=1 https://github.com/CrustyBarnacle/somafm.git "$SOMAFM_DIR"
    print_success "somafm repo cloned"
fi

cd "$SOMAFM_DIR"

# Initialize poetry project if needed
if [[ ! -f "pyproject.toml" ]]; then
    print_status "Initializing poetry project..."
    poetry init -n
fi

# Install dependencies and generate playlist
print_status "Installing dependencies and generating playlist..."
poetry install

# Ensure cmus playlist directory exists
CMUS_PLAYLIST_DIR="$HOME/.config/cmus/playlists"
mkdir -p "$CMUS_PLAYLIST_DIR"

# Generate playlist
PLAYLIST_FILE="$CMUS_PLAYLIST_DIR/soma_channels_http.pl"
print_status "Generating SomaFM playlist..."
poetry run python3 somafm.py | sed 's/https/http/' > "$PLAYLIST_FILE"

print_success "SomaFM playlist created at: $PLAYLIST_FILE"
echo ""
echo "To use: Open cmus and load the playlist with ':load $PLAYLIST_FILE'"
