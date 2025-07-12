#!/bin/bash

# Script to block WhatsApp and Signal on macOS
# Uses a different approach due to macOS security restrictions

echo "🔒 Blocking WhatsApp and Signal..."

# Create a directory for "blocked" apps if it doesn't exist
BLOCKED_DIR="$HOME/.blocked_apps"
mkdir -p "$BLOCKED_DIR"

# Function to block an app
block_app() {
    local app_name="$1"
    local app_path="/Applications/$app_name.app"
    
    if [ -d "$app_path" ]; then
        # Kill the process first
        pkill -f "$app_name" 2>/dev/null && echo "✓ $app_name process terminated"
        
        # Move the app to blocked directory (doesn't require special permissions)
        if mv "$app_path" "$BLOCKED_DIR/$app_name.app" 2>/dev/null; then
            echo "✓ $app_name blocked (moved to hidden directory)"
        else
            echo "❌ Could not move $app_name - trying alternative method..."
            
            # Alternative: Rename the app executable
            if [ -f "$app_path/Contents/MacOS/$app_name" ]; then
                mv "$app_path/Contents/MacOS/$app_name" "$app_path/Contents/MacOS/$app_name.blocked" 2>/dev/null && \
                echo "✓ $app_name blocked (executable renamed)"
            fi
        fi
    else
        echo "⚠️  $app_name not found at /Applications/$app_name.app"
    fi
}

# Block the apps
block_app "WhatsApp"
block_app "Signal"

echo "✅ Blocking complete!"
echo "Run './unblock_apps.sh' to restore access"

# Alternative method using /etc/hosts (optional - uncomment if you want to block web versions too)
# echo "# Blocking WhatsApp and Signal web" | sudo tee -a /etc/hosts
# echo "0.0.0.0 web.whatsapp.com" | sudo tee -a /etc/hosts
# echo "0.0.0.0 signal.org" | sudo tee -a /etc/hosts
