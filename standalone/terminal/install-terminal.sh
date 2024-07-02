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
)

for package in "${TERMINAL_PACKAGES[@]}"; do
    pacman -S --noconfirm --needed "$package" || {
        log "Error installing $package"
        exit 1
    }
done

# Set default shell to zsh for the user
log "Setting default shell to zsh for the user..."
usermod --shell /bin/zsh "$SUDO_USER" || {
    log "Error setting default shell to zsh"
    exit 1
}

# Copy zsh configuration
log "Copying zsh configuration..."
mkdir -p /home/"$SUDO_USER"/.config || {
    log "Error creating .config directory"
    exit 1
}
cp ../configs/zshrc /home/"$SUDO_USER"/.zshrc || {
    log "Error copying zshrc"
    exit 1
}
chown "$SUDO_USER":"$SUDO_USER" /home/"$SUDO_USER"/.zshrc || {
    log "Error changing ownership of zshrc"
    exit 1
}

# Copy starship configuration
log "Copying starship configuration..."
mkdir -p /home/"$SUDO_USER"/.config || {
    log "Error creating .config directory"
    exit 1
}
cp ../configs/starship.toml /home/"$SUDO_USER"/.config/starship.toml || {
    log "Error copying starship.toml"
    exit 1
}
chown -R "$SUDO_USER":"$SUDO_USER" /home/"$SUDO_USER"/.config/starship.toml || {
    log "Error changing ownership of starship.toml"
    exit 1
}

# Copy kitty configuration
log "Copying kitty configuration..."
mkdir -p /home/"$SUDO_USER"/.config/kitty || {
    log "Error creating kitty config directory"
    exit 1
}
cp ../configs/kitty.conf /home/"$SUDO_USER"/.config/kitty/kitty.conf || {
    log "Error copying kitty.conf"
    exit 1
}
chown -R "$SUDO_USER":"$SUDO_USER" /home/"$SUDO_USER"/.config/kitty/kitty.conf || {
    log "Error changing ownership of kitty.conf"
    exit 1
}

log "Terminal setup complete."
