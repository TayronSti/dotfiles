#!/usr/bin/env bash
DEVICE="Logitech G502 HERO Gaming Mouse"
PRESET="PoE"
CLASS="steam_app_238960"   # ggf. anpassen

active=0
stop_remap() { input-remapper-control --command stop --device "$DEVICE"; }
trap stop_remap EXIT

stop_remap

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
while read -r line; do
  case "$line" in
    activewindow\>\>*)
      cls="${line#activewindow>>}"
      cls="${cls%%,*}"
      if [[ "$cls" == "$CLASS" ]]; then
        if (( ! active )); then
          input-remapper-control --command start --device "$DEVICE" --preset "$PRESET"
          active=1
        fi
      else
        if (( active )); then
          stop_remap
          active=0
        fi
      fi
      ;;
  esac
done
