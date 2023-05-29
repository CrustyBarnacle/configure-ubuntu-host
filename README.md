# Desktop Configuration

My dotfiles are scripts (mostly?).
A few scripts to set up your new Ubuntu-based desktop installation.
The scripts will install and configure the following:

## `01_install-setup.sh`
 * UFW (enable, default drop incoming, accept incoming)
 * Installs some `apt` packages:
    * bat
    * gnome-tweaks
    * python3 python3-pip python3.10-venv
    * xclip
    * zsh
 * Installs some `flatpak` applications (more recent than `apt` versions):
    * foliate (ereader)
    * joplin (markdown editor, preview, notes sync, ...)
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
 * Intalls `oh-my-zsh`
 * Installs MesloLGS nerd fonts for Powerlevel10K and rebuids font-cache
 * Installs Powerlevel10K config/themer for zsh
   * sets `ZSH_THEME` to Powerlevel10k, and restarts zsh

 * Sets `zsh` as defualt user shell
---
These scripts are called from `02_configure.zsh`
 * `install_fonts_MesloLGS.zsh`
 * `install_vscodium.zsh`