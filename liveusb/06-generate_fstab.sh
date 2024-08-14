#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>./arch_install.log
}

# Generate fstab
log "Generating fstab..."
genfstab -U /mnt >>/mnt/etc/fstab || {
    log "Error generating fstab!"
    exit 1
}

log "fstab generated."
