#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_SRC="$DOTFILES_DIR/agents"
AGENTS_DST="$HOME/.claude/agents"

if [[ -L "$AGENTS_DST" ]]; then
  current_target="$(readlink "$AGENTS_DST")"
  if [[ "$current_target" == "$AGENTS_SRC" ]]; then
    echo "agents: already linked → $AGENTS_SRC"
    exit 0
  fi
  echo "agents: updating symlink (was → $current_target)"
  rm "$AGENTS_DST"
elif [[ -d "$AGENTS_DST" ]]; then
  echo "agents: $AGENTS_DST exists as a real directory"
  echo "  back it up or remove it, then re-run this script"
  exit 1
elif [[ -e "$AGENTS_DST" ]]; then
  echo "agents: $AGENTS_DST exists but is not a directory or symlink — aborting"
  exit 1
fi

mkdir -p "$(dirname "$AGENTS_DST")"
ln -s "$AGENTS_SRC" "$AGENTS_DST"
echo "agents: linked $AGENTS_DST → $AGENTS_SRC"
