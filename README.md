# Desktop Configuration

My dotfiles are scripts (mostly?).
A few scripts to set up your new Ubuntu-based desktop installation.

ToDo:
 * add some useful aliases
   * some have been added via `configure_shell.zsh`
 * proper dotfiles (~/.config) backup
 * set some firefox preferences
   * install extensions (ad block, bitwarden)
   * stop prompting to save passwords

The scripts will install and configure the following:

## `01_install-setup.sh`
 * UFW (enable, default drop incoming, accept outgoing)
 * Installs some `apt` packages:
    * bat
    * gnome-tweaks
    * python3 python3-pip python3.10-venv
    * xclip
    * zsh
 * Installs some `flatpak` applications (more recent than `apt` versions):
    * foliate (ereader)
    * joplin (markdown editor, preview, notes sync, ...)
 * Installs `snap` applications:
    * glow (terminal markdown reader)
 * Sets `zsh` as defualt user shell

## `02_configure.zsh`
 * Python3 supporting utilities:
    * pipx
    * poetry
 * Custom directories created  (change or comment out as needed):
    * ~/Bin, ~/Projects
    ```shell
    # Create custom dirs
    CUSTOM_DIRS=(
    ~/Bin
    ~/Projects
    )
    ```
 * Installs VScodium (`codium`)
 * Intalls `oh-my-zsh` (`install.sh` runs directly via curl/download)
 * Installs MesloLGS nerd fonts for Powerlevel10K and rebuids font-cache
 * Installs Powerlevel10K config/theme for zsh
    (copied to `ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/`)
   * sets `ZSH_THEME` to Powerlevel10k, and restarts zsh
---
These scripts are called from `02_configure.zsh`
 * `install_fonts_MesloLGS.zsh`
 * `install_vscodium.zsh`

## `install_hyprland.zsh`
Installs Hyprland window manager and ecosystem on Ubuntu 25.10+.
 * Uses [cppiber's PPA](https://launchpad.net/~cppiber/+archive/ubuntu/hyprland)
 * Installs: hyprland, hyprpaper, hyprlock, hypridle, hyprpicker, xdg-desktop-portal-hyprland

## `cmus_config.zsh`
 * **Requires**: Run `python_setup.zsh` first (for poetry)
 * Installs the c music player `cmus`
 * Creates a playlist of all current [SomaFM](https://somafm.com/) web radio channels
   (copied to `~/.config/cmus/playlists/soma_channels_http.pl`)
 * Based on my [somafm](https://github.com/CrustyBarnacle/somafm) python script.

 Originally [a gist](https://gist.github.com/CrustyBarnacle/d21252366fccd873bec70469e986a0b7)

 ### References
  * [zsh](https://github.com/zsh-users/zsh)
  * ~~[oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)~~ moving away from any zsh config framework
  * [powerlevel10k](https://github.com/romkatv/powerlevel10k)
  * [helpful.wiki](https://helpful.wiki/zsh/)
  * [Gist - Device Rule for Apple SuperDrive](https://gist.github.com/yookoala/818c1ff057e3d965980b7fd3bf8f77a6)
