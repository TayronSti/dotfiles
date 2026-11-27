#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$CONFIG"
APPS=(hypr waybar swaync fuzzel kitty fish fastfetch cava)

for app in "${APPS[@]}"; do
  target="$CONFIG/$app"
  # Back up an existing real folder, never just overwrite it
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak.$(date +%s)"
  fi
  ln -sfn "$REPO/$app" "$target"
  echo "linked: $target -> $REPO/$app"
done

# Single files (the rest of the folder stays untouched)
FILES=(gtk-3.0/settings.ini gtk-4.0/settings.ini)

for f in "${FILES[@]}"; do
  target="$CONFIG/$f"
  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak.$(date +%s)"
  fi
  ln -sfn "$REPO/$f" "$target"
  echo "linked: $target -> $REPO/$f"
done

# qt6ct: generate the config with this machine's path (not linked,
# because the path to the color scheme differs on every machine)
mkdir -p "$CONFIG/qt6ct"
qt6_target="$CONFIG/qt6ct/qt6ct.conf"
qt6_new="$(sed "s|@SCHEME@|$REPO/color-schemes/Nier.colors|" "$REPO/qt6ct/qt6ct.conf")"
if [ -f "$qt6_target" ] && [ "$(cat "$qt6_target")" != "$qt6_new" ]; then
  cp "$qt6_target" "$qt6_target.bak.$(date +%s)"
fi
printf '%s\n' "$qt6_new" > "$qt6_target"
echo "generated: $qt6_target"
