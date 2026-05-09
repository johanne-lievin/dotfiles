#!/usr/bin/env bash
# =============================================================================
# macos/defaults.sh
# Sensible macOS defaults, curated from Mathias Bynens' legendary .macos
# Focused on developer experience. Run: source macos/defaults.sh
# =============================================================================

set -euo pipefail
echo "Applying macOS defaults..."

# Ask for sudo upfront and keep it alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ── General ─────────────────────────────────────────────────────────────────
# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Reveal IP address, hostname, OS version when clicking the clock in login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# ── Typing — kill autocorrect for devs ──────────────────────────────────────
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ── Trackpad ────────────────────────────────────────────────────────────────
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ── Keyboard ────────────────────────────────────────────────────────────────
# Fast key repeat — critical for vim/terminal users
defaults write NSGlobalDomain KeyRepeat -int 2          # 120ms (min=1, default=6)
defaults write NSGlobalDomain InitialKeyRepeat -int 15  # 225ms (default=25)

# Full keyboard access — tab through all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# ── Screen ──────────────────────────────────────────────────────────────────
# Require password immediately after sleep
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to ~/Pictures/Screenshots
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

# Save screenshots as PNG (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# ── Finder ──────────────────────────────────────────────────────────────────
# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar and path bar
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default (options: icnv, clmv, glyv, Nlsv)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the ~/Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library 2>/dev/null || true

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# ── Dock ────────────────────────────────────────────────────────────────────
# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 24
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 48
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock orientation -string "right"

# Don't show recently used apps in Dock
defaults write com.apple.dock show-recents -bool false

# Don't animate opening applications
defaults write com.apple.dock launchanim -bool false

# ── Safari / Web ─────────────────────────────────────────────────────────────
# Note: Safari preferences are sandboxed on modern macOS and can't be written
# via defaults. Enable Develop menu manually: Safari → Settings → Advanced.

# ── Terminal ─────────────────────────────────────────────────────────────────
# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# ── Activity Monitor ─────────────────────────────────────────────────────────
# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0
# Sort results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# ── TextEdit ─────────────────────────────────────────────────────────────────
# Use plain text mode by default
defaults write com.apple.TextEdit RichText -int 0
# Open files with UTF-8
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# ── Time Machine ─────────────────────────────────────────────────────────────
# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# ── Restart affected apps ────────────────────────────────────────────────────
for app in "Activity Monitor" "Dock" "Finder" "Safari" "SystemUIServer"; do
  killall "${app}" &>/dev/null || true
done

echo "macOS defaults applied. Some changes require a logout/restart."
