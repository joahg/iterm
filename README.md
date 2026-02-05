# iTerm2 Configuration

Personal iTerm2 configuration files including preferences, key bindings, and profile settings.

## Files

| File | Purpose |
|------|---------|
| `com.googlecode.iterm2.plist` | Full iTerm2 preferences (colors, AI settings, global options) |
| `key-bindings.itermkeymap` | Global keyboard shortcut presets |
| `profile.json` | Profile configuration (colors, fonts, status bar, etc.) |

## Quick Setup

Run the install script to set up everything automatically:

```bash
./install.sh
```

This will:
1. Copy preferences to `~/Library/Preferences/` (includes the profile)
2. Merge global key bindings into your preferences

**Note:** Quit iTerm2 before running the install script.

## Manual Setup

### 1. Preferences (com.googlecode.iterm2.plist)

Copy the plist to overwrite iTerm2's preferences:

```bash
# Quit iTerm2 first!
cp com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
```

### 2. Profile (profile.json)

The profile is already included in `com.googlecode.iterm2.plist`. Use `profile.json` only if you want to import just the profile without other settings.

**Option A: Dynamic Profiles (for profile-only install)**

Dynamic Profiles require the profile to be wrapped in a `"Profiles"` array:

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

**Note:** Do not use Dynamic Profiles if you've already installed the full plist—they share the same GUID and will conflict.

**Option B: Manual Import**

1. Open iTerm2 → Preferences (⌘,)
2. Go to Profiles
3. Click "Other Actions..." → "Import JSON Profiles..."
4. Select `profile.json`
5. Click "Other Actions..." → "Set as Default"

### 3. Key Bindings (key-bindings.itermkeymap)

**Option A: Merge via defaults (Scripted)**

```bash
# This merges the GlobalKeyMap from the keymap file into your preferences
plutil -convert json -o - key-bindings.itermkeymap | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(json.dumps(d.get('Key Mappings',{})))" | \
  plutil -convert xml1 -o /tmp/keymap.plist - && \
  defaults write com.googlecode.iterm2 GlobalKeyMap "$(cat /tmp/keymap.plist)"
```

**Option B: Manual Import**

1. Open iTerm2 → Preferences (⌘,)
2. Go to Keys → Key Bindings
3. Click "Presets..." → "Import..."
4. Select `key-bindings.itermkeymap`

## Features

- **Solarized Dark color scheme** with custom cursor colors
- **Meslo LG M for Powerline** font at 14pt
- **Status bar** with CPU, memory, and network utilization
- **AI integration** configured for OpenAI GPT-5.1
- **Custom key bindings** for navigation and text editing
- **Option key sends +Esc** for proper meta key behavior

## Requirements

- [iTerm2](https://iterm2.com/) 3.4+
- [Meslo LG M for Powerline](https://github.com/powerline/fonts) font (optional, for best display)
