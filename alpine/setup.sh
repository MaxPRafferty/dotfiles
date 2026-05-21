#!/usr/bin/env bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}"
TIER="${TIER:-baseline}"

require_sudo() {
  if sudo -n true 2>/dev/null; then
    return
  fi

  if [[ ! -t 0 ]]; then
    echo "This setup needs sudo for apk and shell configuration."
    echo "Run it from an interactive terminal, or authenticate first with: sudo -v"
    exit 1
  fi

  sudo -v
}

require_sudo

# ── [universal] Package index ─────────────────────────────────────────────────

sudo apk update && sudo apk upgrade

# ── [universal] Base packages ─────────────────────────────────────────────────

sudo apk add --no-cache \
  git \
  curl \
  wget \
  python3 \
  py3-pip \
  pipx \
  zsh \
  vim \
  bash \
  shadow \
  ca-certificates \
  fontconfig \
  openssl

ZSH_BIN="$(command -v zsh)"
if [[ "$SHELL" != "$ZSH_BIN" ]]; then
  sudo chsh -s "$ZSH_BIN" "$USER"
fi

# ── [universal] Default editor ───────────────────────────────────────────────

grep -qxF 'EDITOR=vim' /etc/environment 2>/dev/null || echo 'EDITOR=vim' | sudo tee -a /etc/environment
grep -qxF 'VISUAL=vim' /etc/environment 2>/dev/null || echo 'VISUAL=vim' | sudo tee -a /etc/environment

# ── [universal] Shell theme ───────────────────────────────────────────────────

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
fi

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
P10K_DIR="$ZSH_CUSTOM_DIR/themes/powerlevel10k"
mkdir -p "$(dirname "$P10K_DIR")"
if [[ ! -d "$P10K_DIR/.git" ]]; then
  if [[ -e "$P10K_DIR" ]]; then
    echo "$P10K_DIR already exists but is not a git checkout; skipping Powerlevel10k clone"
  else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  fi
fi
ln -sf "$DOTFILES_DIR/tool_config/p10k/.p10k.zsh" "$HOME/.p10k.zsh"

# ── [universal] Bash prompt and Vim statusline ────────────────────────────────

pipx install powerline-shell || pipx upgrade powerline-shell

POWERLINE_VIM_DIR="$HOME/.vim/pack/powerline/start/powerline"
mkdir -p "$(dirname "$POWERLINE_VIM_DIR")"
if [[ ! -d "$POWERLINE_VIM_DIR/.git" ]]; then
  if [[ -e "$POWERLINE_VIM_DIR" ]]; then
    echo "$POWERLINE_VIM_DIR already exists but is not a git checkout; skipping Vim Powerline clone"
  else
    git clone --depth=1 https://github.com/powerline/powerline.git "$POWERLINE_VIM_DIR"
  fi
fi

# ── [universal] Powerline fonts ───────────────────────────────────────────────

sudo mkdir -p /usr/share/fonts
for font in Regular Bold Italic "Bold Italic"; do
  sudo curl -fsSL \
    -o "/usr/share/fonts/MesloLGS NF $font.ttf" \
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20${font// /%20}.ttf"
done
fc-cache -f

# ── [tools+] Build deps and runtimes via version managers ─────────────────────

if [[ "$TIER" == "tools" || "$TIER" == "baseline" || "$TIER" == "full" ]]; then

  # Build tools and pyenv dependencies (Alpine/musl equivalents)
  sudo apk add --no-cache \
    build-base \
    musl-dev \
    openssl-dev \
    bzip2-dev \
    readline-dev \
    sqlite-dev \
    zlib-dev \
    xz-dev \
    tk \
    libffi-dev

  # Node — via nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm use --lts

  # Python — via pyenv (requires build deps above; musl libc is supported)
  curl https://pyenv.run | bash
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  pyenv install --skip-existing 3
  pyenv global 3

  # Bun
  curl -fsSL https://bun.sh/install | bash

  # ── [tools+] AI CLI tools (require Node/npm via nvm above) ───────────────────

  npm install -g @anthropic-ai/claude-code
  npm install -g @google/gemini-cli
  npm install -g @openai/codex

fi

# ── [baseline+] Flatpak (preferred package format for GUI apps on Linux) ──────

if [[ "$TIER" == "baseline" || "$TIER" == "full" ]]; then
  sudo apk add --no-cache flatpak flatpak-xdg-utils
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  # GUI apps via Flatpak
  # Note: Flatpak on Alpine requires a running D-Bus session and XDG portals.
  # These installs are best run from a desktop session, not a TTY or container.
  flatpak install -y flathub com.visualstudio.code
  flatpak install -y flathub com.slack.Slack
  flatpak install -y flathub org.chromium.Chromium

  # ── [baseline+] VSCode settings symlink (Linux path) ──────────────────────────

  VSCODE_DIR="$HOME/.config/Code/User"
  mkdir -p "$VSCODE_DIR"
  ln -sf "$DOTFILES_DIR/tool_config/vscode/settings.json" "$VSCODE_DIR/settings.json"

fi

# ── [full] Convenience tools ──────────────────────────────────────────────────

if [[ "$TIER" == "full" ]]; then
  flatpak install -y flathub com.spotify.Client
  flatpak install -y flathub com.valvesoftware.Steam
fi

# ── System configuration ──────────────────────────────────────────────────────

# TODO: add Alpine-specific system config
