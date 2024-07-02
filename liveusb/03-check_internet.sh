#!/bin/bash

# Check internet connection
echo "Checking internet connection..."
if ping -c 5 archlinux.org &> /dev/null; then
    echo "Internet connection is working."
else
    echo "Internet connection is not working. Please check your network settings."
    exit 1
fi
