#!/usr/bin/env bash
# Shows the SDDM theme in a window without installing anything or logging you out.
# Logging in and powering off have no effect in test mode.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v sddm-greeter-qt6 >/dev/null 2>&1; then
  echo "sddm-greeter-qt6 not found (is the sddm package installed?)"
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cp -r "$REPO/sddm/nier" "$tmp/nier"
cp "$REPO/hypr/wallpaper.jpeg" "$tmp/nier/background.jpeg"

echo "Test window: close the window or press Ctrl+C here to quit."
sddm-greeter-qt6 --test-mode --theme "$tmp/nier"
