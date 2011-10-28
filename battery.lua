local M = {}

function M.get_info(battery_id)
  spacer = ""
  local fcur = io.open("/sys/class/power_supply/" .. battery_id .. "/energy_now")
  local fcap = io.open("/sys/class/power_supply/" .. battery_id .. "/energy_full")
  local fsta = io.open("/sys/class/power_supply/" .. battery_id .. "/status")
  local cur = fcur:read()
  local cap = fcap:read()
  local sta = fsta:read()
  local battery = math.floor(cur * 100 / cap)
  local blink = 0
  local color = '#DCDCCC'
  if sta:match("Charging") then
    dir = "+"
  elseif sta:match("Discharging") then
    dir = "-"
    if tonumber(battery) < 31 then
      color = '#fecf35'
    end
    if tonumber(battery) < 16 then
      blink = 1
      color = 'red'
    end
    battery = battery
  else
    dir = ""
    battery = "100"
  end
  text = spacer .. dir .. battery .. "%" .. spacer
  --batterywidget.text = '<span color="'..color..'">'..text..'</span>'
  --if blink == 1 then
  --blinking(batterywidget, 1.2, #text)
  --end
  fcur:close()
  fcap:close()
  fsta:close()
  return '<span color="' .. color .. '">' .. text .. '</span>'
end

return M