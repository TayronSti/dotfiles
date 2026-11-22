-- Blur hinter den halbtransparenten Flächen (swaync und fuzzel).
-- ignore_alpha: völlig durchsichtige Bereiche der Layer werden nicht verschwommen.
-- Die Namen der Layer zeigt: hyprctl layers (während das Fenster offen ist)

hl.layer_rule({
    name         = "swaync-blur",
    match        = { namespace = "^swaync-notification-window$" },
    blur         = true,
    ignore_alpha = 0.3,
})

hl.layer_rule({
    name         = "fuzzel-blur",
    match        = { namespace = "^launcher$" },
    blur         = true,
    ignore_alpha = 0.3,
})
