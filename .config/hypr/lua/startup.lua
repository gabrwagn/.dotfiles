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

    -- Sunshine streams onto a headless output rather than HDMI-A-2, so the
    -- physical monitor is never reconfigured.
    --
    -- Creating an output is only reachable over IPC; there is no hl API for it.
    -- Its geometry and workspace pin are declared in monitors.lua, so this one
    -- line is the whole of it, and the config stays self-contained rather than
    -- depending on a script outside the repo.
    if host.is_desktop then
        hl.exec_cmd("hyprctl output create headless")
    end

    -- Open in specific workspaces
    if host.is_laptop then
        hl.exec_cmd("[workspace 3 silent] uwsm app -- firefox -P \"slack\"")
        hl.exec_cmd("[workspace 2 silent] uwsm app -- helium")
    else
        hl.exec_cmd("[workspace 2 silent] uwsm app -- firefox")
    end
    hl.exec_cmd("[workspace 1 silent] uwsm app -- " .. host.terminal)
end)
