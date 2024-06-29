#!/bin/bash

# Install necessary packages
sudo pacman -S --noconfirm \
    zsh \
    starship \
    kitty \
    exa \
    bat \
    ugrep \
    hwinfo \
    expac \
    mcfly \
    fzf \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    zsh-history-substring-search \
    pkgfile \
    ttf-firacode-nerd

# Change default shell to zsh
chsh -s /bin/zsh

# Enable pkgfile service
sudo systemctl enable pkgfile-update.timer
sudo systemctl start pkgfile-update.timer

# Create necessary configuration directories
mkdir -p ~/.config
mkdir -p ~/.config/kitty

# Copy configuration files
cp ../configs/starship.toml ~/.config/starship.toml
cp ../configs/kitty.conf ~/.config/kitty/kitty.conf
cp ../configs/zshrc ~/.zshrc

echo "Terminal and shell setup complete! Please restart your terminal to apply all changes."
