#!/bin/bash

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
echo "Installing zsh and related packages..."
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
    pacman -S --noconfirm --needed $package
done

# Set default shell to zsh for the user
echo "Setting default shell to zsh for the user..."
usermod --shell /bin/zsh $SUDO_USER

# Copy zsh configuration
echo "Copying zsh configuration..."
mkdir -p /home/$SUDO_USER/.config
cp /path/to/repository/configs/zshrc /home/$SUDO_USER/.zshrc
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.zshrc

# Copy starship configuration
echo "Copying starship configuration..."
mkdir -p /home/$SUDO_USER/.config
cp /path/to/repository/configs/starship.toml /home/$SUDO_USER/.config/starship.toml
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/starship.toml

# Copy kitty configuration
echo "Copying kitty configuration..."
mkdir -p /home/$SUDO_USER/.config/kitty
cp /path/to/repository/configs/kitty.conf /home/$SUDO_USER/.config/kitty/kitty.conf
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/kitty/kitty.conf

echo "Terminal setup complete."
