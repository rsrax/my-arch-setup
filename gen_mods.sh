#!/bin/bash

modules_dir="modules"  # Directory to store module scripts
mkdir -p "$modules_dir"  # Create the directory if it doesn't exist

# Define module names (without the index)
module_names=(
    "load_env"
    "set_keyboard"
    "check_boot_mode"
    "check_internet"
    "prepare_storage" # Combined partition and format and mount
    "install_base_system"
    "generate_fstab"
    "chroot_and_configure"
    "confirm_reboot"
)

# Create module script files
for (( i=0; i<${#module_names[@]}; i++ )); do
    index=$(printf "%02d" $i)  # Format index with leading zero
    name="${module_names[$i]}"
    filename="${modules_dir}/${index}-${name}.sh"  # Add .sh extension
    touch "$filename"          # Create empty file
    chmod +x "$filename"       # Make executable
done

echo "Module scripts created in the 'modules' directory."
