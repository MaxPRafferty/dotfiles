#!/usr/bin/env bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}"

# ── System update ─────────────────────────────────────────────────────────────

sudo pacman -Syu --noconfirm

# ── Base packages ─────────────────────────────────────────────────────────────

sudo pacman -S --noconfirm \
  git \
  curl \
  wget \
  zsh \
  vim \
  base-devel \
  ca-certificates

# TODO: add additional packages as needed
# TODO: consider yay or paru for AUR packages

# ── Set zsh as default shell ──────────────────────────────────────────────────

chsh -s "$(which zsh)"

# ── Node / Bun ────────────────────────────────────────────────────────────────

# TODO: install Node via pacman or nvm
# sudo pacman -S --noconfirm nodejs npm
curl -fsSL https://bun.sh/install | bash

# ── Shell theme ───────────────────────────────────────────────────────────────

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ── VSCode ────────────────────────────────────────────────────────────────────

# TODO: install VSCode via AUR (yay) or official bin package
# yay -S --noconfirm visual-studio-code-bin

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

# TODO: add Arch-specific system config
