-- Keybindings

local mainMod = "SUPER"
local host    = require("lua.host")
local ipc     = "noctalia msg "


-- Terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm app -- " .. host.terminal))

-- Browser

-- Application launcher
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))

-- Noctalia shell surfaces
hl.bind(mainMod .. " + S",         hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. " + C",         hl.dsp.exec_cmd(ipc .. "panel-toggle control-center calendar"))
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd(ipc .. "panel-toggle control-center network"))
hl.bind(mainMod .. " + B",         hl.dsp.exec_cmd(ipc .. "panel-toggle control-center bluetooth"))
hl.bind(mainMod .. " + comma",     hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"))
hl.bind("ALT + Tab",               hl.dsp.exec_cmd(ipc .. "window-switcher"))

-- Window management
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())

-- Lock screen
hl.bind("ALT + l", hl.dsp.exec_cmd(ipc .. "session lock"))

-- Blind recovery: re-run the dock/undock logic from monitors.lua for the
-- current HDMI state. Undocking has left the machine with no enabled output
-- before, which is otherwise only escapable by holding the power button.
hl.bind(mainMod .. " + SHIFT + R", function()
    if _G.__set_docked then
        local docked = hl.get_monitor("HDMI-A-1") ~= nil
        _G.__set_docked(docked)
        if not docked then
            hl.dispatch(hl.dsp.exec_cmd("brightnessctl -d apple-panel-bl set 50%"))
        end
    end
end)

-- Blind recovery: bounce to VT 3 and back to unwedge apple-dcp after an HDMI
-- hotplug or resume. Replaces logging out; see scripts/fix-display.
-- hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/fix-display"))

-- Notification history
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center notifications"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(ipc .. "notification-clear-active && " .. ipc .. "notification-clear-history"))

-- Screenshots (saved to ~/Pictures/Screenshots and copied to the clipboard)
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(ipc .. "screenshot-fullscreen"))
hl.bind(mainMod .. " + CTRL + P",  hl.dsp.exec_cmd(ipc .. "screenshot-region"))

-- Multimedia keys (noctalia handles the OSD)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"),   { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"), { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"))

-- Brightness controls (script changes the panel, noctalia draws the OSD)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh up"),   { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh down"), { repeating = true })

-- Focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "down" }))

-- Cycle windows
hl.bind(mainMod .. " + tab",         hl.dsp.window.cycle_next({ next = true }))
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.window.cycle_next({ next = false }))

-- Move windows (via layoutmsg for tree-aware moves on lua:i3, harmless no-op on dwindle)
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.layout("move left"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.layout("move right"))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.layout("move up"))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.layout("move down"))
hl.bind(mainMod .. " + SHIFT + h",     hl.dsp.layout("move left"))
hl.bind(mainMod .. " + SHIFT + l",     hl.dsp.layout("move right"))
hl.bind(mainMod .. " + SHIFT + k",     hl.dsp.layout("move up"))
hl.bind(mainMod .. " + SHIFT + j",     hl.dsp.layout("move down"))

-- Split direction control (i3 layout)
hl.bind(mainMod .. " + v", hl.dsp.layout("splitv"))
hl.bind(mainMod .. " + g", hl.dsp.layout("splith"))
hl.bind(mainMod .. " + t", hl.dsp.layout("splittoggle"))

-- Layout switching
hl.bind(mainMod .. " + SHIFT + d", function() hl.config({ general = { layout = "dwindle" } }) end)
hl.bind(mainMod .. " + SHIFT + i", function() hl.config({ general = { layout = "lua:i3" } }) end)

-- Mouse binds (draggable windows with SUPER + mouse)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Enter locked submap (SUPER+SHIFT+L)
-- hl.bind(mainMod .. " + SHIFT + L", hl.dsp.submap("locked"))

-- Resize submap
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("right",  hl.dsp.layout("resize right 0.05"), { repeating = true })
    hl.bind("left",   hl.dsp.layout("resize left 0.05"),  { repeating = true })
    hl.bind("up",     hl.dsp.layout("resize up 0.05"),    { repeating = true })
    hl.bind("down",   hl.dsp.layout("resize down 0.05"),  { repeating = true })
    hl.bind("l",      hl.dsp.layout("resize right 0.05"), { repeating = true })
    hl.bind("h",      hl.dsp.layout("resize left 0.05"),  { repeating = true })
    hl.bind("k",      hl.dsp.layout("resize up 0.05"),    { repeating = true })
    hl.bind("j",      hl.dsp.layout("resize down 0.05"),  { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)

-- Session menu
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(ipc .. "panel-toggle session"))
if host.is_laptop then
    hl.bind("XF86PowerOff", hl.dsp.exec_cmd(ipc .. "panel-toggle session"))
end

-- Fullscreen
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Toggle floating
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))

-- Scratchpad
hl.bind(mainMod .. " + CTRL + SHIFT + X", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + CTRL + X",         hl.dsp.workspace.toggle_special())

-- Workspaces 1-10 (keys 1-9, 0)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
