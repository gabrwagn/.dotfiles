-- Monitor configuration

local host = require("lua.host")

if host.is_laptop then
    -- TV. supports_hdr = -1: apple-dcp can't signal HDR to the TV (no
    -- HDR_OUTPUT_METADATA prop), so auto-HDR would only wash colors out.
    hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1.066667, supports_hdr = -1 })

    local function edp(mode)
        hl.monitor({ output = "eDP-1", disabled = false, mode = mode, position = "0x0", scale = 1.5 })
    end

    -- Docked: TV only. Undocked: panel only.
    -- force re-runs the panel wake-up even if eDP-1 already looks enabled
    -- (session start, recovery bind).
    local function apply(force)
        if hl.get_monitor("HDMI-A-1") then
            hl.monitor({ output = "eDP-1", disabled = true })
            return
        end
        if hl.get_monitor("eDP-1") and not force then
            -- Already on: restate the identical rule so a reload matches the
            -- live state and skips the modeset.
            edp("preferred")
            return
        end
        -- DCP firmware rejects the first modeset after panel power-on
        -- (set_digital_out_mode returned 8000000a) and doesn't retry, leaving
        -- the panel black. Wake it at 60Hz, then switch to preferred (120Hz):
        -- a different mode, so Hyprland re-issues the modeset to the awake panel.
        edp("3024x1890@60")
        hl.timer(function()
            if not hl.get_monitor("HDMI-A-1") then edp("preferred") end
        end, { timeout = 1500, type = "oneshot" })
    end

    -- Debounce: a TV switching inputs flaps HPD several times in a few
    -- seconds. Every output add/remove risks Hyprland's wl_output registry
    -- race (hyprwm/Hyprland#12996), which kills clients, the lock included.
    local gen = 0
    local function schedule(m)
        if not (m and m.name == "HDMI-A-1") then return end
        gen = gen + 1
        local mine = gen
        hl.timer(function()
            if mine == gen then apply() end
        end, { timeout = 2000, type = "oneshot" })
    end
    hl.on("monitor.added", schedule)
    hl.on("monitor.removed", schedule)

    -- The Lua state (and _G) is rebuilt on every reload, so a per-instance
    -- marker file tells session start (force the panel wake-up) from reload.
    local marker = os.getenv("XDG_RUNTIME_DIR") .. "/hypr/"
        .. os.getenv("HYPRLAND_INSTANCE_SIGNATURE") .. "/monitors-loaded"
    local f = io.open(marker, "r")
    if f then
        f:close()
        apply(false)
    else
        apply(true)
        f = io.open(marker, "w")
        if f then f:close() end
    end

    _G.__monitors_apply = apply

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
