#!/usr/bin/env bash
# Git aliases — applied via git config --global (idempotent, safe to re-run)

# ── Log / history ─────────────────────────────────────────────────────────────

# ls: pretty graph log with relative dates, author, and branch decorations
git config --global alias.ls \
  "log --graph --abbrev-commit --decorate --color=always --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) - %C(dim red)%an%C(reset)%C(bold yellow)%d%C(reset)' --all"

# ── Branching ─────────────────────────────────────────────────────────────────

# nb <name>: new branch from a fresh copy of dev
#   - saves current work-in-progress to a temp branch (zztmpzz) so it isn't lost
#   - fetches latest dev and creates the new branch from it
git config --global alias.nb \
  "!f() { git branch -D zztmpzz || true && git checkout -b zztmpzz && git branch -D dev || true && git fetch && git checkout dev && git checkout -b \$1; }; f"
