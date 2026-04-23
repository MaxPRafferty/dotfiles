# Dotfiles Design Principles

## 1. Neutrality

The repo should remain neutral. No artifacts or values explicitly tied to a specific individual should be committed. This includes but is not limited to:

- Git user name and email
- SSH keys or host-specific SSH identity references
- Work or personal account credentials or tokens
- Machine-specific paths or hostnames
- Personal API keys or secrets

Where a config file requires personal values (e.g. `.gitconfig`), commit a template with clearly marked placeholders rather than real values.

## 2. System Neutrality

The repo should work on any supported target system without modification. Supported targets are:

- macOS
- Debian / Ubuntu
- RHEL / Fedora / CentOS
- Arch Linux

System-specific setup logic lives in its own subdirectory (`macos/`, `debian/`, `redhat/`, `arch/`). The root `setup.sh` detects the current OS and dispatches to the appropriate system script. Config files that live at the repo root (`.zshrc`, `.vimrc`, etc.) must be portable across all targets. Anything that only applies to one system belongs in that system's subdirectory.

## 3. Cross-Platform Tool Setup

Tools are organized into three installation tiers (see README for full lists):

- **Universal** — minimal footprint for remote/SSH systems (git, vim, zsh)
- **Baseline** — full development workstation (VSCode, Claude, Slack, runtimes)
- **Full** — everything including convenience tools (Spotify, Steam)

All tool-specific configuration lives in `tool_config/<tool>/`. The root `setup.sh` accepts a tier argument (`bash setup.sh [universal|baseline|full]`, default: `baseline`).

### Installation Preference Order

When installing a tool, prefer methods in this order:

1. **Packaged applications** — Flatpak on Linux, native `.app` via Homebrew Cask on macOS. Isolated, no cross-dependency issues, easy to remove.
2. **Version managers** — use nvm, pyenv, rbenv, rustup, etc. for programming language runtimes. Never install runtimes directly via the system package manager.
3. **Linux-style package managers** — Homebrew (macOS), apt, dnf, pacman.
4. **Building from source** — last resort only.

These preferences apply to both setup scripts and manual installs. When adding a new tool, choose the highest-preference method available for each target platform.
