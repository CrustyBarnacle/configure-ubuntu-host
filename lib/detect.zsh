#!/usr/bin/zsh
# State detection functions for Ubuntu setup scripts

# Check if an APT package is installed
# Usage: is_apt_installed "package-name"
is_apt_installed() {
    dpkg -s "$1" &>/dev/null
}

# Check if a snap package is installed
# Usage: is_snap_installed "package-name"
is_snap_installed() {
    snap list "$1" &>/dev/null
}

# Check if a flatpak is installed
# Usage: is_flatpak_installed "app-id" (e.g., "com.github.johnfactotum.Foliate")
# Also accepts short names like "foliate"
is_flatpak_installed() {
    local app="$1"
    # Check both by ID and by name (case insensitive)
    flatpak list --app 2>/dev/null | grep -qi "$app"
}

# Check if UFW is enabled
is_ufw_enabled() {
    sudo ufw status 2>/dev/null | grep -q "Status: active"
}

# Check if ZSH is the default shell
is_shell_zsh() {
    local current_shell
    current_shell=$(getent passwd "$USER" | awk -F: '{print $NF}')
    [[ "$current_shell" == "$(which zsh)" ]]
}

# Check if VScodium is installed (binary + repo)
is_vscodium_installed() {
    command -v codium &>/dev/null
}

# Check if VScodium apt source is configured
is_vscodium_repo_configured() {
    [[ -f /etc/apt/sources.list.d/vscodium.list ]]
}

# Check if VScodium GPG key exists
is_vscodium_key_installed() {
    [[ -f /usr/share/keyrings/vscodium-archive-keyring.gpg ]]
}

# Check if Powerlevel10k theme is installed
is_p10k_installed() {
    [[ -d "$HOME/.zsh/custom/themes/powerlevel10k" ]]
}

# Check if user has a p10k config file
has_p10k_config() {
    [[ -f "$HOME/.p10k.zsh" ]]
}

# Check if all 4 MesloLGS fonts are installed
are_fonts_installed() {
    local font_dir="$HOME/.local/share/fonts"
    local fonts=(
        'MesloLGS NF Regular.ttf'
        'MesloLGS NF Bold.ttf'
        'MesloLGS NF Italic.ttf'
        'MesloLGS NF Bold Italic.ttf'
    )

    for font in "${fonts[@]}"; do
        if [[ ! -f "${font_dir}/${font}" ]]; then
            return 1
        fi
    done
    return 0
}

# Check if zsh history exists and is non-empty
has_zsh_history() {
    [[ -s "$HOME/.zsh_history" ]]
}

# Check if a command exists
is_command_available() {
    command -v "$1" &>/dev/null
}

# Check if pipx is installed
is_pipx_installed() {
    command -v pipx &>/dev/null
}

# Check if poetry is installed
is_poetry_installed() {
    command -v poetry &>/dev/null
}

# Check if cmus is installed
is_cmus_installed() {
    command -v cmus &>/dev/null
}

# Check if virt-manager is installed (KVM/QEMU)
is_kvm_installed() {
    command -v virt-manager &>/dev/null
}

# Check if Hyprland is installed
is_hyprland_installed() {
    command -v Hyprland &>/dev/null
}

# Check if Hyprland PPA is configured
is_hyprland_ppa_configured() {
    grep -q "cppiber/hyprland" /etc/apt/sources.list.d/*.list 2>/dev/null
}

# Check if Pop Shell extension is installed
is_pop_shell_installed() {
    [[ -d "$HOME/.local/share/gnome-shell/extensions/pop-shell@system76.com" ]]
}

# Check if SuperDrive udev rule exists
is_superdrive_configured() {
    [[ -f /etc/udev/rules.d/91-superdrive.rules ]]
}

# Check if a file contains a specific line (exact match)
file_contains_line() {
    local file="$1"
    local line="$2"
    [[ -f "$file" ]] && grep -qxF "$line" "$file"
}

# Check if a file contains a pattern
file_contains_pattern() {
    local file="$1"
    local pattern="$2"
    [[ -f "$file" ]] && grep -q "$pattern" "$file"
}

# Check if zsh custom directory exists and has aliases
is_aliases_configured() {
    [[ -f "$HOME/.zsh/custom/aliases_apt.zsh" ]]
}

# Check if PATH is configured in zsh
is_path_configured() {
    [[ -f "$HOME/.zsh/custom/path.zsh" ]]
}

# Count installed APT packages from a list
# Usage: count_apt_installed "pkg1" "pkg2" ...
# Returns: prints "installed/total"
count_apt_installed() {
    local packages=("$@")
    local installed=0
    local total=${#packages[@]}

    for pkg in "${packages[@]}"; do
        if is_apt_installed "$pkg"; then
            ((installed++))
        fi
    done

    echo "${installed}/${total}"
}

# Get list of packages not yet installed
# Usage: get_missing_apt_packages "pkg1" "pkg2" ...
# Returns: array of missing package names
get_missing_apt_packages() {
    local packages=("$@")
    local missing=()

    for pkg in "${packages[@]}"; do
        if ! is_apt_installed "$pkg"; then
            missing+=("$pkg")
        fi
    done

    echo "${missing[@]}"
}
