local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local M = {}

M.widget = wibox.widget.textbox()
M.widget:set_align("right")

function M.update()
   -- full path: awesome's own PATH (inherited from sddm) doesn't include
   -- ~/bin, so a bare "volume" would fail to spawn.
   awful.spawn.easy_async(string.format("%s/bin/volume level", os.getenv("HOME")),
      function(stdout)
         M.widget:set_markup(' <span font-size="small">VOL ' .. stdout .. '</span> ')
      end)
end

M.update()

local timer = gears.timer({ timeout = 2 })
timer:connect_signal("timeout", M.update)
timer:start()

return M
