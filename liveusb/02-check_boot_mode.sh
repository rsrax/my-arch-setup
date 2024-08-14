#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>./arch_install.log
}

# Check if in UEFI mode
log "Checking if the system is in UEFI mode..."
if [ -d /sys/firmware/efi ]; then
    if [ $(cat /sys/firmware/efi/fw_platform_size) -eq 64 ]; then
        log "UEFI mode detected (64-bit)"
    elif [ $(cat /sys/firmware/efi/fw_platform_size) -eq 32 ]; then
        log "UEFI mode detected (32-bit)"
    else
        log "Unknown UEFI mode"
    fi
else
    log "BIOS mode detected"
fi
