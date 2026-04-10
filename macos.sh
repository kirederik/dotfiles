#!/usr/bin/env bash
# macOS system defaults
# Run once after bootstrap, or re-run to reset preferences.
set -euo pipefail

echo "==> Applying macOS defaults..."

# ─── Finder ───────────────────────────────────────────────────────────────────
defaults write com.apple.finder ShowAllFiles -bool true               # show hidden files
defaults write NSGlobalDomain AppleShowAllExtensions -bool true       # show all extensions
defaults write com.apple.finder ShowStatusBar -bool true              # status bar
defaults write com.apple.finder ShowPathbar -bool true                # path bar
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"   # search current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXSortFoldersFirst -bool true        # folders first
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # list view
# Avoid creating .DS_Store on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ─── Dock ─────────────────────────────────────────────────────────────────────
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.8
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock show-recents -bool false                # no recent apps

# ─── Keyboard ─────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain KeyRepeat -int 2                        # fast key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15                # short delay
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false    # disable press-and-hold accent menu

# ─── Trackpad ─────────────────────────────────────────────────────────────────
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1     # tap to click

# ─── Screenshots ──────────────────────────────────────────────────────────────
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ─── Menu bar clock ───────────────────────────────────────────────────────────
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm"

# ─── Activity Monitor ─────────────────────────────────────────────────────────
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor ShowCategory -int 0         # all processes

# ─── TextEdit ─────────────────────────────────────────────────────────────────
defaults write com.apple.TextEdit RichText -int 0                    # plain text by default
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# ─── Disable smart quotes / dashes (kills coding ─────────────────────────────
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ─── Restart affected apps ────────────────────────────────────────────────────
for app in "Finder" "Dock" "SystemUIServer"; do
  killall "$app" &>/dev/null || true
done

echo "==> macOS defaults applied. Some changes require a logout/restart."
