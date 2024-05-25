-- https://raw.githubusercontent.com/esn89/volumetextwidget/master/textvolume.lua

local wibox = require("wibox")
local gears = require("gears")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")

HOME = os.getenv("HOME")
function update_volume(widget)
   local fd = io.popen(string.format("%s/bin/volume level", HOME))
   local status = fd:read("*all")
   fd:close()
   
   widget:set_markup(' <span font-size="small">VOL ' .. status .. '</span> ')
end

update_volume(volume_widget)

mytimer = gears.timer({ timeout = 0.2 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()
