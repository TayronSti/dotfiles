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
