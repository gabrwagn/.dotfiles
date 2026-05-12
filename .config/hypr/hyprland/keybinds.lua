-- Keybindings

local mainMod = "SUPER"
local host    = require("hyprland.host")

local browser  = host.is_laptop and "helium" or "firefox"

-- Terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm app -- alacritty"))

-- Browser
hl.bind(mainMod .. " + b", hl.dsp.exec_cmd("uwsm app -- " .. browser))

-- Application launcher
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("uwsm app -- rofi -show drun -theme $HOME/.config/rofi/paradise.rasi -run-command 'zsh -ic \"{cmd}\"'"))

-- Window management
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("~/.config/hypr/scripts/restart.sh"))
hl.bind(mainMod .. " + B", hl.dsp.layout("splitratio exact 0.5"))

-- Lock screen
hl.bind("ALT + l", hl.dsp.exec_cmd("uwsm app -- /home/gabwag/.local/bin/hyprlock-blur"))

-- Notification panel
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"))

-- Multimedia keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh up"),   { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh down"),  { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh mute"),  { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"))

-- Brightness controls
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

-- Move windows
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + h",     hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l",     hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k",     hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j",     hl.dsp.window.move({ direction = "down" }))

-- Mouse binds (draggable windows with SUPER + mouse)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Enter locked submap (SUPER+SHIFT+L)
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.submap("locked"))

-- Resize submap
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("right",  hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }), { repeating = true })
    hl.bind("left",   hl.dsp.window.resize({ x = -10, y = 0,   relative = true }), { repeating = true })
    hl.bind("up",     hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })
    hl.bind("down",   hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)

-- System menu with rofi
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("uwsm app -- rofi -show power-menu -theme ~/.config/rofi/paradise.rasi -modi power-menu:~/.config/rofi/rofi-power-menu"))

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

