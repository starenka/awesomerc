local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")

function update_volume(widget)
   awful.spawn.easy_async(string.format("%s/bin/volume level", os.getenv("HOME")),
      function(stdout)
         widget:set_markup(' <span font-size="small">VOL ' .. stdout .. '</span> ')
      end)
end

update_volume(volume_widget)

mytimer = gears.timer({ timeout = 2 })
mytimer:connect_signal("timeout", function() update_volume(volume_widget) end)
mytimer:start()
