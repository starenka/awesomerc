local M = { settings = { color = '#dcdccc', battery = 'BAT0', warning = { color = '#fecf35', level = 31 }, critical = { color = 'red', level = 16 } } }
-- you can override settings in rc.lua

function M.get_info()
  spacer = ""
  local fcur = io.open("/sys/class/power_supply/" .. M.settings.battery .. "/energy_now")
  local fcap = io.open("/sys/class/power_supply/" .. M.settings.battery .. "/energy_full")
  local fsta = io.open("/sys/class/power_supply/" .. M.settings.battery .. "/status")
  local cur = fcur:read()
  local cap = fcap:read()
  local sta = fsta:read()
  local battery = math.floor(cur * 100 / cap)
  local color = M.settings.color
  --local blink = 0
  if sta:match("Charging") then
    dir = "+"
  elseif sta:match("Discharging") then
    dir = "-"
    if tonumber(battery) < M.settings.warning.level then
      color = M.settings.warning.color
    end
    if tonumber(battery) < M.settings.critical.level then
      --blink = 1
      color = M.settings.critical.color
    end
    battery = battery
  else
    dir = ""
    battery = "100"
  end
  text = spacer .. dir .. battery .. "%" .. spacer
  fcur:close()
  fcap:close()
  fsta:close()
  return '<span color="' .. color .. '">' .. text .. '</span>'
end

return M
