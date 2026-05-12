-- Hyprland Lua Configuration
-- Main config: sources other files via require()

local theme = require("hyprland.theme")
local host  = require("hyprland.host")

require("hyprland.monitors")
require("hyprland.vars")
require("hyprland.startup")
require("hyprland.keybinds")
require("hyprland.rules")


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "se,us",
        kb_variant = "nodeadkeys",
        kb_options = "grp:ctrl_space_toggle",
        follow_mouse = 2,

        touchpad = {
            natural_scroll       = true,
            clickfinger_behavior = 1,
        },
    },

    cursor = {
        no_warps          = true,
        hide_on_key_press = true,
    },
})


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in           = theme.gaps_in,
        gaps_out          = theme.gaps_out,
        border_size       = theme.border_size,
        no_focus_fallback = true,
        col = {
            active_border   = theme.active_border,
            inactive_border = theme.inactive_border,
        },
        allow_tearing = false,
        layout        = "dwindle",
    },

    decoration = {
        rounding = theme.rounding,

        -- Change transparency of focused and unfocused windows
        active_opacity   = theme.active_opacity,
        inactive_opacity = theme.inactive_opacity,

        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = theme.shadow_color,
        },

        blur = {
            enabled  = false,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },
})


--------------------
---- ANIMATIONS ----
--------------------

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 }   } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 }   } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 }       } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1.0 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 }    } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })


-----------------
---- LAYOUTS ----
-----------------

hl.config({
    master = {
        mfact = 1.0,
        -- new_status = "master",
    },

    dwindle = {
        preserve_split = true,
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms  = true,
        key_press_enables_dpms   = true,
    },
})
