-- Theme configuration
-- Swap the palette require to change color scheme

local colors = require("lua.palette.paradise")
local host   = require("lua.host")

local theme = {}

-- Border colors
theme.active_border   = colors.red
theme.inactive_border = colors.bg3

-- Fullscreen border gradient
theme.fullscreen_border_colors = { colors.yellow, colors.yellow }
theme.fullscreen_border_size   = 3

-- Shadow
theme.shadow_color = colors.shadow

-- Gaps and borders
theme.gaps_in     = 2
theme.gaps_out    = host.is_laptop and 4 or 12
theme.border_size = 2
theme.rounding    = 0

-- Opacity
theme.active_opacity   = 1.0
theme.inactive_opacity = 0.99
theme.zathura_opacity  = 0.85

return theme
