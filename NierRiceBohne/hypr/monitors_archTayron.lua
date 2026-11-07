-- Desktop-PC: 2 Monitore
hl.monitor({
    output   = "DP-3",
    mode     = "2560x1440@143.91",
    position = "0x0",
    scale    = "1",
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@100",
    position = "2560x0",
    scale    = "1",
})

for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-3" })
end

for i = 6, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end
