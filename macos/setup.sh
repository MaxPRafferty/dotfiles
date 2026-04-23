#!/usr/bin/env bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}"

# ── Base installs ─────────────────────────────────────────────────────────────

xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# ── Apps ──────────────────────────────────────────────────────────────────────

brew install --cask visual-studio-code
brew install --cask google-chrome
brew install rectangle

# ── Node / Bun ────────────────────────────────────────────────────────────────

brew install npm
curl -fsSL https://bun.sh/install | bash

# ── Shell theme ───────────────────────────────────────────────────────────────

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ── VSCode extensions ─────────────────────────────────────────────────────────

code --install-extension vscodevim.vim
code --install-extension esbenp.prettier-vscode
code --install-extension github.copilot
code --install-extension MS-vsliveshare.vsliveshare

# ── VSCode settings symlink (macOS path) ─────────────────────────────────────

VSCODE_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_DIR"
ln -sf "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_DIR/settings.json"

# ── macOS system preferences ─────────────────────────────────────────────────

sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
defaults write -g com.apple.swipescrolldirection -bool FALSE
defaults write com.apple.Dock autohide -bool TRUE
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write -g AppleInterfaceStyle Dark
for d in $(defaults domains | tr -d ,); do
  osascript -e "app id \"$d\"" &>/dev/null || continue
  defaults write $d SmartQuotes -bool false
done

killall Finder
killall Dock
