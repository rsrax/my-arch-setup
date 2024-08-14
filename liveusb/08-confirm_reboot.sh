#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>./arch_install.log
}

# Confirm reboot
read -p "The installation is complete. Do you want to reboot now? (y/n): " confirm_reboot

if [[ $confirm_reboot == "y" || $confirm_reboot == "Y" ]]; then
    # Unmount everything
    log "Unmounting all partitions..."
    umount -R /mnt || {
        log "Error unmounting partitions!"
        exit 1
    }

    # Reboot the system
    log "Rebooting the system..."
    reboot
else
    log "Reboot canceled. You can manually reboot later."
fi
