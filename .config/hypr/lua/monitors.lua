-- Monitor configuration

local host = require("lua.host")

if host.is_laptop then
    -- Docked: external only, internal panel off. Undocked: panel only.
    --
    -- apple-dcp on kernel 7.1.13 sometimes wedges on hotplug and refuses to
    -- turn Hyprland's modeset commit into an actual mode:
    --   cb_hotplug() connected:1, valid_mode:0
    --   swap_submit_dcp: swallowed swap ... fControllerPowerState is 0
    --   swap_submit_dcp: swallowed swap ... timings are not enabled
    -- Hyprland's own log still shows "drm: Modesetting HDMI-A-1 with
    -- 4096x2160@60.00Hz", so the failure is below the compositor.
    --
    -- Mirroring instead of disabling eDP-1 was tried as a workaround on the
    -- theory that releasing the internal CRTC caused it. It does not hold up:
    -- on 2026-09-09 it wedged while mirrored and never disabled, and on a
    -- different controller (289c00000.dcp, not 38bc00000.dcp), so it is not
    -- tied to one DCP instance either.
    --
    -- Logging out and back in clears it - the driver recovers once DRM master
    -- is released - so a wedge costs a relog, not a reboot. Kernel 7.1.6
    -- (still installed) predates the regression if this gets tiring.
    --
    -- mode = preferred -> 4096x2160@60 (timingID 92), the timing this TV
    -- accepts. Do not pin 3840x2160 (timingID 84), it fails.
    -- scale 1.066667 -> 3840 logical width.
    local function pull_workspaces(output)
        -- Hyprland 0.56.2 segfaults in CMonitor::changeWorkspace when a
        -- workspace dispatcher targets a workspace whose monitor is gone
        -- (crash report 1707, 2026-09-09: undocked, then SUPER+<n>).
        for i = 1, 10 do
            hl.dispatch(hl.dsp.workspace.move({ workspace = i, monitor = output }))
        end
    end

    local function set_docked(docked)
        if docked then
            hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1.066667 })
            hl.monitor({ output = "eDP-1", disabled = true })
            pull_workspaces("HDMI-A-1")
        else
            hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 2.0, mirror = "none" })
            pull_workspaces("eDP-1")
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
