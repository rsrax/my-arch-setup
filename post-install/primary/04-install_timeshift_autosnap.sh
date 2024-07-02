#!/bin/bash

# Check if SUDO_USER is set
if [ -z "$SUDO_USER" ]; then
    echo "SUDO_USER is not set. Please run this script using sudo."
    exit 1
fi

# Install timeshift-autosnap
echo "Installing timeshift-autosnap..."
sudo -u $SUDO_USER yay -S timeshift-autosnap --noconfirm
