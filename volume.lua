local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local M = {}

M.widget = wibox.widget.textbox()
M.widget:set_align("right")

function M.update()
   awful.spawn.easy_async("volume level", -- from ~/prac/letools, symlinked into ~/bin (assumed on PATH)
      function(stdout)
         M.widget:set_markup(' <span font-size="small">VOL ' .. stdout .. '</span> ')
      end)
end

M.update()

local timer = gears.timer({ timeout = 2 })
timer:connect_signal("timeout", M.update)
timer:start()

return M
