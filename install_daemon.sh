#!/bin/bash

# Installation script for App Blocker Daemon

echo "📦 Installing App Blocker Daemon..."

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ This script is designed for macOS only"
    exit 1
fi

# Create the daemon script
DAEMON_SCRIPT="/usr/local/bin/app_blocker_daemon.sh"
PLIST_FILE="$HOME/Library/LaunchAgents/com.user.appblocker.plist"

# Copy the daemon script
echo "📝 Creating daemon script..."
sudo mkdir -p /usr/local/bin

# You'll need to create app_blocker_daemon.sh first
if [ ! -f "./app_blocker_daemon.sh" ]; then
    echo "❌ app_blocker_daemon.sh not found in current directory"
    echo "Make sure you've saved the daemon script first"
    exit 1
fi

sudo cp ./app_blocker_daemon.sh "$DAEMON_SCRIPT"
sudo chmod +x "$DAEMON_SCRIPT"

# Create LaunchAgents directory if it doesn't exist
mkdir -p "$HOME/Library/LaunchAgents"

# Copy the plist file
echo "📝 Installing launch agent..."
if [ ! -f "./com.user.appblocker.plist" ]; then
    echo "❌ com.user.appblocker.plist not found in current directory"
    echo "Make sure you've saved the plist file first"
    exit 1
fi

cp ./com.user.appblocker.plist "$PLIST_FILE"

# Load the launch agent
echo "🚀 Starting daemon..."
launchctl unload "$PLIST_FILE" 2>/dev/null
launchctl load "$PLIST_FILE"

echo "✅ Installation complete!"
echo ""
echo "📍 The daemon will:"
echo "   • Block WhatsApp and Signal from 9:30 AM to 8:00 PM"
echo "   • Run automatically on startup"
echo "   • Continue running even if you close your laptop"
echo ""
echo "📊 Check status with: launchctl list | grep appblocker"
echo "📄 View logs at: /tmp/appblocker.log"
echo ""
echo "To uninstall later, run ./uninstall_daemon.sh"
