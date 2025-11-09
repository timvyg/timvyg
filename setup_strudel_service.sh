#!/bin/bash

# Setup Strudel as a systemd service
# This allows Strudel to start automatically on boot

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================================"
echo "  Setting up Strudel as a Service"
echo "================================================"
echo ""

# Check if strudel directory exists
if [ ! -d "$HOME/strudel" ]; then
    echo "Error: Strudel not found in $HOME/strudel"
    echo "Please run the installation script first"
    exit 1
fi

# Create service file
echo "Creating systemd service file..."
sudo tee /etc/systemd/system/strudel.service > /dev/null <<EOF
[Unit]
Description=Strudel Web Server
After=network.target sound.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME/strudel
Environment="NODE_ENV=production"
ExecStart=/usr/bin/npm run dev
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "Service file created at /etc/systemd/system/strudel.service"
echo ""

# Reload systemd
sudo systemctl daemon-reload
echo "Systemd daemon reloaded"
echo ""

# Enable and start service
echo "Enabling Strudel service to start on boot..."
sudo systemctl enable strudel

echo ""
read -p "Do you want to start Strudel service now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo systemctl start strudel
    echo "Strudel service started!"
    echo ""
    echo "Check status with:"
    echo "  sudo systemctl status strudel"
    echo ""
    echo "View logs with:"
    echo "  sudo journalctl -u strudel -f"
fi

echo ""
echo "================================================"
echo "  Setup Complete!"
echo "================================================"
echo ""
echo "Useful commands:"
echo "  sudo systemctl start strudel    # Start the service"
echo "  sudo systemctl stop strudel     # Stop the service"
echo "  sudo systemctl restart strudel  # Restart the service"
echo "  sudo systemctl status strudel   # Check status"
echo "  sudo systemctl disable strudel  # Disable auto-start"
echo ""
echo "Access Strudel at: http://localhost:3000"
echo ""



