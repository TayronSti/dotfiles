#!/usr/bin/env bash
# Installs the SDDM theme "nier" system-wide. The greeter runs as its own user
# and cannot read your home folder, so the theme is copied instead of linked.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
THEMES="/usr/share/sddm/themes"

if ! command -v sddm-greeter-qt6 >/dev/null 2>&1; then
  echo "sddm-greeter-qt6 not found (is the sddm package installed?)"
  exit 1
fi

echo "==> Copying theme to $THEMES/nier"
sudo install -d "$THEMES/nier"
sudo cp -r "$REPO/sddm/nier/." "$THEMES/nier/"
sudo install -Dm644 "$REPO/hypr/wallpaper.jpeg" "$THEMES/nier/background.jpeg"
sudo chmod -R a+rX "$THEMES/nier"

echo "==> Activating theme in /etc/sddm.conf.d/10-nier-theme.conf"
sudo install -Dm644 "$REPO/sddm/10-nier-theme.conf" /etc/sddm.conf.d/10-nier-theme.conf

if grep -qs '^\[Theme\]' /etc/sddm.conf 2>/dev/null; then
  echo "Note: /etc/sddm.conf has its own [Theme] section, which may override this setting."
fi

echo
echo "Done. Takes effect on the next login screen (log out or reboot)."
echo "Back to the default theme: sudo rm /etc/sddm.conf.d/10-nier-theme.conf"
