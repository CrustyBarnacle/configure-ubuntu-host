#!/usr/bin/zsh
# Shared utility functions for Ubuntu setup scripts
# Source this file at the top of each script

# Get the directory where this script lives
LIB_DIR="${0:A:h}"

# Color constants
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Status indicators
INSTALLED="${GREEN}[+]${NC}"
NOT_INSTALLED="${RED}[-]${NC}"
SKIP="${CYAN}[SKIP]${NC}"
WORKING="${YELLOW}[*]${NC}"

# Print functions
print_status() {
    echo -e "${WORKING} $1"
}

print_success() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_skip() {
    echo -e "${SKIP} $1"
}

print_header() {
    echo ""
    echo -e "${BOLD}$1${NC}"
    echo "$(printf '=%.0s' {1..${#1}})"
}

# Yes/No prompt with default
# Usage: prompt_yn "Install package?" "y" && do_something
# Returns 0 for yes, 1 for no
prompt_yn() {
    local prompt="$1"
    local default="${2:-y}"
    local response

    if [[ "$default" == "y" || "$default" == "Y" ]]; then
        read "response?${prompt} [Y/n]: "
        [[ -z "$response" || "$response" =~ ^[Yy]$ ]]
    else
        read "response?${prompt} [y/N]: "
        [[ "$response" =~ ^[Yy]$ ]]
    fi
}

# Display status of a component
# Usage: show_component_status "Component name" status_check_result "extra info"
show_component_status() {
    local name="$1"
    local installed="$2"
    local extra="${3:-}"

    local padded_name=$(printf "%-20s" "$name")
    if [[ "$installed" == "true" ]]; then
        if [[ -n "$extra" ]]; then
            echo -e "${INSTALLED} ${padded_name}: ${extra}"
        else
            echo -e "${INSTALLED} ${padded_name}: Installed"
        fi
    else
        if [[ -n "$extra" ]]; then
            echo -e "${NOT_INSTALLED} ${padded_name}: ${extra}"
        else
            echo -e "${NOT_INSTALLED} ${padded_name}: Not installed"
        fi
    fi
}

# Display summary of all components
# Takes an associative array of component => status pairs
show_summary() {
    print_header "System Status"

    local -A components
    components=("${(@Pkv)1}")

    for component status in "${(@kv)components}"; do
        show_component_status "$component" "$status"
    done
    echo ""
}

# Show actions that will be performed
# Usage: show_actions "action1" "action2" ...
show_actions() {
    local actions=("$@")

    if [[ ${#actions[@]} -eq 0 ]]; then
        echo -e "${GREEN}Nothing to do - all components installed!${NC}"
        return 1
    fi

    echo "Actions to perform:"
    for action in "${actions[@]}"; do
        echo "  - $action"
    done
    echo ""
    return 0
}

# Source other lib files
source "${LIB_DIR}/detect.zsh"
source "${LIB_DIR}/backup.zsh"
