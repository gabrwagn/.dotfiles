-- Show a headphones glyph while the default PipeWire sink is a Bluetooth
-- device, and nothing otherwise. Noctalia's own volume widget varies its icon
-- by level, not by device type, so this sits next to it.

local isBluetooth = false

local function render()
    if isBluetooth then
        barWidget.setGlyph("headphones")
        barWidget.setVisible(true)
    else
        barWidget.setVisible(false)
    end
end

local function refresh()
    noctalia.runAsync({ "pactl", "get-default-sink" }, function(result)
        -- The callback receives a table, not a string.
        local out = (result ~= nil and result.stdout) or ""
        isBluetooth = out:lower():find("bluez", 1, true) ~= nil
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

function update()
    refresh()
end

function onClick()
    noctalia.runAsync({ "noctalia", "msg", "panel-toggle", "control-center", "audio" })
end
