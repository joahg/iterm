#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "iTerm2 Configuration Installer"
echo "==============================="
echo

# Check if iTerm2 is running
if pgrep -x "iTerm2" > /dev/null; then
    echo "⚠️  iTerm2 is running. Please quit iTerm2 first, then re-run this script."
    echo "   (The preferences file can only be replaced when iTerm2 is not running)"
    exit 1
fi

# Install preferences
echo "→ Installing preferences..."
cp "$SCRIPT_DIR/com.googlecode.iterm2.plist" ~/Library/Preferences/com.googlecode.iterm2.plist
echo "  ✓ Copied to ~/Library/Preferences/"

# Install profile via Dynamic Profiles
echo "→ Installing profile..."
mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
cp "$SCRIPT_DIR/profile.json" ~/Library/Application\ Support/iTerm2/DynamicProfiles/
echo "  ✓ Copied to ~/Library/Application Support/iTerm2/DynamicProfiles/"

# Install key bindings
echo "→ Installing key bindings..."
plutil -convert json -o /tmp/keymap.json "$SCRIPT_DIR/key-bindings.itermkeymap"
python3 -c "
import json
with open('/tmp/keymap.json') as f:
    data = json.load(f)
mappings = data.get('Key Mappings', {})
with open('/tmp/globalkeymap.json', 'w') as f:
    json.dump(mappings, f)
"
# Convert JSON to XML plist format for defaults command
plutil -convert xml1 -o /tmp/globalkeymap.plist /tmp/globalkeymap.json
defaults write com.googlecode.iterm2 GlobalKeyMap "$(cat /tmp/globalkeymap.plist)"
rm /tmp/keymap.json /tmp/globalkeymap.json /tmp/globalkeymap.plist
echo "  ✓ Merged GlobalKeyMap into defaults"

echo
echo "✅ Done! Start iTerm2 to use your new configuration."
