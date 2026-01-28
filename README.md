# Ubuntu Desktop Configuration Scripts

Shell scripts to automate Ubuntu desktop setup and configuration. Scripts are **idempotent** - safe to re-run without losing existing configs or creating duplicates.

## Features

- **Status summaries** - See what's installed before making changes
- **Detection** - Automatically skips already-installed components
- **User control** - Confirmation prompt before any changes
- **Backups** - Configs backed up to `~/.config/ubuntu-setup-backups/` before modification
- **Preserved files** - `.zsh_history`, `.p10k.zsh`, and custom aliases are never overwritten

## Quick Start

```bash
# 1. Initial setup (packages, firewall, flatpaks)
./01_install-setup.sh

# 2. Configure OS (zsh, themes, directories)
./02_configure_os.zsh
```

## Scripts

### Main Scripts (run in order)

#### `01_install-setup.sh`
- Enables UFW firewall (default: deny incoming, allow outgoing)
- Installs apt packages: bat, flatpak, python3, python3-pip, python3-venv, xclip, gnome-tweaks, zsh, zsh-syntax-highlighting, zsh-autosuggestions
- Installs Flatpak apps: Foliate (ereader)
- Installs Snap apps: glow (terminal markdown reader)

#### `02_configure_os.zsh`
- Sets zsh as default shell
- Creates custom directories (`~/Bin`, `~/Projects`)
- Optionally installs VScodium
- Configures zsh with Powerlevel10k theme, syntax highlighting, aliases

### Standalone Scripts (run as needed)

| Script | Description | Requirements |
|--------|-------------|--------------|
| `python_setup.zsh` | Installs pipx and poetry | - |
| `cmus_config.zsh` | cmus player with SomaFM playlist | `python_setup.zsh` first |
| `install_hyprland.zsh` | Hyprland window manager | Ubuntu 25.10+ |
| `install_setup_kvm-qemu.zsh` | KVM/QEMU virtualization | - |
| `pop_shell.zsh` | Pop!_OS tiling extension | GNOME |
| `superdrive_config.zsh` | Apple SuperDrive udev rule | - |

### Helper Scripts (called by main scripts)

- `configure_shell.zsh` - ZSH configuration with Powerlevel10k
- `install_fonts_MesloLGS.zsh` - MesloLGS Nerd Fonts for Powerlevel10k
- `install_vscodium.zsh` - VScodium editor

### Shared Library (`lib/`)

- `common.zsh` - Colors, print functions, prompts
- `detect.zsh` - State detection for all components
- `backup.zsh` - Backup management

## Configuration

ZSH configuration lives in `~/.zsh/custom/` (no framework):
- `aliases_apt.zsh` - Package manager aliases
- `path.zsh` - PATH configuration
- `themes/powerlevel10k/` - Theme files

## Example Output

```
Ubuntu Setup v2.0 - System Status
==================================
[+] UFW firewall         : Enabled
[+] APT packages         : All installed (10/10)
[+] Flatpak apps         : All installed
[-] VScodium             : Not installed

Actions to perform:
  - Install VScodium

Proceed? [Y/n]:
```

## ToDo

- [ ] Firefox preferences and extensions
- [ ] Proper dotfiles (~/.config) backup/restore

## References

- [zsh](https://github.com/zsh-users/zsh)
- [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [helpful.wiki/zsh](https://helpful.wiki/zsh/)
- [Hyprland PPA](https://launchpad.net/~cppiber/+archive/ubuntu/hyprland)
- [Apple SuperDrive udev rule](https://gist.github.com/yookoala/818c1ff057e3d965980b7fd3bf8f77a6)
