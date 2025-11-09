#!/bin/bash

# Strudel Local Installation Script for Raspberry Pi
# This script automates the installation of Strudel to run locally on your Pi

set -e  # Exit on any error

echo "================================================"
echo "  Strudel Installation for Raspberry Pi"
echo "================================================"
echo ""

# Check if running on Raspberry Pi
if [ ! -f /proc/cpuinfo ] || ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
    echo "Warning: This script is intended for Raspberry Pi"
    read -p "Do you want to continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check for Node.js
echo "Checking for Node.js..."
if ! command -v node &> /dev/null; then
    echo "Node.js not found. Installing Node.js..."
    
    # Install Node.js 18
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js $(node --version) is already installed ✓"
fi

# Check for Git
if ! command -v git &> /dev/null; then
    echo "Git not found. Installing Git..."
    sudo apt install -y git
fi

# Update system
echo ""
echo "Updating system packages..."
sudo apt update

# Clone or update Strudel repository
echo ""
if [ -d "$HOME/strudel" ]; then
    echo "Strudel directory already exists. Updating..."
    cd ~/strudel
    git pull
else
    echo "Cloning Strudel repository..."
    git clone https://github.com/tidalcycles/strudel.git ~/strudel
    cd ~/strudel
fi

# Install dependencies
echo ""
echo "Installing dependencies (this may take 15-30 minutes)..."
npm install

echo ""
echo "================================================"
echo "  Installation Complete!"
echo "================================================"
echo ""
echo "To start Strudel, run:"
echo "  cd ~/strudel"
echo "  npm run dev"
echo ""
echo "Then open your browser to:"
echo "  http://localhost:3000"
echo ""
echo "To stop Strudel, press Ctrl+C"
echo ""
read -p "Do you want to start Strudel now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Starting Strudel..."
    npm run dev
fi



