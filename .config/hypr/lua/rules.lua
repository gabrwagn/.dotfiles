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

-- Bigger gaps on external monitors
hl.workspace_rule({ workspace = "m[HDMI-A-1]", gaps_out = 12 })

-- Layer rules
-- Blur behind noctalia's shell surfaces. Compositor blur stays off for regular
-- windows; this is the closest thing to the fullscreen dim rofi used to draw.
hl.layer_rule({
    match        = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$" },
    blur         = true,
    blur_popups  = true,
    ignore_alpha = 0.5,
    no_anim      = true,
})

---------------------------------
---- APPLICATION-SPECIFIC -------
---------------------------------

-- Noctalia settings window
hl.window_rule({
    match  = { class = "^(dev.noctalia.Noctalia)$" },
    float  = true,
    size   = "1080 920",
    center = true,
})

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

-- Terminal file chooser
hl.window_rule({
    match = { class = "^(Alacritty)$", title = "^(termfilechooser)$" },
    float = true,
    size  = "800 600",
    center = true,
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
