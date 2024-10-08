#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>./arch_install.log
}

# Check if .env file exists and is valid
if [ ! -f .env ]; then
    log "Error: .env file not found! Please create it in the project root directory."
    exit 1
fi

source .env

# Copy chroot-script.sh to the new system
log "Copying chroot-script.sh to the new system..."
cp ./chroot-script.sh /mnt/root/chroot-script.sh || {
    log "Error copying chroot-script.sh!"
    exit 1
}

# Export environment variables for the chroot environment
export ROOT_PASSWORD USER_NAME USER_PASSWORD HOSTNAME

# Chroot into the new system and run the chroot-script.sh script with environment variables
log "Chrooting into the new system..."
arch-chroot /mnt /bin/bash -c "
export ROOT_PASSWORD='${ROOT_PASSWORD}'
export USER_NAME='${USER_NAME}'
export USER_PASSWORD='${USER_PASSWORD}'
export HOSTNAME='${HOSTNAME}'
/root/chroot-script.sh
" || {
    log "Error during chroot and configuration!"
    exit 1
}

log "Chroot and configuration complete."
