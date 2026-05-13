-- Monitor configuration

local host = require("lua.host")

if host.is_laptop then
    -- Laptop screen
    hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 2.0 })
    -- External monitor (HDMI) — positioned centered above laptop
    hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "-684x-1620", scale = 1.333333 })
elseif host.is_desktop then
    hl.monitor({ output = "HDMI-A-2", mode = "preferred", position = "0x0", scale = "auto" })
end

-- Fallback for any other monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
