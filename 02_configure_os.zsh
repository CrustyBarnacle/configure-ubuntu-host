#!/usr/bin/zsh
# Ubuntu OS Configuration Script (Part 2)
# Run after 01_install-setup.sh
# Idempotent - safe to re-run without losing configs
set -e

# Source shared library functions
SCRIPT_DIR="${0:A:h}"
source "${SCRIPT_DIR}/lib/common.zsh"

print_header "Ubuntu Setup v2.0 - OS Configuration"

# =============================================================================
# Status Detection
# =============================================================================

# Check ZSH default shell
if is_shell_zsh; then
    ZSH_STATUS="true"
    ZSH_INFO="Yes"
else
    ZSH_STATUS="false"
    ZSH_INFO="No (currently: $(getent passwd $USER | awk -F: '{print $NF}'))"
fi

# Check fonts
if are_fonts_installed; then
    FONTS_STATUS="true"
    FONTS_INFO="Installed"
else
    FONTS_STATUS="false"
    FONTS_INFO="Not installed"
fi

# Check Powerlevel10k
if is_p10k_installed; then
    P10K_STATUS="true"
    P10K_INFO="Installed"
else
    P10K_STATUS="false"
    P10K_INFO="Not installed"
fi

# Check VScodium
if is_vscodium_installed; then
    VSCODIUM_STATUS="true"
    VSCODIUM_INFO="Installed"
else
    VSCODIUM_STATUS="false"
    VSCODIUM_INFO="Not installed"
fi

# Check aliases configured
if is_aliases_configured; then
    ALIASES_STATUS="true"
    ALIASES_INFO="Yes"
else
    ALIASES_STATUS="false"
    ALIASES_INFO="No"
fi

# Check custom directories
CUSTOM_DIRS=(~/Bin ~/Projects)
DIRS_EXIST=0
for dir in "${CUSTOM_DIRS[@]}"; do
    [[ -d "$dir" ]] && ((DIRS_EXIST++))
done
if [[ $DIRS_EXIST -eq ${#CUSTOM_DIRS[@]} ]]; then
    DIRS_STATUS="true"
    DIRS_INFO="All exist (${DIRS_EXIST}/${#CUSTOM_DIRS[@]})"
else
    DIRS_STATUS="false"
    DIRS_INFO="${DIRS_EXIST}/${#CUSTOM_DIRS[@]} exist"
fi

# =============================================================================
# Display Status Summary
# =============================================================================

echo ""
show_component_status "ZSH default shell" "$ZSH_STATUS" "$ZSH_INFO"
show_component_status "Custom directories" "$DIRS_STATUS" "$DIRS_INFO"
show_component_status "MesloLGS fonts" "$FONTS_STATUS" "$FONTS_INFO"
show_component_status "Powerlevel10k" "$P10K_STATUS" "$P10K_INFO"
show_component_status "VScodium" "$VSCODIUM_STATUS" "$VSCODIUM_INFO"
show_component_status "Aliases configured" "$ALIASES_STATUS" "$ALIASES_INFO"
echo ""

# =============================================================================
# Build Action List
# =============================================================================

ACTIONS=()

[[ "$ZSH_STATUS" == "false" ]] && ACTIONS+=("Set ZSH as default shell")
[[ "$DIRS_STATUS" == "false" ]] && ACTIONS+=("Create custom directories")
[[ "$FONTS_STATUS" == "false" || "$P10K_STATUS" == "false" || "$ALIASES_STATUS" == "false" ]] && ACTIONS+=("Configure ZSH shell")

# VScodium prompt (optional)
INSTALL_VSCODIUM="false"
if [[ "$VSCODIUM_STATUS" == "false" ]]; then
    if prompt_yn "Install VScodium?" "y"; then
        INSTALL_VSCODIUM="true"
        ACTIONS+=("Install VScodium")
    fi
fi

# Check if anything to do
if [[ ${#ACTIONS[@]} -eq 0 ]]; then
    echo -e "${GREEN}Nothing to do - all components configured!${NC}"
    exit 0
fi

# Show actions
echo "Actions to perform:"
for action in "${ACTIONS[@]}"; do
    echo "  - $action"
done
echo ""

# Confirm before proceeding
if ! prompt_yn "Proceed?" "y"; then
    echo "Aborted."
    exit 0
fi

echo ""

# =============================================================================
# Execute Actions
# =============================================================================

# Set ZSH as default shell
if [[ "$ZSH_STATUS" == "false" ]]; then
    print_status "Setting ZSH as default shell..."
    chsh -s "$(which zsh)" "$USER"
    print_success "ZSH set as default shell"
else
    print_skip "ZSH - already default shell"
fi

# Create custom directories
for dir in "${CUSTOM_DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
        print_status "Creating $dir..."
        mkdir -p "$dir"
        print_success "Created $dir"
    else
        print_skip "$dir - already exists"
    fi
done

# Install VScodium (if requested)
if [[ "$INSTALL_VSCODIUM" == "true" ]]; then
    print_status "Installing VScodium..."
    "${SCRIPT_DIR}/install_vscodium.zsh"
else
    if [[ "$VSCODIUM_STATUS" == "true" ]]; then
        print_skip "VScodium - already installed"
    else
        print_skip "VScodium - skipped by user"
    fi
fi

# Configure ZSH (fonts, theme, aliases)
if [[ "$FONTS_STATUS" == "false" || "$P10K_STATUS" == "false" || "$ALIASES_STATUS" == "false" ]]; then
    print_status "Configuring ZSH shell..."
    "${SCRIPT_DIR}/configure_shell.zsh"
else
    print_skip "ZSH configuration - already complete"
fi

# =============================================================================
# Complete
# =============================================================================

echo ""
print_success "Configuration complete!"
echo ""
print_warning "Please restart your shell or run: exec zsh"
echo "This will activate all new configurations."
