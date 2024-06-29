#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Update the system
echo "Updating the system..."
pacman -Syu --noconfirm

# Run the terminal setup script
echo "Running the terminal setup script..."
./install-terminal.sh

# Install additional terminal UI tools
echo "Installing additional terminal UI tools..."
pacman -S --noconfirm --needed \
    htop \
    fastfetch \
    curl \
    wget \
    tmux \
    ncdu \
    ripgrep \
    fd \
    bat \
    exa \
    fzf \
    intel-gpu-tools \
    btop \
    tldr \
    glances

echo "Terminal UI tools installation complete."
