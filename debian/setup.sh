#!/usr/bin/env bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}"

# ── System update ─────────────────────────────────────────────────────────────

sudo apt update && sudo apt upgrade -y

# ── Base packages ─────────────────────────────────────────────────────────────

sudo apt install -y \
  git \
  curl \
  wget \
  zsh \
  vim \
  build-essential \
  ca-certificates \
  gnupg

# TODO: add additional packages as needed

# ── Set zsh as default shell ──────────────────────────────────────────────────

chsh -s "$(which zsh)"

# ── Node / Bun ────────────────────────────────────────────────────────────────

# TODO: install nvm or use nodesource apt repo for Node
curl -fsSL https://bun.sh/install | bash

# ── Shell theme ───────────────────────────────────────────────────────────────

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ── VSCode ────────────────────────────────────────────────────────────────────

# TODO: install VSCode via apt (Microsoft repo) or snap
# snap install --classic code

# VSCode settings symlink (Linux path)
VSCODE_DIR="$HOME/.config/Code/User"
mkdir -p "$VSCODE_DIR"
ln -sf "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_DIR/settings.json"

# ── VSCode extensions ─────────────────────────────────────────────────────────

# TODO: uncomment after VSCode is installed
# code --install-extension vscodevim.vim
# code --install-extension esbenp.prettier-vscode
# code --install-extension github.copilot
# code --install-extension MS-vsliveshare.vsliveshare

# ── System configuration ──────────────────────────────────────────────────────

# TODO: add Debian/Ubuntu-specific system config
