#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_MARKETPLACE_SRC="$DOTFILES_DIR/codex-marketplace"

if ! command -v codex >/dev/null 2>&1; then
  echo "codex agents: codex CLI not found; install @openai/codex and re-run this script"
  exit 1
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
