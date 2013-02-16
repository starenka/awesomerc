local M = { settings = { method = 'generic', 
			 color = '#dcdccc', 
			 battery = 'BAT0', 
			 warning = { color = '#fecf35', level = 31 }, 
			 critical = { color = 'red', level = 16 } } 
}
-- you can override settings in rc.lua

function M.get_generic(battery)
   local cur = io.open('/sys/class/power_supply/' .. battery .. '/energy_now'):read()
   local cap = io.open('/sys/class/power_supply/' .. battery .. '/energy_full'):read()
   local sta = io.open('/sys/class/power_supply/' .. battery .. '/status'):read()
   local ac = io.open('/sys/class/power_supply/AC/online'):read()

   remaining = math.floor(cur * 100 / cap)
   ac = ac:match('1')

   state = 2
   if sta:match('Discharging') then state = 0
   elseif sta:match('Charging') then state = 1 
   end

   return { rem_perc=tonumber(remaining), rem_time=nil, rem_chtime=nil, state=state, ac=ac }
end

function M.get_smapi(battery)
   local rem_perc = io.open('/sys/devices/platform/smapi/'.. battery .. '/remaining_percent'):read()
   local rem_time = io.open('/sys/devices/platform/smapi/' .. battery .. '/remaining_running_time'):read()
   local rem_chtime = io.open('/sys/devices/platform/smapi/' .. battery .. '/remaining_charging_time'):read()
   local sta = io.open('/sys/devices/platform/smapi/' .. battery .. '/state'):read()
   local ac = io.open('/sys/devices/platform/smapi/ac_connected'):read()

   ac = ac:match('1')

   state = 2
   if sta:match('discharging') then state = 0
   elseif sta:match('charging') then state = 1 
   end
   
   return { rem_perc=tonumber(rem_perc), rem_time=tonumber(rem_time), rem_chtime=tonumber(rem_chtime), state=state, ac=ac }
end
   
function M.get_info()
   local spacer = ''
   local dir = ''
   local color = M.settings.color

   local stats = M['get_' .. M.settings.method](M.settings.battery)

   if stats.state == 0 then
      dir = '-'
      if stats.rem_perc < M.settings.warning.level then
	 color = M.settings.warning.color
      elseif stats.rem_perc < M.settings.critical.level then
	 color = M.settings.critical.color
      end      
   elseif stats.state == 1 then dir = '+'
   end

   text = spacer ..  (stats.ac and '' or '@ ') .. dir .. stats.rem_perc .. "%" .. spacer
   return '<span color="' .. color .. '">' .. text .. '</span>'
end

return M
