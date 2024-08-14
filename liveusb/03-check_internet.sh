#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>./arch_install.log
}

# Check internet connection
log "Checking internet connection..."
if ping -c 5 archlinux.org &>/dev/null; then
    log "Internet connection is working."
else
    log "Internet connection is not working. Please check your network settings."
    exit 1
fi
