-- Autostart applications (runs once on startup)

local host = require("hyprland.host")

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- swaync")
    hl.exec_cmd("uwsm app -- waybar")
    hl.exec_cmd("uwsm app -- gnome-keyring-daemon --start --components=pkcs11,secrets,ssh")
    hl.exec_cmd("uwsm app -- hypridle")

    if host.is_desktop then
        hl.exec_cmd("uwsm app -- clipse -listen")
    end

    -- Open in specific workspaces
    if host.is_laptop then
        hl.exec_cmd("[workspace 3 silent] uwsm app -- firefox -P \"slack\"")
        hl.exec_cmd("[workspace 2 silent] uwsm app -- helium")
    else
        hl.exec_cmd("[workspace 2 silent] uwsm app -- firefox")
    end
    hl.exec_cmd("[workspace 1 silent] uwsm app -- alacritty")
end)
