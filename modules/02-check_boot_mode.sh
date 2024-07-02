#!/bin/bash

# Check if in UEFI mode
echo "Checking if the system is in UEFI mode..."
if [ -d /sys/firmware/efi ]; then
    if [ $(cat /sys/firmware/efi/fw_platform_size) -eq 64 ]; then
        echo "UEFI mode detected (64-bit)"
    elif [ $(cat /sys/firmware/efi/fw_platform_size) -eq 32 ]; then
        echo "UEFI mode detected (32-bit)"
    else
        echo "Unknown UEFI mode"
    fi
else
    echo "BIOS mode detected"
fi
