# My Arch Linux Setup

This repository contains scripts and configuration files to set up an Arch Linux system with a personalized and utilitarian environment. The setup includes terminal and shell configurations, desktop environment, video drivers, and various useful applications.

## Table of Contents

- [My Arch Linux Setup](#my-arch-linux-setup)
	- [Table of Contents](#table-of-contents)
	- [Introduction](#introduction)
	- [Prerequisites](#prerequisites)
	- [Directory Structure](#directory-structure)
	- [Initial Setup](#initial-setup)
		- [Live USB Setup](#live-usb-setup)
		- [What the Live USB Setup Script Does](#what-the-live-usb-setup-script-does)
		- [Chroot Setup](#chroot-setup)
	- [Post-Installation](#post-installation)
		- [Primary Post-Installation](#primary-post-installation)
		- [Secondary Post-Installation](#secondary-post-installation)
			- [Video Drivers](#video-drivers)
			- [Desktop Environment and Display Manager](#desktop-environment-and-display-manager)
			- [Additional Applications](#additional-applications)
				- [Terminal Tools](#terminal-tools)
				- [Gaming Tools](#gaming-tools)
				- [Productivity Tools](#productivity-tools)
	- [Cloning and Updating the Repository](#cloning-and-updating-the-repository)
		- [Cloning the Repository](#cloning-the-repository)
		- [Updating the Repository](#updating-the-repository)
	- [Configuration Files](#configuration-files)
	- [Credits and References](#credits-and-references)

## Introduction

This project aims to simplify the setup process of an Arch Linux system with a personalized environment tailored for enthusiasts, programmers, and gamers. It includes scripts for setting up the base system, configuring video drivers, installing KDE Plasma, and adding various essential tools and applications.

## Prerequisites

1. Arch Linux installation media (Live USB).
2. Internet connection.
3. Basic knowledge of partitioning and Linux command-line operations.

## Directory Structure

```
my-arch-setup/
├── .env
├── liveusb-setup.sh
├── chroot-setup.sh
├── primary-post-install.sh
├── secondary-post-install/
│   ├── install-video-drivers.sh
│   ├── install-de-and-dm.sh
│   └── install-additional-applications.sh
├── scripts/
│   ├── install-yay.sh
│   ├── install-terminal.sh
│   ├── enable-flatpak.sh
│   ├── install-terminal-tools.sh
│   ├── install-gaming-tools.sh
│   └── install-productivity-tools.sh
├── configs/
│   ├── starship.toml
│   ├── kitty.conf
│   ├── zshrc
│   └── nvidia.hook
└── README.md
```

## Initial Setup

### Live USB Setup

1. Boot your computer from the Arch Linux live USB.
2. Clone this repository and navigate into the directory:
   ```sh
   git clone https://github.com/yourusername/my-arch-setup.git
   cd my-arch-setup
   ```
3. Ensure the `.env` file is configured with the necessary environment variables:
   ```sh
   cp .env.example .env
   nano .env
   ```
   Update the values as needed. The `.env` file should include:
   ```
   ROOT_PASSWORD='changeme_root_password'
   USER_NAME='changeme_user_name'
   USER_PASSWORD='changeme_user_password'
   HOSTNAME='changeme_hostname'
   ```
4. Run the initial setup script:
   ```sh
   ./liveusb-setup.sh
   ```

### What the Live USB Setup Script Does

The `liveusb-setup.sh` script performs the following actions:

- Loads the English keyboard layout.
- Checks if the system is in UEFI mode.
- Configures the network connection.
- Partitions and formats the disks as per the predefined scheme (EFI, swap, and BTRFS partitions).
- Mounts the partitions and creates BTRFS subvolumes for the root and home directories.
- Installs the base system and essential packages using `pacstrap`.
- Generates the `fstab` file for mounting.
- Chroots into the new system and runs the `chroot-setup.sh` script.

### Chroot Setup

The `chroot-setup.sh` script performs the following actions:

1. Configures the locale by uncommenting `en_US.UTF-8 UTF-8` in `/etc/locale.gen` and running `locale-gen`.
2. Creates the `/etc/locale.conf` file and sets `LANG=en_US.UTF-8`.
3. Creates the `/etc/vconsole.conf` file and sets `KEYMAP=en`.
4. Configures the hostname by creating the `/etc/hostname` file and writing the hostname to it.
5. Configures the `/etc/hosts` file with the necessary entries.
6. Sets the root password and creates a new user with the specified username and password, adding the user to the `wheel` group.
7. Configures sudo permissions by uncommenting the line allowing members of the `wheel` group to execute any command.
8. Installs and configures GRUB, enables NetworkManager, and performs a final reboot.

To run the `chroot-setup.sh` script, it is included and executed within the `liveusb-setup.sh` script:
```sh
arch-chroot /mnt ./chroot-setup.sh
```

## Post-Installation

### Primary Post-Installation

1. Log in as the new user and pull the repository.
2. Run the `primary-post-install.sh` script:
   ```sh
   sudo ./primary-post-install.sh
   ```

### Secondary Post-Installation

#### Video Drivers

1. Run the `install-video-drivers.sh` script:
   ```sh
   sudo ./secondary-post-install/install-video-drivers.sh
   ```

#### Desktop Environment and Display Manager

1. Run the `install-de-and-dm.sh` script:
   ```sh
   sudo ./secondary-post-install/install-de-and-dm.sh
   ```

#### Additional Applications

1. Run the `install-additional-applications.sh` script:
   ```sh
   sudo ./secondary-post-install/install-additional-applications.sh
   ```

##### Terminal Tools

1. The `install-terminal-tools.sh` script installs additional terminal UI tools:
   ```sh
   sudo ./scripts/install-terminal-tools.sh
   ```

##### Gaming Tools

1. The `install-gaming-tools.sh` script installs gaming tools and applications:
   ```sh
   sudo ./scripts/install-gaming-tools.sh
   ```

##### Productivity Tools

1. The `install-productivity-tools.sh` script installs productivity tools:
   ```sh
   sudo ./scripts/install-productivity-tools.sh
   ```

## Cloning and Updating the Repository

### Cloning the Repository

To clone the repository, use the following command:
```sh
git clone https://github.com/yourusername/my-arch-setup.git
```

### Updating the Repository

To update your local copy of the repository, navigate into the repository directory and run:
```sh
git pull
```

If you encounter any issues with merge conflicts or want to reset your local copy to match the remote repository, you can use:
```sh
git fetch origin
git reset --hard origin/main
```

## Configuration Files

The `configs` directory contains the following configuration files:

- `starship.toml`: Configuration for the Starship prompt.
- `kitty.conf`: Configuration for the Kitty terminal emulator.
- `zshrc`: Configuration for Zsh shell.
- `nvidia.hook`: Pacman hook for Nvidia drivers.

## Credits and References

- Arch Linux Wiki: [https://wiki.archlinux.org/](https://wiki.archlinux.org/)
- Starship Prompt: [https://starship.rs/](https://starship.rs/)
- Kitty Terminal Emulator: [https://sw.kovidgoyal.net/kitty/](https://sw.kovidgoyal.net/kitty/)
- G14 Repository: [https://arch.asus-linux.org](https://arch.asus-linux.org)
- Flatpak: [https://flatpak.org/](https://flatpak.org/)
- ASUS Arch Linux Guide: [https://asus-linux.org/guides/arch-guide/](https://asus-linux.org/guides/arch-guide/)
- Michael Kstra's Arch Guide: [https://gist.github.com/mjkstra/96ce7a5689d753e7a6bdd92cdc169bae](https://gist.github.com/mjkstra/96ce7a5689d753e7a6bdd92cdc169bae)
- Korvahannu's Arch NVIDIA Drivers Installation Guide: [https://github.com/korvahannu/arch-nvidia-drivers-installation-guide](https://github.com/korvahannu/arch-nvidia-drivers-installation-guide)

For any issues or contributions, please refer to the project's repository on GitHub.
