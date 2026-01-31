#!/usr/bin/zsh
# Configure ZSH shell with Powerlevel10k theme
# Idempotent - safe to re-run without losing configs
set -e

# Source shared library functions
SCRIPT_DIR="${0:A:h}"
source "${SCRIPT_DIR}/lib/common.zsh"

print_header "ZSH Shell Configuration"

# Backup existing configs before any modifications
print_status "Backing up existing ZSH configurations..."
backup_zsh_configs

# Install fonts for powerlevel10k (if not already installed)
if are_fonts_installed; then
    print_skip "MesloLGS fonts - already installed"
else
    print_status "Installing MesloLGS fonts..."
    "${SCRIPT_DIR}/install_fonts_MesloLGS.zsh"
    print_success "MesloLGS fonts installed"
fi

# Create base .zshrc if it doesn't exist or is significantly different
# Note: This overwrites the base config but sourced configs are preserved
ZSH_BASE_MARKER="# Base ZSH prompt configuration"

if [[ ! -f "$HOME/.zshrc" ]] || ! grep -q "$ZSH_BASE_MARKER" "$HOME/.zshrc"; then
    print_status "Creating base .zshrc..."
    cat <<- 'EOF' > "$HOME/.zshrc"
# ~/.zshrc
# CrustyBarnacle
# Base ZSH prompt configuration

PROMPT='%F{040}%n%f @ %F{156}%~%f -> '
RPROMPT='%*'

# History file for zsh
HISTFILE=~/.zsh_history

# How many commands to store in history
HISTSIZE=10000
SAVEHIST=10000

# Share history in every terminal session
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
EOF
    print_success "Base .zshrc created"
else
    print_skip ".zshrc - base config already present"
fi

# ZSH custom folder
mkdir -p "$HOME/.zsh/custom"
ZSH_CUSTOM="$HOME/.zsh/custom"

# Install powerlevel10k theme
THEME_REPO="$HOME/.zsh/custom/themes/powerlevel10k"
if [[ -d "$THEME_REPO" ]]; then
    print_skip "Powerlevel10k theme - already installed"
else
    print_status "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_REPO"
    print_success "Powerlevel10k theme installed"
fi

# Package management aliases
# Use > (overwrite) instead of >> (append) to prevent duplicates
ALIASES_FILE="${ZSH_CUSTOM}/aliases_apt.zsh"
if [[ -f "$ALIASES_FILE" ]]; then
    print_skip "APT aliases - already configured"
else
    print_status "Creating APT aliases..."
    cat <<- 'EOF' > "$ALIASES_FILE"
# Package manager aliases (apt, firmware, flatpak)

# APT
alias au="sudo apt update"
alias upgrade="sudo apt upgrade -y && sudo apt dist-upgrade && sudo apt autoremove -y"
alias clean="sudo apt autoclean"
alias apt-all="au && upgrade && clean"

# Firmware
alias fwu="sudo fwupdmgr get-devices && sudo fwupdmgr get-updates && sudo fwupdmgr update -y"

# Flatpak
alias fpu="flatpak update && flatpak upgrade --assumeyes && flatpak remove --unused --assumeyes"
EOF
    print_success "APT aliases created"
fi

# PATH configuration
# Use > (overwrite) instead of >> (append) to prevent duplicates
PATH_FILE="${ZSH_CUSTOM}/path.zsh"
if [[ -f "$PATH_FILE" ]]; then
    print_skip "PATH configuration - already exists"
else
    print_status "Creating PATH configuration..."
    cat <<- 'EOF' > "$PATH_FILE"
export PATH=$PATH:$HOME/.local/bin
EOF
    print_success "PATH configuration created"
fi

# Function to ensure a source line exists in .zshrc without duplicates
ensure_zshrc_sources() {
    local source_line="$1"

    if ! grep -qxF "$source_line" "$HOME/.zshrc"; then
        echo "$source_line" >> "$HOME/.zshrc"
        return 0  # Added
    fi
    return 1  # Already exists
}

# Add source lines to .zshrc (only if not already present)
print_status "Ensuring .zshrc sources are configured..."

# Syntax highlighting
if ensure_zshrc_sources "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; then
    print_success "Added syntax highlighting to .zshrc"
else
    print_skip "Syntax highlighting - already in .zshrc"
fi

# Autosuggestions
if ensure_zshrc_sources "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"; then
    print_success "Added autosuggestions to .zshrc"
else
    print_skip "Autosuggestions - already in .zshrc"
fi

# Powerlevel10k theme
if ensure_zshrc_sources 'source $HOME/.zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme'; then
    print_success "Added Powerlevel10k theme to .zshrc"
else
    print_skip "Powerlevel10k theme - already in .zshrc"
fi

# Source custom files (aliases, path, etc.)
if ensure_zshrc_sources 'for config_file in $HOME/.zsh/custom/*.zsh; do source "$config_file"; done'; then
    print_success "Added custom config sourcing to .zshrc"
else
    print_skip "Custom config sourcing - already in .zshrc"
fi

# Source p10k config if it exists
if ensure_zshrc_sources '[[ -f $HOME/.p10k.zsh ]] && source $HOME/.p10k.zsh'; then
    print_success "Added p10k config sourcing to .zshrc"
else
    print_skip "p10k config sourcing - already in .zshrc"
fi

echo ""
print_success "Shell configuration complete!"
echo ""
print_warning "Please restart your shell or run: exec zsh"
echo "The Powerlevel10k configuration wizard will start automatically on first run."
echo "Run 'p10k configure' to reconfigure at any time."
