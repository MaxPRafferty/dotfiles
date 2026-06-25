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

# fpx <name>: force-push the current HEAD as <name> to origin without touching the working tree
#   - deletes the local copy of <name> (if it exists) then re-creates it at current HEAD
#   - uses git branch (not checkout) so the working tree and index are never modified
#   - force-pushes <name> to origin; does not alter the currently checked-out branch
git config --global alias.fpx \
  "!f() { git branch -D \$1 2>/dev/null || true && git branch \$1 && git push --force origin \$1; }; f"
