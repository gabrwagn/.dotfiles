-- Monitor configuration

local host = require("lua.host")


if host.is_laptop then
    -- External monitor (HDMI) — primary
    hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1.333333 })
    -- Laptop screen — mirror HDMI when both are connected
    hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 2.0, mirror = "HDMI-A-1" })

elseif host.is_desktop then
    hl.monitor({ output = "HDMI-A-2", mode = "preferred", position = "0x0", scale = "auto" })
end

-- Fallback for any other monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
