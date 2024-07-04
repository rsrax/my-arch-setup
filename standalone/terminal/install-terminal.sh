#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
}

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Check if SUDO_USER is set
if [ -z "$SUDO_USER" ]; then
    echo "SUDO_USER is not set. Please run this script using sudo."
    exit 1
fi

# Install zsh and related packages
log "Installing zsh and related packages..."
TERMINAL_PACKAGES=(
    "zsh"
    "starship"
    "kitty"
    "exa"
    "bat"
    "ugrep"
    "hwinfo"
    "expac"
    "mcfly"
    "fzf"
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
    "zsh-history-substring-search"
    "pkgfile"
    "ttf-firacode-nerd"
    "ttf-jetbrains-mono"
)

for package in "${TERMINAL_PACKAGES[@]}"; do
    sudo pacman -S --noconfirm --needed "$package" || {
        log "Error installing $package"
    }
done

# Set default shell to zsh for the user
log "Setting default shell to zsh for the user..."
sudo usermod --shell /usr/bin/zsh "$SUDO_USER" || {
    log "Error setting default shell to zsh"
}

# Copy zsh configuration
log "Copying zsh configuration..."
sudo mkdir -p /home/"$SUDO_USER"/.config || {
    log "Error creating .config directory"
}
sudo cp ./configs/zshrc /home/"$SUDO_USER"/.zshrc || {
    log "Error copying zshrc"
}
sudo touch /home/"$SUDO_USER"/.zhistory || {
    log "Error creating zhistory"
}
sudo chown "$SUDO_USER":"$SUDO_USER" /home/"$SUDO_USER"/.zshrc || {
    log "Error changing ownership of zshrc"
}

# Copy starship configuration
log "Copying starship configuration..."
sudo mkdir -p /home/"$SUDO_USER"/.config || {
    log "Error creating .config directory"
}
sudo cp ./configs/starship.toml /home/"$SUDO_USER"/.config/starship.toml || {
    log "Error copying starship.toml"
}
sudo chown -R "$SUDO_USER":"$SUDO_USER" /home/"$SUDO_USER"/.config/starship.toml || {
    log "Error changing ownership of starship.toml"
}

# Copy kitty configuration
log "Copying kitty configuration..."
sudo mkdir -p /home/"$SUDO_USER"/.config/kitty || {
    log "Error creating kitty config directory"
}
sudo cp ./configs/kitty.conf /home/"$SUDO_USER"/.config/kitty/kitty.conf || {
    log "Error copying kitty.conf"
}
sudo chown -R "$SUDO_USER":"$SUDO_USER" /home/"$SUDO_USER"/.config/kitty/kitty.conf || {
    log "Error changing ownership of kitty.conf"
}

log "Terminal setup complete."
