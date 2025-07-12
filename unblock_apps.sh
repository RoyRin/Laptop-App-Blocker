#!/bin/bash

# Script to unblock WhatsApp and Signal on macOS

echo "🔓 Unblocking WhatsApp and Signal..."

BLOCKED_DIR="$HOME/.blocked_apps"

# Function to unblock an app
unblock_app() {
    local app_name="$1"
    local blocked_path="$BLOCKED_DIR/$app_name.app"
    local original_path="/Applications/$app_name.app"
    
    # Check if app is in blocked directory
    if [ -d "$blocked_path" ]; then
        if mv "$blocked_path" "$original_path" 2>/dev/null; then
            echo "✓ $app_name unblocked (moved back to Applications)"
        else
            echo "❌ Could not move $app_name back - may need sudo"
            echo "  Try: sudo mv '$blocked_path' '$original_path'"
        fi
    # Check if executable was renamed
    elif [ -f "$original_path/Contents/MacOS/$app_name.blocked" ]; then
        mv "$original_path/Contents/MacOS/$app_name.blocked" "$original_path/Contents/MacOS/$app_name" 2>/dev/null && \
        echo "✓ $app_name unblocked (executable restored)"
    else
        echo "⚠️  $app_name not found in blocked state"
    fi
}

# Unblock the apps
unblock_app "WhatsApp"
unblock_app "Signal"

# Clean up hosts file if it was modified (optional)
# sudo sed -i '' '/web.whatsapp.com/d' /etc/hosts 2>/dev/null
# sudo sed -i '' '/signal.org/d' /etc/hosts 2>/dev/null

echo "✅ Unblocking complete!"
echo "You can now launch WhatsApp and Signal normally"
