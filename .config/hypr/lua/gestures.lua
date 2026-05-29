local host = require("lua.host")

if host.is_laptop then
  hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
  })
  hl.gesture({
    fingers = 2,
    direction = "pinch",
    action = "fullscreen",
    mode = "maximize"
  })
end
