-- Show a headphones glyph while a Bluetooth audio sink exists, and nothing
-- otherwise. Noctalia's own volume widget varies its icon by level, not by
-- device type, so this sits next to it.
--
-- Presence is checked rather than the default sink: audio is routed through
-- an effects chain here (audio_effect.j314-convolver), so the default sink
-- name does not mention bluez even while the headset is playing. A
-- bluez_output sink only exists while a device is connected.

local hasBluetooth = false

local function render()
    if hasBluetooth then
        barWidget.setGlyph("headphones")
        barWidget.setVisible(true)
    else
        barWidget.setVisible(false)
    end
end

local function refresh()
    noctalia.runAsync({ "pactl", "list", "short", "sinks" }, function(result)
        -- The callback receives a table, not a string.
        local out = (result ~= nil and result.stdout) or ""
        hasBluetooth = out:find("bluez_output", 1, true) ~= nil
        render()
    end)
end

refresh()

-- pactl emits an event whenever the default sink or any sink changes.
noctalia.runStream("pactl subscribe", function(line)
    if line:find("sink", 1, true) ~= nil or line:find("server", 1, true) ~= nil then
        refresh()
    end
end)

-- Safety net only: `pactl subscribe` above catches every change. At the
-- default tick this spawned pactl four times a second and kept PipeWire busy.
function update()
    noctalia.setUpdateInterval(60000)
    refresh()
end

function onClick()
    noctalia.runAsync({ "noctalia", "msg", "panel-toggle", "control-center", "audio" })
end
