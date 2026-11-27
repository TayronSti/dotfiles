#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$CONFIG"
APPS=(hypr waybar swaync fuzzel kitty fish fastfetch cava)

for app in "${APPS[@]}"; do
  target="$CONFIG/$app"
  # Vorhandenen echten Ordner sichern, nie einfach überschreiben
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak.$(date +%s)"
  fi
  ln -sfn "$REPO/$app" "$target"
  echo "verlinkt: $target -> $REPO/$app"
done

# Einzelne Dateien (der restliche Ordner bleibt unberührt)
FILES=(gtk-3.0/settings.ini gtk-4.0/settings.ini)

for f in "${FILES[@]}"; do
  target="$CONFIG/$f"
  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak.$(date +%s)"
  fi
  ln -sfn "$REPO/$f" "$target"
  echo "verlinkt: $target -> $REPO/$f"
done

# qt6ct: Konfiguration mit dem Pfad dieses Rechners erzeugen (wird nicht verlinkt,
# weil der Pfad zum Farbschema auf jedem Rechner anders ist)
mkdir -p "$CONFIG/qt6ct"
qt6_target="$CONFIG/qt6ct/qt6ct.conf"
qt6_new="$(sed "s|@SCHEME@|$REPO/color-schemes/Nier.colors|" "$REPO/qt6ct/qt6ct.conf")"
if [ -f "$qt6_target" ] && [ "$(cat "$qt6_target")" != "$qt6_new" ]; then
  cp "$qt6_target" "$qt6_target.bak.$(date +%s)"
fi
printf '%s\n' "$qt6_new" > "$qt6_target"
echo "erzeugt: $qt6_target"
