#!/bin/bash

# Enable and start the time synchronization service
echo "Enabling time synchronization service..."
timedatectl set-ntp true
