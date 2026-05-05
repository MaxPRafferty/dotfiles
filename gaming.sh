#!/usr/bin/env bash
set -e

# ── OS check: Arch-based only ─────────────────────────────────────────────────

if [ ! -f /etc/os-release ]; then
  echo "Error: Cannot detect OS — /etc/os-release not found." >&2
  exit 1
fi
. /etc/os-release
if ! echo "$ID $ID_LIKE" | grep -qE "arch|manjaro"; then
  echo "Error: This script is for Arch-based systems only (detected: ${PRETTY_NAME:-$ID})." >&2
  exit 1
fi

echo "Setting up gaming on ${PRETTY_NAME:-$ID}..."

# ── Gaming packages ───────────────────────────────────────────────────────────

if pacman -Si cachyos-gaming-applications &>/dev/null; then
  # CachyOS: meta package covers Steam, Lutris, Heroic, MangoHud, Gamescope,
  # GOverlay, Wine, Proton-CachyOS, UMU-launcher, Protontricks, Winetricks
  sudo pacman -S --noconfirm cachyos-gaming-applications
else
  sudo pacman -S --noconfirm \
    steam \
    lutris \
    mangohud \
    lib32-mangohud \
    gamescope \
    wine \
    winetricks \
    protontricks
fi

# gamemode may not be pulled in transitively on all setups
if ! command -v gamemoderun &>/dev/null; then
  sudo pacman -S --noconfirm gamemode lib32-gamemode
fi

# ── SCX scheduler (CachyOS gaming performance) ────────────────────────────────

if pacman -Q scx-scheds &>/dev/null; then
  if ! systemctl is-active --quiet scx; then
    sudo systemctl enable --now scx
    echo "SCX scheduler enabled."
  else
    echo "SCX scheduler already active, skipping."
  fi
else
  echo "scx-scheds not installed, skipping SCX scheduler setup."
fi

# ── NVIDIA: nvidia_drm.modeset=1 for Wayland ─────────────────────────────────

if lspci | grep -qi nvidia; then
  echo "NVIDIA GPU detected, configuring nvidia_drm.modeset=1..."

  if [ -f /etc/default/limine ]; then
    if grep -q "nvidia_drm.modeset=1" /etc/default/limine; then
      echo "nvidia_drm.modeset=1 already present in /etc/default/limine, skipping."
    else
      echo "KERNEL_CMDLINE[default]+=nvidia_drm.modeset=1" | sudo tee -a /etc/default/limine
      sudo limine-update
      echo "Limine updated — reboot to apply nvidia_drm.modeset=1."
    fi
  elif [ -f /etc/default/grub ]; then
    if grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
      echo "nvidia_drm.modeset=1 already present in GRUB config, skipping."
    else
      sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia_drm.modeset=1"/' /etc/default/grub
      sudo grub-mkconfig -o /boot/grub/grub.cfg
      echo "GRUB updated — reboot to apply nvidia_drm.modeset=1."
    fi
  else
    echo "Warning: Could not detect bootloader config (tried Limine and GRUB)." >&2
    echo "Manually add 'nvidia_drm.modeset=1' to your kernel command line." >&2
  fi
else
  echo "No NVIDIA GPU detected, skipping modeset configuration."
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "Gaming setup complete."
echo "  - Add 'gamemoderun %command%' to Steam launch options to enable GameMode per game."
echo "  - Use GOverlay to configure MangoHud overlay settings."
if lspci | grep -qi nvidia; then
  echo "  - Reboot to apply NVIDIA kernel parameter changes."
fi
