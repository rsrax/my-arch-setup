#!/bin/bash

# Edit grub-btrfsd service
echo "Configuring grub-btrfsd service..."
# Ensure the 'drop-in' directory exists
sudo mkdir -p /etc/systemd/system/grub-btrfsd.service.d/

# Create the override file with desired configuration
cat <<EOF | sudo tee /etc/systemd/system/grub-btrfsd.service.d/override.conf
[Service]
ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto
EOF

# Reload systemd daemon to apply the changes
sudo systemctl daemon-reload

# Enable grub-btrfsd service to run on boot
echo "Enabling grub-btrfsd service..."
sudo systemctl enable grub-btrfsd
