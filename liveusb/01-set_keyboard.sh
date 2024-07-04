#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
}

# Load keyboard layout
log "Loading English keyboard layout..."
loadkeys en || {
    log "Failed to load English keyboard layout."
    exit 1
}
log "Keyboard layout set to English."
