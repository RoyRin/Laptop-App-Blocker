# 🚫 App Blocker for macOS

> A lightweight daemon that automatically blocks distracting apps during work hours

## ✨ What It Does

Automatically blocks WhatsApp and Signal from **9:30 AM to 8:00 PM** every day, helping you stay focused during work hours. The blocker:

- ✅ Runs automatically in the background
- ✅ Survives system restarts and sleep
- ✅ Can't be easily bypassed
- ✅ Logs all activity (tracks when apps are blocked/unblocked in `/tmp/appblocker.log`)
- ✅ Easy to customize or remove

## 🚀 Quick Install

```bash
# 1. Clone or download all files to a folder
# 2. Make scripts executable
chmod +x *.sh

# 3. Install (requires admin password once)
./install_daemon.sh
```

That's it! The blocker is now active.

## 📂 Directory Structure

```
block_apps/
├── README.md                    # This file
├── install_daemon.sh            # 🚀 Run this to install
├── uninstall_daemon.sh          # 🗑️  Run this to remove everything
├── app_blocker_daemon.sh        # 🤖 Main daemon (runs in background)
├── block_apps.sh                # 🚫 Manually block apps
├── unblock_apps.sh              # ✅ Manually unblock apps
└── com.user.appblocker.plist    # ⚙️  macOS launch configuration
```

## 📋 Requirements

- macOS 10.12 or later
- WhatsApp and/or Signal installed in `/Applications/`
- Admin password (only for installation)

## 🎯 How to Use

### Check Status
```bash
# Is it running?
launchctl list | grep appblocker

# View activity
tail -f /tmp/appblocker.log
```

### Manual Control
```bash
# Block apps immediately
./block_apps.sh

# Unblock apps temporarily
./unblock_apps.sh

# Stop the daemon
launchctl unload ~/Library/LaunchAgents/com.user.appblocker.plist

# Start the daemon
launchctl load ~/Library/LaunchAgents/com.user.appblocker.plist
```

### Uninstall Completely
```bash
./uninstall_daemon.sh
```

## ⚙️ Customization

### Command Line Options

The daemon supports these command-line arguments:

```bash
# Disable process killing (only moves/hides apps)
app_blocker_daemon.sh --no-kill

# Change check interval (default: 120 seconds)
app_blocker_daemon.sh --interval 300

# Combine options
app_blocker_daemon.sh --no-kill --interval 60
```

To use custom options with the daemon, edit `com.user.appblocker.plist` before installing:

```xml
<key>ProgramArguments</key>
<array>
    <string>/usr/local/bin/app_blocker_daemon.sh</string>
    <string>--no-kill</string>
    <string>--interval</string>
    <string>300</string>
</array>
```

### Change Schedule

Edit `app_blocker_daemon.sh` before installing:

```bash
# Current schedule (9:30 AM - 8:00 PM)
local start_time=570   # minutes from midnight
local end_time=1200    # minutes from midnight
```

**Quick Reference:**
| Time | Minutes |
|------|---------|
| 7:00 AM | 420 |
| 8:00 AM | 480 |
| 9:00 AM | 540 |
| 9:30 AM | 570 |
| 5:00 PM | 1020 |
| 6:00 PM | 1080 |
| 8:00 PM | 1200 |
| 10:00 PM | 1320 |

### Add More Apps

In `app_blocker_daemon.sh`, find this section and add your apps:

```bash
if should_block; then
    block_app "WhatsApp"
    block_app "Signal"
    block_app "Telegram"  # Add new app
else
    unblock_app "WhatsApp"
    unblock_app "Signal"
    unblock_app "Telegram"  # Remember to unblock too!
fi
```

## 🔧 Troubleshooting

### Apps Not Blocking?

1. **Check if daemon is running:**
   ```bash
   launchctl list | grep appblocker
   ```

2. **Check for errors:**
   ```bash
   cat /tmp/appblocker.err
   tail -20 /tmp/appblocker.log
   ```

3. **Verify apps exist:**
   ```bash
   ls /Applications/ | grep -E "WhatsApp|Signal"
   ```

### Apps Still Blocked After Uninstall?

Manually restore them:
```bash
sudo mv ~/.blocked_apps/WhatsApp.app /Applications/
sudo mv ~/.blocked_apps/Signal.app /Applications/
```

## 📁 File Locations

| Component | Location |
|-----------|----------|
| Daemon script | `/usr/local/bin/app_blocker_daemon.sh` |
| Launch config | `~/Library/LaunchAgents/com.user.appblocker.plist` |
| Blocked apps | `~/.blocked_apps/` |
| Activity log | `/tmp/appblocker.log` |
| Error log | `/tmp/appblocker.err` |

## 🛡️ How It Works

The blocker uses a two-layer approach:

1. **Moves apps** to a hidden folder (`~/.blocked_apps`) during work hours
2. **Kills processes** every 120 seconds if they somehow start (optional, enabled by default)

This works within macOS security constraints without disabling System Integrity Protection.

## 📝 Scripts Included

| Script | Purpose |
|--------|---------|
| `install_daemon.sh` | Sets up automatic blocking |
| `uninstall_daemon.sh` | Removes everything cleanly |
| `app_blocker_daemon.sh` | Main daemon (runs in background) |
| `block_apps.sh` | Manually block apps |
| `unblock_apps.sh` | Manually unblock apps |
| `com.user.appblocker.plist` | macOS launch configuration |

## 💡 Ideas for Enhancement

- 📅 Skip weekends automatically
- 🎯 Different schedules for different days
- 📱 Menu bar app for quick control
- 🔔 Notifications when blocking/unblocking
- 🌐 Block websites too (modify `/etc/hosts`)

## ⚠️ Important Notes

- Apps must be in `/Applications/` folder
- The daemon checks every 120 seconds (configurable via `--interval`)
- Process killing is enabled by default (disable with `--no-kill`)
- All blocked apps are safely stored, never deleted
- Uninstalling restores everything to normal

## 🤝 Contributing

Feel free to modify for your needs! The code is straightforward bash scripting designed to be easy to understand and customize.

---

**Quick Start:** `chmod +x *.sh && ./install_daemon.sh` 🚀
