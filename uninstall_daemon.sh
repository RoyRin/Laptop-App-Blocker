#!/bin/bash

# Uninstall script for App Blocker Daemon

echo "🗑️  Uninstalling App Blocker Daemon..."

PLIST_FILE="$HOME/Library/LaunchAgents/com.user.appblocker.plist"
DAEMON_SCRIPT="/usr/local/bin/app_blocker_daemon.sh"
BLOCKED_DIR="$HOME/.blocked_apps"

# Stop and unload the daemon
echo "🛑 Stopping daemon..."
launchctl unload "$PLIST_FILE" 2>/dev/null

# Remove files
echo "🧹 Removing files..."
rm -f "$PLIST_FILE"
sudo rm -f "$DAEMON_SCRIPT"

# Restore any blocked apps
echo "🔓 Restoring blocked apps..."
if [ -d "$BLOCKED_DIR/WhatsApp.app" ]; then
    mv "$BLOCKED_DIR/WhatsApp.app" "/Applications/WhatsApp.app" 2>/dev/null
fi

if [ -d "$BLOCKED_DIR/Signal.app" ]; then
    mv "$BLOCKED_DIR/Signal.app" "/Applications/Signal.app" 2>/dev/null
fi

# Restore renamed executables if any
if [ -f "/Applications/WhatsApp.app/Contents/MacOS/WhatsApp.blocked" ]; then
    mv "/Applications/WhatsApp.app/Contents/MacOS/WhatsApp.blocked" "/Applications/WhatsApp.app/Contents/MacOS/WhatsApp" 2>/dev/null
fi

if [ -f "/Applications/Signal.app/Contents/MacOS/Signal.blocked" ]; then
    mv "/Applications/Signal.app/Contents/MacOS/Signal.blocked" "/Applications/Signal.app/Contents/MacOS/Signal" 2>/dev/null
fi

# Clean up
rmdir "$BLOCKED_DIR" 2>/dev/null

echo "✅ Uninstallation complete!"
echo "WhatsApp and Signal are now accessible again."
