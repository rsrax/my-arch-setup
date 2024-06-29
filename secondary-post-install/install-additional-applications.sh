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

# Enable Flatpak support
echo "Enabling Flatpak support..."
../scripts/enable-flatpak.sh

# Run individual scripts for each category
echo "Installing terminal tools..."
../scripts/install-terminal-tools.sh

echo "Installing gaming tools..."
../scripts/install-gaming-tools.sh

echo "Installing productivity tools..."
../scripts/install-productivity-tools.sh

echo "Additional applications installation complete."
