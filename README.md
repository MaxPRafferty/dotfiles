# Dotfiles

Cross-platform development environment setup and configuration.

## Installation

```bash
git clone https://github.com/MaxPRafferty/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash setup.sh [universal|baseline|full]   # default: baseline
```

The setup script detects the current OS, symlinks universal config files, and
runs the appropriate system setup script for the chosen tier.

---

## Installation Preference Order

When installing tools, we follow this priority order — highest first:

1. **Packaged applications** (Flatpak on Linux, Homebrew Cask `.app` on macOS)
   Isolated binaries with no cross-dependency issues. Easy to install and remove.

2. **Version managers** for programming language runtimes
   Use nvm (Node), pyenv (Python), rbenv (Ruby), rustup (Rust), etc.
   Never install runtimes directly via the system package manager — version
   managers allow per-project version pinning and avoid system pollution.

3. **Linux-style package managers** (Homebrew, apt, dnf, pacman)
   Used for system utilities and tools that don't have a better option above.

4. **Building from source** — last resort only.

---

## Tool Tiers

### Universal

Minimal toolset intended for **remote systems you SSH into**. Fast to bootstrap,
low footprint. Only terminal tools — no GUI apps.

| Tool | Purpose | Config |
|------|---------|--------|
| git | Version control | — |
| vim | Terminal editor | `tool_config/vim/` |
| zsh | Shell | `tool_config/zsh/` |
| oh-my-zsh | Zsh framework | `tool_config/zsh/` |
| Powerlevel10k | Zsh prompt theme | `tool_config/p10k/` |

---

### Baseline

Full **development workstation** setup. Includes everything in Universal plus
all tools needed for daily productivity and development work.

| Tool | Purpose | Install method | Config |
|------|---------|---------------|--------|
| Visual Studio Code | Editor | Cask / Flatpak | `tool_config/vscode/` |
| Claude Code | AI coding assistant | npm global (after nvm) | — |
| Slack | Team communication | Cask / Flatpak | — |
| Google Chrome | Browser | Cask / Chromium Flatpak | — |
| nvm | Node version manager | install script | — |
| Node.js | JS runtime | via nvm | — |
| Bun | JS runtime / package manager | install script | — |
| pyenv | Python version manager | Brew / install script | — |
| Python | Scripting / data | via pyenv | — |
| Rectangle *(macOS only)* | Window management | Cask | — |
| SSH config | Key/host config | — | `tool_config/ssh/` |

---

### Full

Everything in Baseline plus **convenience and entertainment** tools.

| Tool | Purpose | Install method |
|------|---------|---------------|
| Spotify | Music | Cask / Flatpak |
| Steam | Gaming | Cask / Flatpak |

---

## Repository Structure

```
dotfiles/
├── setup.sh              # Root: symlinks dotfiles + dispatches by OS + tier
├── macos/setup.sh        # macOS-specific installs
├── debian/setup.sh       # Debian/Ubuntu-specific installs
├── redhat/setup.sh       # RHEL/Fedora/CentOS-specific installs
├── arch/setup.sh         # Arch Linux-specific installs
├── tool_config/
│   ├── vim/              # Vim config
│   ├── zsh/              # Zsh / oh-my-zsh config
│   ├── p10k/             # Powerlevel10k config
│   ├── vscode/           # VSCode settings
│   └── ssh/              # SSH client config
├── DESIGN.md             # Design principles
└── allowed-commands.txt  # Claude Code pre-approved read-only commands
```
