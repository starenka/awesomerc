local awful = require("awful")
local beautiful = require("beautiful")
local blinker = require("blinker")

local M = { settings = { method = 'acpi',
             battery = 'BAT0',
             warning = { level = 25 },
             critical = { level = 10 } }
}
-- you can override settings in rc.lua

local function mins_to_hm_str(mins)
   return math.floor(mins/60) .. ':' .. string.format('%02d', mins%60)
end

local function make_text(stats, settings)
   local spacer = ' '
   local color = beautiful.fg_normal
   local dir, rtime = '', nil

   if stats.state == 0 then
      dir, rtime = '-', stats.rem_time
      if stats.rem_perc <= settings.critical.level then
         color = beautiful.widget_critical
      elseif stats.rem_perc <= settings.warning.level then
         color = beautiful.widget_warning
      end
   elseif stats.state == 1 then
      dir, rtime = '+', stats.rem_chtime
   end

   local time = rtime and (' ' .. mins_to_hm_str(rtime)) or ''
   local text = dir .. stats.rem_perc .. "%"
   local is_critical = stats.rem_perc <= settings.critical.level and stats.state == 0
   local blank = spacer .. '<span>' .. string.rep(' ', #text) ..
                 '<span font-size="small">' .. string.rep(' ', #time) .. '</span></span>' .. spacer
   local markup = spacer .. '<span color="' .. color .. '">' .. text ..
                  '<span font-size="small">' .. time .. ' (b' .. stats.nr .. ')</span></span>'
   return is_critical, blank, markup
end

local backends = {
   generic = function(battery, callback)
      local cur = io.open('/sys/class/power_supply/' .. battery .. '/energy_now')
      local cap = io.open('/sys/class/power_supply/' .. battery .. '/energy_full')
      local sta = io.open('/sys/class/power_supply/' .. battery .. '/status')
      local acf = io.open('/sys/class/power_supply/AC/online')
      if not (cur and cap and sta and acf) then
         callback({ rem_perc=0, rem_time=0, rem_chtime=0, state=2, ac=false, nr=0 })
         return
      end
      local cur_v = cur:read(); cur:close()
      local cap_v = cap:read(); cap:close()
      local sta_v = sta:read(); sta:close()
      local ac_v  = acf:read(); acf:close()

      local remaining = math.floor(tonumber(cur_v) * 100 / tonumber(cap_v))
      local state = 2
      if sta_v:match('Discharging') then state = 0
      elseif sta_v:match('Charging') then state = 1
      end
      callback({ rem_perc=remaining, rem_time=nil, rem_chtime=nil,
                 state=state, ac=ac_v:match('1') ~= nil, nr=0 })
   end,

   acpi = function(_, callback)
      awful.spawn.easy_async("acpi -b", function(bat_out)
         awful.spawn.easy_async("acpi -a", function(ac_out)
            local stats, nrs = {}, {}
            for l in bat_out:gmatch("[^\n]+") do
               local nr = tonumber(l:match('Battery (%d)'))
               if nr then
                  table.insert(nrs, nr)
                  local state = 2
                  if l:match('Charging') then state = 1
                  elseif l:match('Discharging') then state = 0
                  end
                  local hours, mins = l:match(', (%d%d):(%d%d)')
                  local rem_mins = hours and (tonumber(hours)*60 + tonumber(mins)) or 0
                  stats[nr] = { nr=nr, rem_perc=tonumber(l:match('(%d+)%%')),
                                rem_time=rem_mins,
                                rem_chtime=state == 1 and rem_mins or 0,
                                state=state }
               end
            end
            if #nrs == 0 then
               callback({ rem_perc=0, rem_time=0, rem_chtime=0, state=2, ac=false, nr=0 })
               return
            end
            local to_show = stats[nrs[#nrs]]
            for _, v in pairs(stats) do
               if v.rem_time > 0 or v.rem_chtime > 0 then to_show = v end
            end
            to_show.ac = not ac_out:match('off')
            callback(to_show)
         end)
      end)
   end
}

function M.get_info(callback)
   backends[M.settings.method](M.settings.battery, function(stats)
      callback(make_text(stats, M.settings))
   end)
end

function M.update(widget)
   M.get_info(function(is_critical, blank_text, text)
      widget:set_markup(text)
      if is_critical then
         blinker.blinking(widget, 1, blank_text)
      else
         blinker.blinkers[widget] = nil
      end
   end)
end

return M
