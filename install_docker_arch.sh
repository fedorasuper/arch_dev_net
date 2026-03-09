#!/bin/bash

# Docker Installation Script for Arch Linux

echo "======================================"
echo " Docker Installation Script for Arch "
echo "======================================"

# Check if script is run as root
if [[ $EUID -eq 0 ]]; then
   echo "Please do NOT run this script as root."
   exit 1
fi

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install Docker
echo "Installing Docker..."
sudo pacman -S docker --noconfirm

# Start Docker service
echo "Starting Docker service..."
sudo systemctl start docker

# Enable Docker on boot
echo "Enabling Docker service..."
sudo systemctl enable docker

# Add user to docker group
echo "Adding user to docker group..."
sudo usermod -aG docker $USER

# Verify installation
echo "Checking Docker version..."
docker --version

echo "Running Docker test container..."
sudo docker run hello-world

echo "======================================"
echo " Docker installation completed!"
echo " Please LOG OUT and LOG IN again"
echo " to use Docker without sudo."
echo "======================================"
