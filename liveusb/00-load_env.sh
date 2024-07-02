#!/bin/bash

# Source the .env file
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    source .env
else
    echo ".env file not found! Please ensure the .env file exists with the required variables."
    exit 1
fi

# Check if .env values have been changed from defaults
if [[ "$ROOT_PASSWORD" == "changeme_root_password" || "$USER_NAME" == "changeme_user_name" || "$USER_PASSWORD" == "changeme_user_password" || "$HOSTNAME" == "changeme_hostname" ]]; then
    echo "Error: One or more environment variables in .env are using default values. Please update the .env file with your specific values."
    exit 1
fi
