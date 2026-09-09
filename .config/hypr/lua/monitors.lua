-- Monitor configuration

local host = require("lua.host")

if host.is_laptop then
    -- apple-dcp, kernel >= 7.1.13: NEVER set `disabled = true` on eDP-1.
    --
    -- Evidence (journalctl -k, boot of 2026-09-09 09:48):
    --   09:49:30  plug #1 -> set_digital_out_mode "4096x2160" timing 92. Works.
    --   09:49:36  eDP disabled -> 38bc00000.dcp logs unplug_gated +
    --             "IOAVVideoInterface open failed" x4
    --   09:49:50  plug #2 -> cb_hotplug connected:1, then only
    --             "swallowed swap ... fControllerPowerState is 0".
    --             set_digital_out_mode never reaches the kernel again.
    --   09:50:01  plug #3 -> identical. Wedged until reboot.
    --
    -- Hyprland does issue the commit ("drm: Modesetting HDMI-A-1 with
    -- 4096x2160@60.00Hz" in its log); apple-dcp fails to turn it into a
    -- modeset once the internal panel's CRTC has been torn down. On kernel
    -- 7.1.6 (2026-08-21 logs) the same sequence worked fine, so this is a
    -- driver regression, not a config error.
    --
    -- Mirroring keeps eDP-1 enabled, so the internal CRTC is never released.
    --
    -- mode = preferred -> 4096x2160@60 (timingID 92), the timing this TV
    -- accepts. Do not pin 3840x2160 (timingID 84), it fails.
    -- scale 1.066667 -> 3840 logical width.
    local function set_docked(docked)
        if docked then
            hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1.066667 })
            hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 2.0, mirror = "HDMI-A-1" })
        else
            hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 2.0, mirror = "none" })
        end
    end

    set_docked(hl.get_monitor("HDMI-A-1") ~= nil)

    if not _G.__laptop_mon_registered then
        _G.__laptop_mon_registered = true
        hl.on("monitor.added", function(m)
            if m and m.name == "HDMI-A-1" then set_docked(true) end
        end)
        hl.on("monitor.removed", function(m)
            if m and m.name == "HDMI-A-1" then set_docked(false) end
        end)
    end

elseif host.is_desktop then
    hl.monitor({ output = "HDMI-A-2", mode = "4096x2160@120", position = "0x0", scale = "auto" })
end

-- Fallback for any other monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
