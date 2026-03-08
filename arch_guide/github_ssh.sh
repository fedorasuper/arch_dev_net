#!/bin/bash

# -----------------------------
# GitHub SSH Setup Script
# For Arch Linux
# -----------------------------

# Ask user for GitHub email
read -p "Enter your GitHub email: " EMAIL

# Step 1: Install git and openssh
sudo pacman -S --needed git openssh

# Step 2: Configure Git username
read -p "Enter your GitHub username: " USERNAME
git config --global user.name "$USERNAME"

# Step 3: Configure Git email
git config --global user.email "$EMAIL"

# Step 4: Create SSH key
ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/id_ed25519 -N ""

# Step 5: Start SSH agent
eval "$(ssh-agent -s)"

# Step 6: Add SSH key to agent
ssh-add ~/.ssh/id_ed25519

# Step 7: Show public key
echo "Copy the following SSH key and add it to GitHub:"
cat ~/.ssh/id_ed25519.pub

echo ""
echo "Go to: https://github.com/settings/keys"
echo "Click 'New SSH Key' and paste the key above."

# Step 8: Test SSH connection
read -p "Press ENTER after adding the key to GitHub..."

ssh -T git@github.com

echo "Setup complete!"
