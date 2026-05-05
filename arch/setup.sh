#!/usr/bin/env bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"}"
TIER="${TIER:-baseline}"

set_gsettings_bool() {
  local schema="$1"
  local key="$2"
  local value="$3"

  if command -v gsettings >/dev/null 2>&1 && gsettings writable "$schema" "$key" >/dev/null 2>&1; then
    gsettings set "$schema" "$key" "$value" || true
  fi
}

set_gsettings_array() {
  local schema="$1"
  local key="$2"
  local value="$3"

  if command -v gsettings >/dev/null 2>&1 && gsettings writable "$schema" "$key" >/dev/null 2>&1; then
    gsettings set "$schema" "$key" "$value" || true
  fi
}

configure_reverse_scroll_direction() {
  set_gsettings_bool org.gnome.desktop.peripherals.mouse natural-scroll false
  set_gsettings_bool org.gnome.desktop.peripherals.touchpad natural-scroll false
  set_gsettings_bool org.cinnamon.desktop.peripherals.mouse natural-scroll false
  set_gsettings_bool org.cinnamon.desktop.peripherals.touchpad natural-scroll false
}

configure_window_movement_shortcuts() {
  set_gsettings_array org.gnome.desktop.wm.keybindings move-to-side-w "['<Super>Left']"
  set_gsettings_array org.gnome.desktop.wm.keybindings move-to-side-e "['<Super>Right']"
  set_gsettings_array org.gnome.desktop.wm.keybindings move-to-side-n "['<Super>Up']"
  set_gsettings_array org.gnome.desktop.wm.keybindings move-to-side-s "['<Super>Down']"
  set_gsettings_array org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"

  set_gsettings_array org.cinnamon.desktop.keybindings.wm push-tile-left "['<Super>Left']"
  set_gsettings_array org.cinnamon.desktop.keybindings.wm push-tile-right "['<Super>Right']"
  set_gsettings_array org.cinnamon.desktop.keybindings.wm push-tile-up "['<Super>Up']"
  set_gsettings_array org.cinnamon.desktop.keybindings.wm push-tile-down "['<Super>Down']"
  set_gsettings_array org.cinnamon.desktop.keybindings.wm toggle-fullscreen "['<Super>f']"
}

# ── [universal] System update ─────────────────────────────────────────────────

sudo pacman -Syu --noconfirm

# ── [universal] Base packages ─────────────────────────────────────────────────

sudo pacman -S --noconfirm \
  git \
  curl \
  wget \
  python \
  python-pipx \
  zsh \
  vim \
  base-devel \
  ca-certificates \
  fontconfig \
  openssl \
  sqlite \
  readline

chsh -s "$(which zsh)"

# ── [universal] AUR helper (yay) ─────────────────────────────────────────────

if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
fi

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

# ── [baseline+] Flatpak (preferred package format for GUI apps on Linux) ──────

if [[ "$TIER" == "baseline" || "$TIER" == "full" ]]; then
  sudo pacman -S --noconfirm flatpak
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  # ── [baseline+] System preferences ───────────────────────────────────────────

  configure_reverse_scroll_direction
  configure_window_movement_shortcuts

  # GUI apps via Flatpak
  flatpak install -y flathub com.visualstudio.code
  flatpak install -y flathub com.slack.Slack
  # Note: Google Chrome is not on Flathub; using Chromium instead.
  # To install Chrome via AUR: yay -S --noconfirm google-chrome
  flatpak install -y flathub org.chromium.Chromium

  # ── [baseline+] Caffeine (prevent screen sleep) ───────────────────────────────

  yay -S --noconfirm caffeine-ng

  # ── [baseline+] VSCode settings symlink (Linux path) ──────────────────────────

  VSCODE_DIR="$HOME/.config/Code/User"
  mkdir -p "$VSCODE_DIR"
  ln -sf "$DOTFILES_DIR/tool_config/vscode/settings.json" "$VSCODE_DIR/settings.json"

  # ── [baseline+] VSCode extensions (run after flatpak VSCode is on PATH) ───────

  # code --install-extension vscodevim.vim
  # code --install-extension esbenp.prettier-vscode
  # code --install-extension github.copilot
  # code --install-extension MS-vsliveshare.vsliveshare
  # TODO: flatpak VSCode may need 'flatpak run com.visualstudio.code' alias

  # ── [baseline+] Runtimes via version managers (preferred over pacman install) ─

  # Node — via nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm use --lts

  # Python — via pyenv
  curl https://pyenv.run | bash
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  pyenv install --skip-existing 3
  pyenv global 3

  # Bun
  curl -fsSL https://bun.sh/install | bash

  # ── [baseline+] AI CLI tools (require Node/npm via nvm above) ────────────────

  npm install -g @anthropic-ai/claude-code
  npm install -g @google/gemini-cli
  npm install -g @openai/codex
fi

# ── [full] Convenience tools ──────────────────────────────────────────────────

if [[ "$TIER" == "full" ]]; then
  flatpak install -y flathub com.spotify.Client
  flatpak install -y flathub com.valvesoftware.Steam
fi

# ── System configuration ──────────────────────────────────────────────────────

# TODO: add Arch-specific system config
