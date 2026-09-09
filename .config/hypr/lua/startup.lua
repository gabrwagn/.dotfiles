-- Autostart applications (runs once on startup)

local host = require("lua.host")

hl.on("hyprland.start", function()
    -- noctalia replaces waybar, swaync, hyprpaper and rofi
    hl.exec_cmd("uwsm app -- noctalia")
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
