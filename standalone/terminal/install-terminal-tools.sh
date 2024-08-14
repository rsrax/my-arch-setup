#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>./arch_install.log
}

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Update the system
log "Updating the system..."
sudo pacman -Syu --noconfirm || {
    log "Error updating the system"
}

# Install additional terminal UI tools
log "Installing additional terminal UI tools..."
TERMINAL_TOOLS=(
    "zsh"
    "bat"
    "ugrep"
    "hwinfo"
    "mcfly"
    "pkgfile"
    "ttf-firacode-nerd"
    "ttf-jetbrains-mono"
    "htop"
    "fastfetch"
    "curl"
    "wget"
    "tmux"
    "btop"
    "rsync"
    "tldr"
)

for tool in "${TERMINAL_TOOLS[@]}"; do
    sudo pacman -S --noconfirm --needed "$tool" || {
        log "Error installing $tool"
    }
done

log "Terminal UI tools installation complete."
