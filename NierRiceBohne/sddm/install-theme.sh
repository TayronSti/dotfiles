#!/usr/bin/env bash
# Installiert das SDDM-Theme "nier" systemweit. Der Greeter läuft als eigener Benutzer
# und kann dein Home nicht lesen, deshalb wird kopiert und nicht verlinkt.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
THEMES="/usr/share/sddm/themes"

if ! command -v sddm-greeter-qt6 >/dev/null 2>&1; then
  echo "sddm-greeter-qt6 nicht gefunden (ist das Paket sddm installiert?)"
  exit 1
fi

echo "==> Theme nach $THEMES/nier kopieren"
sudo install -d "$THEMES/nier"
sudo cp -r "$REPO/sddm/nier/." "$THEMES/nier/"
sudo install -Dm644 "$REPO/hypr/wallpaper.jpeg" "$THEMES/nier/background.jpeg"
sudo chmod -R a+rX "$THEMES/nier"

echo "==> Theme in /etc/sddm.conf.d/10-nier-theme.conf aktivieren"
sudo install -Dm644 "$REPO/sddm/10-nier-theme.conf" /etc/sddm.conf.d/10-nier-theme.conf

if grep -qs '^\[Theme\]' /etc/sddm.conf 2>/dev/null; then
  echo "Hinweis: /etc/sddm.conf enthält einen eigenen [Theme]-Abschnitt, der kann den Eintrag überschreiben."
fi

echo
echo "Fertig. Wirksam beim nächsten Login-Fenster (abmelden oder neu starten)."
echo "Zurück zum Standard: sudo rm /etc/sddm.conf.d/10-nier-theme.conf"
