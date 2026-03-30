#!/usr/bin/env bash
# macOS system preference tweaks
# Run: ./macos-defaults.sh
# Some changes require logout/restart to take effect.

set -e

echo "Applying macOS defaults..."

# --- Keyboard ---
# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
echo "  ✓ Key repeat set to fastest"

# --- Accessibility ---
# Reduce motion (less GPU work, snappier on Intel)
defaults write com.apple.universalaccess reduceMotion -bool true 2>/dev/null || true
echo "  ✓ Reduce motion enabled"

# --- Finder ---
# Show filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
echo "  ✓ Finder preferences set"

# --- Dock ---
# Auto-hide Dock
defaults write com.apple.dock autohide -bool true
# Remove Dock show delay
defaults write com.apple.dock autohide-delay -float 0
# Faster Dock animation
defaults write com.apple.dock autohide-time-modifier -float 0.3
# Minimize to application
defaults write com.apple.dock minimize-to-application -bool true
echo "  ✓ Dock preferences set"

# --- Screenshots ---
# Save screenshots to ~/Screenshots
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
# Save as PNG
defaults write com.apple.screencapture type -string "png"
# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true
echo "  ✓ Screenshot preferences set"

# --- Misc ---
# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Disable auto-capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
echo "  ✓ Input corrections disabled"

# --- Restart affected apps ---
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true

echo ""
echo "Done! Log out and back in for all changes to take effect."
