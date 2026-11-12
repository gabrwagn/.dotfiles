-- Host detection

local f = io.popen("hostname")
local hostname = f:read("*l")
f:close()

local host = {
    name       = hostname,
    is_laptop  = hostname == "nausicaa",
    is_desktop = hostname == "mononoke",
}
host.terminal = host.is_laptop and "kitty" or "alacritty"

return host
