local M = { settings = { method = 'acpi', 
			 color = '#dcdccc', 
			 battery = 'BAT0', 
			 warning = { color = '#fecf35', level = 25 }, 
			 critical = { color = '#ff8000', level = 10 } } 
}
-- you can override settings in rc.lua

local backends = {
   generic = function(battery)
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
   end,
   smapi = function(battery)
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
   end,
   acpi = function(battery)
      
      stats = {}
      for l in io.popen('acpi -b'):lines() do
         nr = tonumber(l:match('Battery (%d)'))

         if l:match('Charging') then state = 1
         elseif l:match('Discharging') then state = 0
         else state = 2
         end

         hours, mins = l:match(', (%d%d):(%d%d)')
         if hours then rem_mins = tonumber(hours)*60+tonumber(mins) else rem_mins = 0 end
         if state == 1 then rem_chmins = rem_mins else rem_chmins = 0 end

         stats[nr]= { nr=nr, rem_perc=tonumber(l:match('(%d+)%%')),
                      rem_time=rem_mins, rem_chtime=rem_chmins, state=state}
      end
         
      ac_stats = io.popen('acpi -a'):read()
      if ac_stats:match('off-line') then ac = false else ac = true end

      to_show = nil
      for k,v in pairs(stats) do
         if v['rem_time'] or v['rem_chtime'] then to_show = v end
      end
      
      return { rem_perc=to_show['rem_perc'], rem_time=to_show['rem_time'], nr=nr,
               rem_chtime=to_show['rem_chtime'], state=to_show['state'], ac=ac }
   end
}   

   
function M.get_info()
   local spacer = ' '
   local dir = ''
   local color = M.settings.color

   function mins_to_hm_str(mins)
      return math.floor(mins/60) .. ':' .. string.format('%02d', mins%60)
   end

   local stats = backends[M.settings.method](M.settings.battery)

   if stats.state == 0 then
      dir = '-'
      if stats.rem_perc <= M.settings.critical.level then
	 color = M.settings.critical.color
      elseif stats.rem_perc <= M.settings.warning.level then
	 color = M.settings.warning.color
      end      
      rtime = stats.rem_time
   elseif stats.state == 1 then 
      dir = '+'
      rtime = stats.rem_chtime
   end
   
   time = rtime and (' ' .. mins_to_hm_str(rtime)) or ''
   --text = (stats.ac and '' or '@ ') .. dir .. stats.rem_perc .. "%"
   text = dir .. stats.rem_perc .. "%"
   return stats.rem_perc <= M.settings.critical.level and stats.state == 0, 
          spacer .. '<span>' .. string.rep(' ', string.len(text)) .. '<span font-size="small">' .. string.rep(' ', string.len(time)) .. '</span></span>' .. spacer,
          spacer .. '<span color="' .. color .. '">' .. text .. '<span font-size="small">' .. time .. '</span></span>' .. spacer

end

return M
