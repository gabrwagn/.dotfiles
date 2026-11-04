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
        -- Only existing workspaces: moving a missing one logs a "Workspace
        -- not found" warning, and at config load none exist yet.
        for i = 1, 10 do
            if hl.get_workspace(i) then
                hl.dispatch(hl.dsp.workspace.move({ workspace = i, monitor = output }))
            end
        end
    end

    local function set_docked(docked)
        if docked then
            hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1.066667 })
            hl.monitor({ output = "eDP-1", disabled = true })
            pull_workspaces("HDMI-A-1")
        else
            -- `disabled = false` is mandatory: re-stating mode/position/scale
            -- does not clear the flag set above, and on 2026-09-10 that left
            -- the machine with no enabled output after an undock. The kernel
            -- logged no modeset attempt at all and it needed a power cycle.
            hl.monitor({
                output   = "eDP-1",
                disabled = false,
                mode     = "preferred",
                position = "0x0",
                scale    = 1.5,
                mirror   = "none",
            })
            hl.dispatch(hl.dsp.dpms({ action = "on", monitor = "eDP-1" }))
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

    -- Sunshine streaming target.
    --
    -- The output does not exist at config-parse time; startup.lua creates it
    -- with `hyprctl output create headless`, which is IPC-only — there is no
    -- hl API for creating outputs. This rule only pins its geometry, so a
    -- config reload mid-stream restores the idle mode instead of letting the
    -- catch-all rule below reposition it. Verified: a named rule survives the
    -- empty-output fallback even though the fallback is declared afterwards.
    --
    -- x=5120 clears HDMI-A-2 whichever scale "auto" resolves to, and the gap
    -- between the two is deliberate: non-adjacent outputs mean the pointer
    -- cannot wander onto the headless display during local use.
    --
    -- The mode is only an idle placeholder. ~/.config/sunshine/vdisplay-start.sh
    -- overwrites it with the connecting client's resolution when a stream
    -- begins.
    --
    -- The name is HEADLESS-1 as long as nothing else creates a headless output
    -- first. Hyprland increments the counter per `output create` and does not
    -- reuse freed names, so creating and removing one by hand yields
    -- HEADLESS-2 next. If that happens, restart the session rather than
    -- editing this rule; Sunshine's `output_name` is hardcoded to the same
    -- name.
    hl.monitor({ output = "HEADLESS-1", mode = "1920x1080@60", position = "5120x0", scale = 1 })

    -- Workspace the streamed session lives on. Never visited locally.
    -- Must match VD_WORKSPACE in ~/.config/sunshine/vdisplay-common.sh.
    hl.workspace_rule({ workspace = "name:stream", monitor = "HEADLESS-1", default = true })
end

-- Fallback for any other monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
