#!/usr/bin/env bash
# NierRiceBohne - Installation auf frischem Arch Linux
# Installiert Pakete und verlinkt die Configs nach ~/.config (über link.sh).
# Als normaler Nutzer starten, nicht als root. sudo wird bei Bedarf gefragt.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"

if [ "$EUID" -eq 0 ]; then
  echo "Bitte nicht als root starten, sondern als normaler Nutzer."
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman nicht gefunden - dieses Skript ist nur für Arch Linux."
  exit 1
fi

# --- Pakete aus den offiziellen Repos ---------------------------------------
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

# --- Pakete aus dem AUR -------------------------------------------------------
# hyprswitch: im AUR ein gepflegter Fork (ab Version 5 für Hyprlands Lua-Config),
# der Alt+Tab-Fensterwechsler.
AUR_PKGS=(
  wlogout
  hyprswitch
)

echo "==> System aktualisieren"
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

echo "==> Pakete installieren"
sudo pacman -S --needed "${TO_INSTALL[@]}"

# --- AUR-Helper ----------------------------------------------------------------
HELPER=""
if command -v paru >/dev/null 2>&1; then
  HELPER="paru"
elif command -v yay >/dev/null 2>&1; then
  HELPER="yay"
fi

if [ -z "$HELPER" ]; then
  read -r -p "Kein AUR-Helper gefunden. paru installieren? [j/N] " ans
  if [[ "$ans" =~ ^[jJyY]$ ]]; then
    tmp="$(mktemp -d)"
    git clone https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin"
    (cd "$tmp/paru-bin" && makepkg -si)
    rm -rf "$tmp"
    HELPER="paru"
  fi
fi

# Jedes AUR-Paket einzeln: scheitert eines, werden die anderen trotzdem installiert
FAILED_AUR=()
if [ -n "$HELPER" ]; then
  echo "==> AUR-Pakete installieren ($HELPER)"
  for p in "${AUR_PKGS[@]}"; do
    "$HELPER" -S --needed "$p" || FAILED_AUR+=("$p")
  done
else
  echo "AUR-Pakete übersprungen."
  FAILED_AUR=("${AUR_PKGS[@]}")
fi

# --- Configs verlinken -----------------------------------------------------------
echo "==> Configs verlinken"
bash "$REPO/link.sh"

# --- Schriften & Shell ---------------------------------------------------------------
fc-cache -f >/dev/null 2>&1 || true

if [ "$(basename "${SHELL:-}")" != "fish" ]; then
  echo "==> Standard-Shell auf fish setzen"
  chsh -s "$(command -v fish)" || echo "chsh fehlgeschlagen, später von Hand: chsh -s /usr/bin/fish"
fi

# --- Hinweise am Ende --------------------------------------------------------------------
echo
echo "==> Fertig. Noch zu erledigen:"

if [ "${#MISSING[@]}" -gt 0 ]; then
  echo "  - Diese Pakete wurden in den Repos nicht gefunden und übersprungen: ${MISSING[*]}"
fi

if [ "${#FAILED_AUR[@]}" -gt 0 ]; then
  echo "  - Diese AUR-Pakete konnten nicht installiert werden: ${FAILED_AUR[*]}"
  echo "    Später nachholen mit: paru -S ${FAILED_AUR[*]}"
fi

host="$(cat /etc/hostname 2>/dev/null | tr -cd 'A-Za-z0-9_-' || true)"
if [ ! -f "$REPO/hypr/monitors_${host}.lua" ]; then
  echo "  - Für diesen Rechner ('${host}') gibt es keine Monitor-Datei, es gilt hypr/monitors_default.lua."
  echo "    Eigene Datei anlegen: hypr/monitors_${host}.lua (Monitornamen zeigt: hyprctl monitors)"
fi

if ! systemctl is-active --quiet NetworkManager; then
  echo "  - Netzwerk: nm-applet und nmtui brauchen NetworkManager:"
  echo "    sudo systemctl enable --now NetworkManager  (nur, wenn nicht schon ein anderer Netzwerkdienst läuft)"
fi
echo "  - Danach ab- und wieder anmelden und Hyprland mit start-hyprland starten."
