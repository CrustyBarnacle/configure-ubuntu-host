#!/usr/bin/zsh
# Backup management functions for Ubuntu setup scripts

# Backup directory root
BACKUP_ROOT="$HOME/.config/ubuntu-setup-backups"

# Current session backup directory (set by create_backup_session)
BACKUP_SESSION=""

# Create a new backup session with timestamp
# Usage: create_backup_session
# Sets BACKUP_SESSION to the new directory path
create_backup_session() {
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    BACKUP_SESSION="${BACKUP_ROOT}/${timestamp}"

    mkdir -p "$BACKUP_SESSION"
    echo "$BACKUP_SESSION"
}

# Backup a single file, preserving directory structure
# Usage: backup_file "/path/to/file"
# Returns 0 on success, 1 if file doesn't exist
backup_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    # Create backup session if not already created
    if [[ -z "$BACKUP_SESSION" ]]; then
        create_backup_session >/dev/null
    fi

    # Preserve directory structure relative to home
    local rel_path="${file#$HOME/}"
    local backup_path="${BACKUP_SESSION}/${rel_path}"
    local backup_dir="${backup_path:h}"

    mkdir -p "$backup_dir"
    cp -p "$file" "$backup_path"

    return 0
}

# Backup a directory recursively
# Usage: backup_dir "/path/to/directory"
# Returns 0 on success, 1 if directory doesn't exist
backup_dir() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        return 1
    fi

    # Create backup session if not already created
    if [[ -z "$BACKUP_SESSION" ]]; then
        create_backup_session >/dev/null
    fi

    # Preserve directory structure relative to home
    local rel_path="${dir#$HOME/}"
    local backup_path="${BACKUP_SESSION}/${rel_path}"
    local backup_parent="${backup_path:h}"

    mkdir -p "$backup_parent"
    cp -rp "$dir" "$backup_path"

    return 0
}

# List all available backups
# Usage: list_backups
list_backups() {
    if [[ ! -d "$BACKUP_ROOT" ]]; then
        echo "No backups found."
        return 1
    fi

    echo "Available backups in ${BACKUP_ROOT}:"
    echo ""

    local backups=("${BACKUP_ROOT}"/*(N/On))  # Directories, sorted newest first

    if [[ ${#backups[@]} -eq 0 ]]; then
        echo "  No backups found."
        return 1
    fi

    for backup in "${backups[@]}"; do
        local name="${backup:t}"
        local date="${name[1,8]}"
        local time="${name[10,15]}"
        local formatted_date="${date[1,4]}-${date[5,6]}-${date[7,8]}"
        local formatted_time="${time[1,2]}:${time[3,4]}:${time[5,6]}"

        # Count files in backup
        local file_count=$(find "$backup" -type f 2>/dev/null | wc -l)

        echo "  ${formatted_date} ${formatted_time} - ${file_count} file(s)"
        # List backed up files
        find "$backup" -type f 2>/dev/null | while read -r file; do
            local rel="${file#${backup}/}"
            echo "    - ${rel}"
        done
    done
}

# Backup critical zsh files before modification
# Usage: backup_zsh_configs
# Backs up: .zshrc, .zsh_history, .p10k.zsh, .zsh/custom/
backup_zsh_configs() {
    local backed_up=0

    # Create backup session
    create_backup_session >/dev/null

    # Backup .zshrc
    if [[ -f "$HOME/.zshrc" ]]; then
        backup_file "$HOME/.zshrc" && ((backed_up++))
    fi

    # Backup zsh history (critical - never lose this)
    if [[ -f "$HOME/.zsh_history" ]]; then
        backup_file "$HOME/.zsh_history" && ((backed_up++))
    fi

    # Backup p10k config
    if [[ -f "$HOME/.p10k.zsh" ]]; then
        backup_file "$HOME/.p10k.zsh" && ((backed_up++))
    fi

    # Backup custom zsh directory
    if [[ -d "$HOME/.zsh/custom" ]]; then
        backup_dir "$HOME/.zsh/custom" && ((backed_up++))
    fi

    if [[ $backed_up -gt 0 ]]; then
        echo "Backed up ${backed_up} item(s) to ${BACKUP_SESSION}"
    fi

    return 0
}

# Get the most recent backup directory
# Usage: get_latest_backup
get_latest_backup() {
    if [[ ! -d "$BACKUP_ROOT" ]]; then
        return 1
    fi

    local latest=$(ls -1td "${BACKUP_ROOT}"/*/ 2>/dev/null | head -1)
    if [[ -n "$latest" ]]; then
        echo "${latest%/}"  # Remove trailing slash
        return 0
    fi
    return 1
}

# Restore a file from a backup
# Usage: restore_file "backup_session" "relative/path/to/file"
restore_file() {
    local session="$1"
    local rel_path="$2"
    local backup_file="${session}/${rel_path}"
    local target_file="${HOME}/${rel_path}"

    if [[ ! -f "$backup_file" ]]; then
        echo "Backup file not found: ${backup_file}"
        return 1
    fi

    local target_dir="${target_file:h}"
    mkdir -p "$target_dir"
    cp -p "$backup_file" "$target_file"

    echo "Restored: ${rel_path}"
    return 0
}
