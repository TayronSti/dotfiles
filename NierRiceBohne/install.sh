#!/usr/bin/env bash
# NierRiceBohne - installation on a fresh Arch Linux
# Installs the packages and links the configs into ~/.config (via link.sh).
# Run as a regular user, not as root. sudo asks for your password when needed.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"

if [ "$EUID" -eq 0 ]; then
  echo "Please don't run this as root, run it as a regular user."
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found - this script is for Arch Linux only."
  exit 1
fi

# --- Packages from the official repos ----------------------------------------
OFFICIAL_PKGS=(
  base-devel git less
  hyprland hyprpaper hyprlock hyprpolkitagent xdg-desktop-portal-hyprland
  waybar swaync fuzzel kitty fish fastfetch cava btop
  cliphist wl-clipboard grim slurp xdg-user-dirs
  networkmanager network-manager-applet
  pipewire pipewire-pulse wireplumber pavucontrol playerctl
  breeze-icons dolphin gnome-keyring qt5-wayland qt6-wayland libnotify
  ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
)

# --- Packages from the AUR ----------------------------------------------------
# hyprswitch: a maintained fork in the AUR (version 5 and later support Hyprland's
# Lua config), the Alt+Tab window switcher.
AUR_PKGS=(
  wlogout
  hyprswitch
  qt6ct-kde
)

echo "==> Updating the system"
sudo pacman -Syu

TO_INSTALL=()
MISSING=()
for p in "${OFFICIAL_PKGS[@]}"; do
  if pacman -Si "$p" >/dev/null 2>&1; then
    TO_INSTALL+=("$p")
  else
    MISSING+=("$p")
  fi
done

echo "==> Installing packages"
sudo pacman -S --needed "${TO_INSTALL[@]}"

# --- AUR helper ----------------------------------------------------------------
HELPER=""
if command -v paru >/dev/null 2>&1; then
  HELPER="paru"
elif command -v yay >/dev/null 2>&1; then
  HELPER="yay"
fi

if [ -z "$HELPER" ]; then
  read -r -p "No AUR helper found. Install paru? [y/N] " ans
  if [[ "$ans" =~ ^[yYjJ]$ ]]; then
    tmp="$(mktemp -d)"
    git clone https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin"
    (cd "$tmp/paru-bin" && makepkg -si)
    rm -rf "$tmp"
    HELPER="paru"
  fi
fi

# Install each AUR package on its own: if one fails, the others still get installed
FAILED_AUR=()
if [ -n "$HELPER" ]; then
  echo "==> Installing AUR packages ($HELPER)"
  for p in "${AUR_PKGS[@]}"; do
    "$HELPER" -S --needed "$p" || FAILED_AUR+=("$p")
  done
else
  echo "Skipping AUR packages."
  FAILED_AUR=("${AUR_PKGS[@]}")
fi

# --- Link configs ----------------------------------------------------------------
echo "==> Linking configs"
bash "$REPO/link.sh"

# --- Fonts & shell -------------------------------------------------------------------
fc-cache -f >/dev/null 2>&1 || true

if [ "$(basename "${SHELL:-}")" != "fish" ]; then
  echo "==> Setting fish as the default shell"
  chsh -s "$(command -v fish)" || echo "chsh failed, do it manually later: chsh -s /usr/bin/fish"
fi

# --- Final notes ---------------------------------------------------------------------------
echo
echo "==> Done. Still to do:"

if [ "${#MISSING[@]}" -gt 0 ]; then
  echo "  - These packages were not found in the repos and were skipped: ${MISSING[*]}"
fi

if [ "${#FAILED_AUR[@]}" -gt 0 ]; then
  echo "  - These AUR packages could not be installed: ${FAILED_AUR[*]}"
  echo "    Install them later with: ${HELPER:-paru} -S ${FAILED_AUR[*]}"
fi

host="$(cat /etc/hostname 2>/dev/null | tr -cd 'A-Za-z0-9_-' || true)"
if [ ! -f "$REPO/hypr/monitors_${host}.lua" ]; then
  echo "  - There is no monitor file for this machine ('${host}'), hypr/monitors_default.lua is used."
  echo "    Create your own: hypr/monitors_${host}.lua (monitor names: hyprctl monitors)"
fi

if ! systemctl is-active --quiet NetworkManager; then
  echo "  - Network: nm-applet and nmtui need NetworkManager:"
  echo "    sudo systemctl enable --now NetworkManager  (only if no other network service is running)"
fi
echo "  - Then log out and back in and start Hyprland with start-hyprland."
