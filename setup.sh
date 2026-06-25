#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

# Tier: universal | baseline | full  (default: baseline)
TIER="${1:-baseline}"
export TIER

echo "Installing dotfiles — tier: $TIER"

# ── Universal dotfile symlinks (all tiers) ────────────────────────────────────

ln -sf "$DOTFILES_DIR/tool_config/zsh/.zshrc"       "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/tool_config/bash/.bashrc"     "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/tool_config/bash/.bash_profile" "$HOME/.bash_profile"
ln -sf "$DOTFILES_DIR/tool_config/vim/.vimrc"       "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/tool_config/p10k/.p10k.zsh"   "$HOME/.p10k.zsh"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
ln -sf "$DOTFILES_DIR/tool_config/ssh/config" "$HOME/.ssh/config"

# ── Git aliases (universal) ───────────────────────────────────────────────────

bash "$DOTFILES_DIR/tool_config/git/aliases.sh"

# ── Dispatch to system-specific setup ────────────────────────────────────────

case "$(uname -s)" in
  Darwin)
    bash "$DOTFILES_DIR/macos/setup.sh"
    ;;
  Linux)
    if [ ! -f /etc/os-release ]; then
      echo "Cannot detect Linux distribution: /etc/os-release not found"
      exit 1
    fi
    . /etc/os-release
    case "$ID $ID_LIKE" in
      *debian*|*ubuntu*)
        bash "$DOTFILES_DIR/debian/setup.sh"
        ;;
      *rhel*|*fedora*|*centos*|*rocky*|*almalinux*)
        bash "$DOTFILES_DIR/redhat/setup.sh"
        ;;
      *arch*|*manjaro*)
        bash "$DOTFILES_DIR/arch/setup.sh"
        ;;
      *alpine*)
        bash "$DOTFILES_DIR/alpine/setup.sh"
        ;;
      *)
        echo "Unsupported Linux distribution: $ID"
        exit 1
        ;;
    esac
    ;;
  *)
    echo "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac

echo "Done. (tier: $TIER)"
