#!/bin/bash

# Define paths
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$DOTFILES_DIR/backup"
TARGET_DIR="$HOME/.config"

echo "Starting restoration process..."

# 1. Install Packages
echo "Installing packages..."

# Check for yay (AUR helper) - assuming Arch based on pacman usage
if ! command -v yay &> /dev/null; then
    echo "yay is not installed. Installing yay..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si
    cd -
fi

# Install native packages
if [ -f "$DOTFILES_DIR/pkglist_native.txt" ]; then
    echo "Installing native packages..."
    sudo pacman -S --needed - < "$DOTFILES_DIR/pkglist_native.txt"
fi

# Install AUR packages
if [ -f "$DOTFILES_DIR/pkglist_aur.txt" ]; then
    echo "Installing AUR packages..."
    yay -S --needed - < "$DOTFILES_DIR/pkglist_aur.txt"
fi

# 2. Restore Configuration Files
echo "Restoring configuration files..."

# Get list of directories in backup
for config_path in "$BACKUP_DIR"/*; do
    config_name=$(basename "$config_path")
    target_path="$TARGET_DIR/$config_name"

    if [ -e "$target_path" ]; then
        echo "Backing up existing $config_name to $target_path.old"
        mv "$target_path" "$target_path.old"
    fi

    echo "Restoring $config_name..."
    cp -r "$config_path" "$TARGET_DIR/"
done

echo "Restoration complete! Please restart your session."
