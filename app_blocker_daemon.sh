#!/bin/bash

# App Blocker Daemon - Blocks apps from 9:30 AM to 8:00 PM
# This script runs continuously and checks the time
# Usage: app_blocker_daemon.sh [--no-kill] [--interval SECONDS]

BLOCKED_DIR="$HOME/.blocked_apps"
LOG_FILE="/tmp/appblocker.log"

# Default configuration
KILL_PROCESSES=true
CHECK_INTERVAL=120

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --no-kill)
            KILL_PROCESSES=false
            shift
            ;;
        --interval)
            CHECK_INTERVAL="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--no-kill] [--interval SECONDS]"
            exit 1
            ;;
    esac
done

# Create blocked apps directory if it doesn't exist
mkdir -p "$BLOCKED_DIR"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to block an app
block_app() {
    local app_name="$1"
    local app_path="/Applications/$app_name.app"
    local blocked_path="$BLOCKED_DIR/$app_name.app"
    
    # Only block if not already blocked
    if [ -d "$app_path" ] && [ ! -d "$blocked_path" ]; then
        # Kill the process if enabled
        if [ "$KILL_PROCESSES" = true ]; then
            pkill -f "$app_name" 2>/dev/null
        fi
        
        # Move the app
        if mv "$app_path" "$blocked_path" 2>/dev/null; then
            log_message "Blocked $app_name"
        else
            # Try alternative method - rename executable
            if [ -f "$app_path/Contents/MacOS/$app_name" ]; then
                mv "$app_path/Contents/MacOS/$app_name" "$app_path/Contents/MacOS/$app_name.blocked" 2>/dev/null && \
                log_message "Blocked $app_name (renamed executable)"
            fi
        fi
    fi
    
    # Keep killing the process if it's running and killing is enabled
    if [ "$KILL_PROCESSES" = true ]; then
        pkill -f "$app_name" 2>/dev/null
    fi
}

# Function to unblock an app
unblock_app() {
    local app_name="$1"
    local blocked_path="$BLOCKED_DIR/$app_name.app"
    local app_path="/Applications/$app_name.app"
    
    # Restore from blocked directory
    if [ -d "$blocked_path" ]; then
        if mv "$blocked_path" "$app_path" 2>/dev/null; then
            log_message "Unblocked $app_name"
        fi
    # Restore renamed executable
    elif [ -f "$app_path/Contents/MacOS/$app_name.blocked" ]; then
        mv "$app_path/Contents/MacOS/$app_name.blocked" "$app_path/Contents/MacOS/$app_name" 2>/dev/null && \
        log_message "Unblocked $app_name (restored executable)"
    fi
}

# Function to check if current time is within blocking hours
should_block() {
    local current_hour=$(date +%H)
    local current_minute=$(date +%M)
    local current_time=$((current_hour * 60 + current_minute))
    
    # 9:30 AM = 570 minutes, 8:00 PM = 1200 minutes
    local start_time=570  # 9:30 AM
    local end_time=1200   # 8:00 PM
    
    if [ $current_time -ge $start_time ] && [ $current_time -lt $end_time ]; then
        return 0  # Should block
    else
        return 1  # Should not block
    fi
}

# Main loop
log_message "App Blocker Daemon started"

while true; do
    if should_block; then
        # Block apps during work hours
        block_app "WhatsApp"
        block_app "Signal"
    else
        # Unblock apps outside work hours
        unblock_app "WhatsApp"
        unblock_app "Signal"
    fi
    
    # Sleep before checking again
    sleep $CHECK_INTERVAL
done
