-- https://raw.githubusercontent.com/esn89/volumetextwidget/master/textvolume.lua

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")

function update_volume(widget)
   local fd = io.popen("amixer sget Master")
   local status = fd:read("*all")
   fd:close()

   local volume = string.match(status, "(%d?%d?%d)%%")
   volume = string.format("% 3d", volume)

   status = string.match(status, "%[(o[^%]]*)%]")

   if string.find(status, "on", 1, true) then
   -- For the volume number percentage
       volume = volume .. "%"
   else
   -- For displaying the mute status.
       volume = volume .. "M"

   end
   widget:set_markup(' <span font-size="small">VOL ' .. volume .. '</span> ')
end

update_volume(volume_widget)

mytimer = gears.timer({ timeout = 0.2 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()
