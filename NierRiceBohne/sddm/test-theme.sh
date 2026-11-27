#!/usr/bin/env bash
# Zeigt das SDDM-Theme in einem Fenster, ohne etwas zu installieren oder dich abzumelden.
# Anmelden und Ausschalten haben im Testmodus keine Wirkung.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v sddm-greeter-qt6 >/dev/null 2>&1; then
  echo "sddm-greeter-qt6 nicht gefunden (ist das Paket sddm installiert?)"
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cp -r "$REPO/sddm/nier" "$tmp/nier"
cp "$REPO/hypr/wallpaper.jpeg" "$tmp/nier/background.jpeg"

echo "Testfenster: zum Beenden das Fenster schließen oder hier Strg+C drücken."
sddm-greeter-qt6 --test-mode --theme "$tmp/nier"
