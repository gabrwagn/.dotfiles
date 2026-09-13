-- Autostart applications (runs once on startup)

local host = require("lua.host")

hl.on("hyprland.start", function()
    -- noctalia replaces waybar, swaync, hyprpaper and rofi; hypridle stays the
    -- idle manager so a shell crash cannot stop the session from locking
    hl.exec_cmd("uwsm app -- noctalia")
    hl.exec_cmd("uwsm app -- gnome-keyring-daemon --start --components=pkcs11,secrets,ssh")
    -- per-host idle rules: the jellyfin box (mononoke) must never sleep.
    local hidle_conf = host.is_laptop and "hypridle-nausicaa.conf" or "hypridle-mononoke.conf"
    hl.exec_cmd("uwsm app -- hypridle -c " .. os.getenv("HOME") .. "/.dotfiles/.config/hypr/" .. hidle_conf)

    -- Open in specific workspaces
    if host.is_laptop then
        hl.exec_cmd("[workspace 3 silent] uwsm app -- firefox -P \"slack\"")
        hl.exec_cmd("[workspace 2 silent] uwsm app -- helium")
    else
        hl.exec_cmd("[workspace 2 silent] uwsm app -- firefox")
    end
    hl.exec_cmd("[workspace 1 silent] uwsm app -- alacritty")
end)
