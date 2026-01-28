#!/usr/bin/zsh
# Install Python development tools: pipx and poetry
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
    print_warning() { echo "[!] $1"; }
    is_pipx_installed() { command -v pipx &>/dev/null; }
    is_poetry_installed() { command -v poetry &>/dev/null; }
fi

echo "Installing Python development tools (pipx, poetry)..."

# Install pipx (if not already installed)
if is_pipx_installed; then
    print_skip "pipx - already installed ($(pipx --version))"
else
    print_status "Installing pipx..."
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
    print_success "pipx installed"

    # Update PATH for current session so poetry install works
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install poetry (if not already installed)
if is_poetry_installed; then
    print_skip "poetry - already installed ($(poetry --version))"
else
    # Ensure pipx is available in current session
    if ! command -v pipx &>/dev/null; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    print_status "Installing poetry..."
    pipx install poetry
    print_success "poetry installed"
fi

echo ""
print_success "Python development tools setup complete!"
echo ""
print_warning "Please restart your shell or run: exec zsh"
echo "This ensures the updated PATH is available."
