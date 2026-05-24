#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_AGENTS_SRC="$DOTFILES_DIR/agents"
CLAUDE_AGENTS_DST="$HOME/.claude/agents"
CODEX_MARKETPLACE_SRC="$DOTFILES_DIR/codex-marketplace"

link_claude_agents() {
  if [[ -L "$CLAUDE_AGENTS_DST" ]]; then
    current_target="$(readlink "$CLAUDE_AGENTS_DST")"
    if [[ "$current_target" == "$CLAUDE_AGENTS_SRC" ]]; then
      echo "claude agents: already linked -> $CLAUDE_AGENTS_SRC"
      return
    fi
    echo "claude agents: updating symlink (was -> $current_target)"
    rm "$CLAUDE_AGENTS_DST"
  elif [[ -d "$CLAUDE_AGENTS_DST" ]]; then
    echo "claude agents: $CLAUDE_AGENTS_DST exists as a real directory"
    echo "  back it up or remove it, then re-run this script"
    exit 1
  elif [[ -e "$CLAUDE_AGENTS_DST" ]]; then
    echo "claude agents: $CLAUDE_AGENTS_DST exists but is not a directory or symlink; aborting"
    exit 1
  fi

  mkdir -p "$(dirname "$CLAUDE_AGENTS_DST")"
  ln -s "$CLAUDE_AGENTS_SRC" "$CLAUDE_AGENTS_DST"
  echo "claude agents: linked $CLAUDE_AGENTS_DST -> $CLAUDE_AGENTS_SRC"
}

install_codex_agents() {
  if ! command -v codex >/dev/null 2>&1; then
    echo "codex agents: codex CLI not found; skipping local marketplace registration"
    return
  fi

  if [[ ! -f "$CODEX_MARKETPLACE_SRC/.agents/plugins/marketplace.json" ]]; then
    echo "codex agents: missing marketplace at $CODEX_MARKETPLACE_SRC"
    exit 1
  fi

  if codex plugin marketplace add "$CODEX_MARKETPLACE_SRC"; then
    echo "codex agents: registered local marketplace $CODEX_MARKETPLACE_SRC"
  else
    echo "codex agents: marketplace add failed; attempting upgrade"
    codex plugin marketplace upgrade dotfiles-codex-agents
    echo "codex agents: upgraded local marketplace dotfiles-codex-agents"
  fi
}

link_claude_agents
install_codex_agents
