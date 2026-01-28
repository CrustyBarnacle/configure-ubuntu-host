# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains shell scripts for automating Ubuntu desktop setup and configuration. Scripts are designed to be run in sequence on a fresh Ubuntu installation.

## Script Execution Order

1. `01_install-setup.sh` - Initial setup (bash): UFW, apt packages, flatpaks, zsh installation
2. `02_configure_os.zsh` - OS configuration (zsh): custom directories, VScodium, shell configuration

Scripts use `set -e` for error handling - execution stops on first failure.

## Architecture

- **Shared library** (`lib/`):
  - `common.zsh` - Colors, print functions, prompts (sources detect.zsh and backup.zsh)
  - `detect.zsh` - State detection functions for all components
  - `backup.zsh` - Backup management for user configs
- **Entry scripts**: `01_install-setup.sh` (bash) and `02_configure_os.zsh` (zsh) are the main orchestration scripts
- **Helper scripts**: Called by `02_configure_os.zsh`:
  - `configure_shell.zsh` - Sets up zsh with powerlevel10k theme, syntax highlighting, aliases
  - `install_vscodium.zsh` - Adds VScodium repo and installs
  - `install_fonts_MesloLGS.zsh` - Downloads and installs MesloLGS Nerd Fonts
- **Standalone scripts** (run manually as needed):
  - `python_setup.zsh` - pipx and poetry installation
  - `cmus_config.zsh` - cmus music player with SomaFM playlist (requires `python_setup.zsh` first)
  - `install_setup_kvm-qemu.zsh` - KVM/QEMU virtualization setup
  - `install_hyprland.zsh` - Hyprland window manager for Ubuntu 25.10+ (uses cppiber's PPA)
  - `pop_shell.zsh` - Pop!_OS shell tiling extension
  - `superdrive_config.zsh` - Apple SuperDrive udev rule

## Conventions

- Main scripts use `.sh` (bash) or `.zsh` extension matching their interpreter
- All scripts use `set -e` for error handling
- Use `$HOME` instead of `~` in scripts for reliable expansion
- Use `[[ ]]` instead of `[ ]` for conditionals in zsh scripts
- Use `apt install -y` syntax consistently
- Interactive prompts use zsh's `read 'variable?prompt'` syntax
- Custom directories default to `~/Bin` and `~/Projects`
- Zsh configuration lives in `~/.zsh/custom/` (not oh-my-zsh)

## Idempotency

All scripts are safe to re-run:
- Detection functions check if components are already installed
- Scripts display status summary before making changes
- User confirmation required before proceeding
- Backups created at `~/.config/ubuntu-setup-backups/` before modifying configs
- Use `>` (overwrite) not `>>` (append) for config files to prevent duplicates
- Use `ensure_zshrc_sources()` pattern to add lines only if not present
