-- Persönliches Spiel-Setup: Fensterregeln für Overlays und das Maus-Profil für Path of Exile.
-- Optional: Datei löschen, dann überspringt hyprland.lua sie.

hl.window_rule({
    name = "aion-dps-meter",
    match = {
        class = "^(a2tools\\-dps\\-meter)$",
    },
    float = true,
    pin = true,
    no_blur = true,
    border_size = 0,
})

hl.window_rule({
    name = "awakened-poe-trade",
    match = {
        class = "^awakened-poe-trade$",
    },
    float = true,
    pin = true,
    no_blur = true,
    border_size = 0,
})

-- Maus-Profil: poe-remap.sh schaltet ein input-remapper-Preset nur an, solange Path of Exile
-- im Fokus ist. Startet nur, wenn input-remapper und socat installiert sind.
hl.on("hyprland.start", function()
    hl.exec_cmd("command -v input-remapper-control >/dev/null && command -v socat >/dev/null && ~/.config/hypr/poe-remap.sh")
end)
