#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
}

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Update the system
log "Updating the system..."
pacman -Syu --noconfirm || {
    log "Error updating the system"
    exit 1
}

# Run the terminal setup script (if needed)
if ! command -v kitty &>/dev/null; then # Check if kitty is installed
    log "Kitty not found. Running the terminal setup script..."
    bash install-terminal.sh || {
        log "Error running terminal setup script"
        exit 1
    }
fi

# Install additional terminal UI tools
log "Installing additional terminal UI tools..."
TERMINAL_TOOLS=(
    htop
    fastfetch
    curl
    wget
    tmux
    ncdu
    ripgrep
    fd
    bat
    exa
    fzf
    intel-gpu-tools
    btop
    rsync
    tldr
    glances
)

for tool in "${TERMINAL_TOOLS[@]}"; do
    pacman -S --noconfirm --needed "$tool" || {
        log "Error installing $tool"
        exit 1
    }
done

log "Terminal UI tools installation complete."
