# Agent Instructions for iTerm2 Configuration

This repository contains iTerm2 configuration files. Here's how to work with them:

## File Locations

| File | Destination | Method |
|------|-------------|--------|
| `com.googlecode.iterm2.plist` | `~/Library/Preferences/com.googlecode.iterm2.plist` | Direct copy (quit iTerm2 first) |
| `profile.json` | `~/Library/Application Support/iTerm2/DynamicProfiles/` | Copy for auto-load |
| `key-bindings.itermkeymap` | Merged into preferences | Use defaults command |

## Installation Commands

### Full Preferences
```bash
# User must quit iTerm2 first
cp com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
```

### Profile (Dynamic Profiles method - no UI required)
Dynamic Profiles require a `"Profiles"` array wrapper. The raw profile.json must be wrapped:

```bash
mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
python3 -c "
import json
with open('profile.json') as f:
    profile = json.load(f)
wrapped = {'Profiles': [profile]}
with open('$HOME/Library/Application Support/iTerm2/DynamicProfiles/profile.json', 'w') as f:
    json.dump(wrapped, f, indent=2)
"
```

### Key Bindings (scripted - no UI required)
The `.itermkeymap` file contains a JSON object with `Key Mappings`. To apply without UI:

```bash
# Extract Key Mappings and write to GlobalKeyMap in defaults
plutil -convert json -o /tmp/keymap.json key-bindings.itermkeymap
python3 -c "
import json
with open('/tmp/keymap.json') as f:
    data = json.load(f)
mappings = data.get('Key Mappings', {})
with open('/tmp/globalkeymap.json', 'w') as f:
    json.dump(mappings, f)
"
# Convert JSON to XML plist format and merge into preferences
plutil -convert xml1 -o /tmp/globalkeymap.plist /tmp/globalkeymap.json
defaults write com.googlecode.iterm2 GlobalKeyMap "$(cat /tmp/globalkeymap.plist)"
```

## Notes

- The plist file contains the complete iTerm2 configuration including profiles, key bindings, and all settings
- Dynamic Profiles are automatically loaded by iTerm2 at startup from `~/Library/Application Support/iTerm2/DynamicProfiles/`
- Changes to Dynamic Profiles are picked up immediately without restart
- The profile uses Guid `6E9F2AE8-3339-45C7-978F-3A19C7D76592` which matches the Default Bookmark Guid in the plist

## Extracting Updated Configs

To export current settings:

```bash
# Export full preferences
cp ~/Library/Preferences/com.googlecode.iterm2.plist .

# Export a profile as JSON: 
# Preferences → Profiles → Other Actions → Save Profile as JSON

# Export key bindings:
# Preferences → Keys → Presets → Export
```
