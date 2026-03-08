#!/bin/bash

# 1. Update system and install base-devel (compilers) and git
echo "Installing prerequisites..."
sudo pacman -S --needed --noconfirm base-devel git

# 2. Create a temporary folder for the build
mkdir -p ~/tmp_aur
cd ~/tmp_aur

# 3. Clone yay from the official AUR repository
echo "Cloning yay..."
git clone https://aur.archlinux.org/yay.git
cd yay

# 4. Build and Install
# -s: installs missing dependencies automatically
# -i: installs the package once built
# --noconfirm: skips the "Are you sure?" prompts
echo "Building yay (this may take a minute)..."
makepkg -si --noconfirm

# 5. Cleanup
echo "Cleaning up temporary files..."
cd ~
rm -rf ~/tmp_aur

echo "--------------------------------------"
echo "✅ yay is now installed!"
echo "Try searching for a package: yay -Ss spotify"
echo "--------------------------------------"
