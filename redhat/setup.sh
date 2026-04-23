#!/usr/bin/env bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}"

# ── System update ─────────────────────────────────────────────────────────────

sudo dnf update -y

# ── Base packages ─────────────────────────────────────────────────────────────

sudo dnf install -y \
  git \
  curl \
  wget \
  zsh \
  vim \
  gcc \
  gcc-c++ \
  make \
  ca-certificates

# TODO: add additional packages as needed

# ── Set zsh as default shell ──────────────────────────────────────────────────

chsh -s "$(which zsh)"

# ── Node / Bun ────────────────────────────────────────────────────────────────

# TODO: install Node via dnf (nodesource) or nvm
curl -fsSL https://bun.sh/install | bash

# ── Shell theme ───────────────────────────────────────────────────────────────

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ── VSCode ────────────────────────────────────────────────────────────────────

# TODO: install VSCode via rpm (Microsoft repo) or flatpak
# sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
# sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
# sudo dnf install -y code

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

# TODO: add RHEL/Fedora/CentOS-specific system config
