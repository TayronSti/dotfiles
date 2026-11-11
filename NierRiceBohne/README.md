# NierRiceBohne

Mein Hyprland-Rice für Arch Linux im Look von NieR: gedämpftes Braun/Grau, eckige Kanten, Klammer-Optik in der Leiste.


## Was dabei ist

| Ordner | Programm |
| --- | --- |
| `hypr` | Hyprland (Lua-Config), Hyprpaper, Wallpaper, Monitor-Dateien |
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
- **Sperrbildschirm**: Es gibt noch keinen (kein `hyprlock`).
- **Persönliche Fensterregeln**: Regeln für Spiel-Overlays liegen in `hypr/games.lua` und sind optional. Wer sie nicht braucht, löscht die Datei, `hyprland.lua` überspringt sie dann.
- **Waybar**: Die Workspace-Buttons in der Leiste funktionieren mit Hyprlands Lua-Config nur mit `waybar-git` (AUR). Das offizielle Paket (0.15.0) hat den Fix noch nicht. Sobald ein Release mit dem Fix erscheint, kann man auf das offizielle `waybar` wechseln.
