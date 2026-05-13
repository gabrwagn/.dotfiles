-- Window and layer rules

local theme = require("lua.theme")

-- Ignore maximize requests from apps
hl.window_rule({
    match            = { class = ".*" },
    suppress_event   = "maximize",
})

-- Change border color for fullscreen windows
hl.window_rule({
    match        = { fullscreen = 1 },
    border_color = { colors = theme.fullscreen_border_colors },
    border_size  = theme.fullscreen_border_size,
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    match    = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- Layer rules
hl.layer_rule({
    match = { namespace = "rofi" },
    blur  = true,
})
hl.layer_rule({
    match = { namespace = "waybar" },
    blur  = true,
})
hl.layer_rule({
    match        = { namespace = "swaync-control-center" },
    blur         = true,
    ignore_alpha = 0.1,
})
hl.layer_rule({
    match        = { namespace = "swaync-notification-window" },
    blur         = true,
    ignore_alpha = 0.1,
})

---------------------------------
---- APPLICATION-SPECIFIC -------
---------------------------------

-- Firefox
hl.window_rule({
    match   = { class = "^(org.mozilla.firefox)$" },
    opacity = 1.0,
})
hl.window_rule({
    match        = { class = "^(org.mozilla.firefox)$", title = ".*Twitch.*" },
    opacity      = 1.0,
    idle_inhibit = "focus",
})
hl.window_rule({
    match        = { class = "^(org.mozilla.firefox)$", title = ".*[Yy]ou[Tt]ube.*" },
    opacity      = 1.0,
    idle_inhibit = "focus",
})
hl.window_rule({
    match        = { class = "^(org.mozilla.firefox)$", title = ".*[Zz]oom.*" },
    opacity      = 1.0,
    idle_inhibit = "always",
})

-- Project Epoch (WoW 3.3.5 - XWayland)
-- 'immediate' bypasses compositor rendering - fixes black screen after Mesa upgrades
hl.window_rule({
    match        = { initial_class = "^(steam_app_default)$", initial_title = "^(World of Warcraft)$" },
    immediate    = true,
    fullscreen   = 1,
    idle_inhibit = "always",
})

-- Zathura PDF viewer
hl.window_rule({
    match   = { class = "^(org.pwmt.zathura)$" },
    opacity = theme.zathura_opacity,
})

-- SafeEyes
hl.window_rule({
    match          = { class = "^(safeeyes)$" },
    float          = true,
    suppress_event = "fullscreen",
})

-- Picture-in-Picture
hl.window_rule({
    match            = { title = "(Picture-in-Picture)" },
    float            = true,
    size             = "585 330",
    move             = "100%-816 50",
    pin              = true,
    no_dim           = true,
    opacity          = 1,
    no_initial_focus = true,
})
