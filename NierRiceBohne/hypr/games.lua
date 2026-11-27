-- Personal window rules for game overlays.
-- Optional: delete this file and hyprland.lua skips it.

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
