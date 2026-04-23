#!/usr/bin/env bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}"
TIER="${TIER:-baseline}"

# ── [universal] System update ─────────────────────────────────────────────────

sudo dnf update -y

# ── [universal] Base packages ─────────────────────────────────────────────────

sudo dnf install -y \
  git \
  curl \
  wget \
  zsh \
  vim \
  gcc \
  gcc-c++ \
  make \
  ca-certificates \
  openssl-devel \
  bzip2-devel \
  libffi-devel \
  readline-devel \
  sqlite-devel \
  zlib-devel

chsh -s "$(which zsh)"

# ── [universal] Shell theme ───────────────────────────────────────────────────

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# ── [baseline+] Flatpak (preferred package format for GUI apps on Linux) ──────

if [[ "$TIER" == "baseline" || "$TIER" == "full" ]]; then
  sudo dnf install -y flatpak
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  # GUI apps via Flatpak
  flatpak install -y flathub com.visualstudio.code
  flatpak install -y flathub com.slack.Slack
  # Note: Google Chrome is not on Flathub; using Chromium instead.
  # To install Chrome, download the .rpm from google.com/chrome manually.
  flatpak install -y flathub org.chromium.Chromium

  # ── [baseline+] VSCode settings symlink (Linux path) ──────────────────────────

  VSCODE_DIR="$HOME/.config/Code/User"
  mkdir -p "$VSCODE_DIR"
  ln -sf "$DOTFILES_DIR/tool_config/vscode/settings.json" "$VSCODE_DIR/settings.json"

  # ── [baseline+] VSCode extensions (run after flatpak VSCode is on PATH) ───────

  # code --install-extension vscodevim.vim
  # code --install-extension esbenp.prettier-vscode
  # code --install-extension github.copilot
  # code --install-extension MS-vsliveshare.vsliveshare
  # TODO: flatpak VSCode may need 'flatpak run com.visualstudio.code' alias

  # ── [baseline+] Runtimes via version managers (preferred over dnf install) ────

  # Node — via nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm use --lts

  # Python — via pyenv
  curl https://pyenv.run | bash
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  pyenv install --skip-existing 3
  pyenv global 3

  # Bun
  curl -fsSL https://bun.sh/install | bash

  # ── [baseline+] Claude Code (requires Node/npm via nvm above) ─────────────────

  npm install -g @anthropic-ai/claude-code
fi

# ── [full] Convenience tools ──────────────────────────────────────────────────

if [[ "$TIER" == "full" ]]; then
  flatpak install -y flathub com.spotify.Client
  flatpak install -y flathub com.valvesoftware.Steam
fi

# ── System configuration ──────────────────────────────────────────────────────

# TODO: add RHEL/Fedora/CentOS-specific system config
