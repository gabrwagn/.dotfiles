-- Monitor configuration

local host = require("lua.host")

if host.is_laptop then
    -- Laptop screen
    hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 2.0 })
    -- External monitor (HDMI) — positioned centered above laptop
    hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "-684x-1620", scale = 1.333333 })

    -- Disable laptop screen when external monitor is connected
    hl.on("monitor.added", function(monitor)
        if monitor and monitor.name == "HDMI-A-1" then
            hl.monitor({ output = "eDP-1", disabled = true })
        end
    end)

    -- Re-enable laptop screen when external monitor is disconnected
    hl.on("monitor.removed", function(monitor)
        if monitor and monitor.name == "HDMI-A-1" then
            hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 2.0 })
        end
    end)
elseif host.is_desktop then
    hl.monitor({ output = "HDMI-A-2", mode = "preferred", position = "0x0", scale = "auto" })
end

-- Fallback for any other monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Bigger gaps on external monitors
hl.workspace_rule({ workspace = "m[HDMI-A-1]", gaps_out = 12 })
