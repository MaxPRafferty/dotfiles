#!/usr/bin/env bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}"
TIER="${TIER:-baseline}"

# ── [universal] Base installs ─────────────────────────────────────────────────

xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# ── [universal] Shell ─────────────────────────────────────────────────────────

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# ── [baseline+] Apps (Homebrew Cask — preferred over system packages) ─────────

if [[ "$TIER" == "baseline" || "$TIER" == "full" ]]; then
  brew install --cask visual-studio-code
  brew install --cask google-chrome
  brew install --cask slack
  brew install --cask rectangle

  # ── [baseline+] Runtimes via version managers (preferred over brew install) ──

  # Node — via nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm use --lts

  # Python — via pyenv
  brew install pyenv
  pyenv install --skip-existing 3
  pyenv global 3

  # Bun
  curl -fsSL https://bun.sh/install | bash

  # ── [baseline+] Claude Code (requires Node/npm via nvm above) ─────────────────

  npm install -g @anthropic-ai/claude-code

  # ── [baseline+] VSCode extensions ─────────────────────────────────────────────

  code --install-extension vscodevim.vim
  code --install-extension esbenp.prettier-vscode
  code --install-extension github.copilot
  code --install-extension MS-vsliveshare.vsliveshare

  # ── [baseline+] VSCode settings symlink (macOS path) ──────────────────────────

  VSCODE_DIR="$HOME/Library/Application Support/Code/User"
  mkdir -p "$VSCODE_DIR"
  ln -sf "$DOTFILES_DIR/tool_config/vscode/settings.json" "$VSCODE_DIR/settings.json"
fi

# ── [full] Convenience tools ──────────────────────────────────────────────────

if [[ "$TIER" == "full" ]]; then
  brew install --cask spotify
  brew install --cask steam
fi

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
