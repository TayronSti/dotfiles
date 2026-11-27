-- Blur behind the semi-transparent surfaces (swaync and fuzzel).
-- ignore_alpha: fully transparent parts of a layer are not blurred.
-- To see layer names: hyprctl layers (while the window is open)

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
