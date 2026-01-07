#!/bin/bash

# Define paths
SOURCE_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$DOTFILES_DIR/backup"

# Create directories if they don't exist
mkdir -p "$BACKUP_DIR"

# 1. Backup Configuration Files
# Add any other folders from ~/.config you want to backup here
CONFIGS=(
    "hypr"
    "kitty"
    "fish"
    "waybar"
    "dunst"
    "rofi"
    "wofi"
    "swaync"
    "wlogout"
    "starship.toml"
    "gtk-3.0"
    "gtk-4.0"
    "qt5ct"
    "qt6ct"
    "cava"
    "neofetch"
    "fastfetch"
)

echo "Backing up config files..."
for config in "${CONFIGS[@]}"; do
    if [ -e "$SOURCE_DIR/$config" ]; then
        echo "  - Copying $config"
        rm -rf "$BACKUP_DIR/$config"
        cp -r "$SOURCE_DIR/$config" "$BACKUP_DIR/"
    else
        echo "  - Skipped $config (not found)"
    fi
done

# 2. Backup Package Lists
echo "Backing up package lists..."
# Native packages (Arch Linux repo)
pacman -Qqen > "$DOTFILES_DIR/pkglist_native.txt"
# AUR packages
pacman -Qqem > "$DOTFILES_DIR/pkglist_aur.txt"

echo "Backup complete! Files are in $DOTFILES_DIR"
