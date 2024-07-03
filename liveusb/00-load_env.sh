#!/bin/bash

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>/tmp/arch_install.log
}

# Source the .env file
if [ -f .env ]; then
    log "Loading environment variables from .env file..."
    source .env
else
    log ".env file not found! Please ensure the .env file exists with the required variables."
    exit 1
fi

# Check if .env values have been changed from defaults
if [[ "$ROOT_PASSWORD" == "changeme_root_password" || "$USER_NAME" == "changeme_user_name" || "$USER_PASSWORD" == "changeme_user_password" || "$HOSTNAME" == "changeme_hostname" ]]; then
    log "Error: One or more environment variables in .env are using default values. Please update the .env file with your specific values."
    exit 1
fi

# Export the variables for use in other scripts
export ROOT_PASSWORD
export USER_NAME
export USER_PASSWORD
export HOSTNAME
