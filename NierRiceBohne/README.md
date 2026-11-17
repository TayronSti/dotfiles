# NierRiceBohne

Mein Hyprland-Rice für Arch Linux im Look von NieR: gedämpftes Braun/Grau, eckige Kanten, Klammer-Optik in der Leiste.


## Was dabei ist

| Ordner | Programm |
| --- | --- |
| `hypr` | Hyprland (Lua-Config), Hyprpaper, Hyprlock, Wallpaper, Monitor-Dateien |
| `waybar` | Statusleiste |
| `swaync` | Benachrichtigungen und Kontrollzentrum |
| `fuzzel` | Programmstarter |
| `kitty` | Terminal |
| `fish` | Shell mit eigenem Prompt und Begrüßung |
| `fastfetch` | Systeminfo mit NieR-Logo |
| `cava` | Audio-Visualizer |

## Installation (frisches Arch)

Voraussetzung: ein installiertes Arch mit normalem Nutzer, `sudo` und Internet.

```bash
sudo pacman -S git
git clone https://github.com/TayronSti/dotfiles.git ~/dotfiles
cd ~/dotfiles/NierRiceBohne
chmod +x install.sh link.sh
./install.sh
```

Das Skript aktualisiert das System, installiert die Pakete (offizielle Repos und AUR), verlinkt die Configs nach `~/.config` und setzt Fish als Standard-Shell. Bereits vorhandene Config-Ordner werden vorher als `<name>.bak.<zahl>` gesichert.

Nur die Configs verlinken, ohne Pakete:

```bash
./link.sh
```

Gestartet wird Hyprland im TTY mit `start-hyprland` (nicht mit `Hyprland`) oder über einen Login-Manager.

## Pro Rechner anpassen

Monitore sind rechnerspezifisch. Beim Start lädt `hypr/hyprland.lua` die Datei `hypr/monitors_<hostname>.lua`, falls es sie gibt, sonst `hypr/monitors_default.lua`.

Für einen neuen Rechner:

1. Hostname ansehen: `cat /etc/hostname`
2. Monitornamen und Modi ansehen: `hyprctl monitors`
3. `hypr/monitors_default.lua` kopieren nach `hypr/monitors_<hostname>.lua` und anpassen

## Tastenkürzel (SUPER = Windows-Taste)

| Kürzel | Aktion |
| --- | --- |
| `SUPER + Q` | Terminal (kitty) |
| `SUPER + R` | Programmstarter (fuzzel) |
| `SUPER + E` | Dateimanager (dolphin) |
| `SUPER + C` | Fenster schließen |
| `SUPER + L` | Bildschirm sperren (nur von Hand, bewusst kein hypridle) |
| `SUPER + M` | Hyprland beenden |
| `SUPER + F` / `SUPER + SHIFT + F` | Maximieren / Vollbild |
| `SUPER + 1…0` | Workspace wechseln |
| `SUPER + SHIFT + 1…0` | Fenster auf Workspace verschieben |
| `SUPER + Pfeiltasten` | Fokus wechseln |
| `SUPER + V` | Zwischenablage-Verlauf |
| `SUPER + N` / `SUPER + SHIFT + N` | Kontrollzentrum / Benachrichtigungen löschen |
| `Druck` | Screenshot (ganzer Bildschirm) |
| `SUPER + SHIFT + S` | Screenshot (Bereich, in Zwischenablage und Datei) |
| `SUPER + SHIFT + B` | Waybar neu starten |
| `ALT + TAB` | Fensterwechsler (siehe unten) |

Screenshots landen im Unterordner `Screenshots` des Bilder-Ordners des Systems.

## Bekannte Lücken

- **Fensterwechsler**: `ALT + TAB` nutzt `hyprswitch` aus dem AUR. Das ist ein Fork des ursprünglichen Projekts (das heißt inzwischen `hyprshell`), er wird mit Version 5 für Hyprlands Lua-Config gepflegt. Wer lieber `hyprshell` nutzen will, muss die Aufrufe in `hyprland.lua` anpassen.
- **Persönliches Spiel-Setup**: `hypr/games.lua` (Fensterregeln für Spiel-Overlays und der Start von `hypr/poe-remap.sh`) ist optional. `poe-remap.sh` schaltet ein `input-remapper`-Preset für eine Logitech G502 nur an, solange Path of Exile im Fokus ist, und braucht `input-remapper`, `socat` und das Preset aus `input-remapper-2/`. `install.sh` fragt, ob der Zusatz installiert werden soll. Wer ihn nicht braucht, löscht `games.lua`, `hyprland.lua` überspringt die Datei dann.
