local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local cjson = require("cjson")

local M = {
   settings = {
      cmd = "weather", -- from ~/prac/letools, symlinked into ~/bin (assumed on PATH)
      interval = 300, -- 5 min; per-provider rate limits are enforced by the weather script itself
      providers = { "open-meteo", "meteosource", "aladin" }, -- right-click cycle order
   },
}
-- you can override settings in rc.lua, e.g. weather.settings.interval = 600

local tooltip_text = "…"

-- lua-cjson decodes JSON null as the cjson.null userdata sentinel, not Lua
-- nil, so truthy-checks like `if not prob` don't catch it. Scrub it out
-- recursively right after decoding instead of special-casing every read site.
local function strip_null(t)
   if type(t) ~= "table" then return t end
   for k, v in pairs(t) do
      if v == cjson.null then
         t[k] = nil
      elseif type(v) == "table" then
         strip_null(v)
      end
   end
   return t
end

local function rain_color(prob)
   if not prob then return beautiful.fg_normal end
   if prob >= 60 then return beautiful.widget_critical or beautiful.fg_normal end
   if prob >= 30 then return beautiful.widget_warning or beautiful.fg_normal end
   return beautiful.fg_normal
end

-- Probability isn't shown as a number in the compact widget; it's folded into
-- the mm figure's color instead (dim = unlikely, warning/critical = likely).
local function make_text(data)
   local c = data.current
   local temp = c.temp_c and string.format("%.0f°", c.temp_c) or "?"
   local rain = string.format('<span color="%s">%.1fmm</span>', rain_color(c.precip_prob_pct), c.precip_mm or 0)
   local stale_mark = data.stale and string.format(' <span color="%s">~</span>', beautiful.widget_warning or beautiful.fg_normal) or ""
   return string.format(' <span font-size="small">%s %s%s</span> ', temp, rain, stale_mark)
end

local function make_tooltip_text(data)
   local lines = {}
   if data.stale then
      table.insert(lines, string.format("STALE — network unreachable, showing data from %s", data.stale_since))
      table.insert(lines, "")
   end
   table.insert(lines, data.place)
   table.insert(lines, string.format("updated %s, %s", data.updated_at, data.provider))
   table.insert(lines, "")
   for _, h in ipairs(data.hourly or {}) do
      local prob = h.precip_prob_pct and string.format("%3d%%", h.precip_prob_pct) or "  - "
      local line = string.format("%s  %4.0f°C  %4.1fmm  %s", h.time, h.temp_c, h.precip_mm or 0, prob)
      table.insert(lines, string.format('<span color="%s">%s</span>', rain_color(h.precip_prob_pct), line))
   end
   return table.concat(lines, "\n")
end

local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

function M.new()
   local widget = wibox.widget.textbox()
   widget:set_markup(' <span font-size="small">…</span> ')

   local tooltip = awful.tooltip({
      objects = { widget },
      align = "right",
      font = "monospace 8",
      timer_function = function() return tooltip_text end,
   })
   tooltip:set_mode("outside") -- anchor to the widget instead of following the cursor

   local busy = false
   local last_fetch_time = 0
   local spinner_idx = 0
   local spinner_timer = gears.timer({ timeout = 0.1 })
   spinner_timer:connect_signal("timeout", function()
      spinner_idx = (spinner_idx % #spinner_frames) + 1
      widget:set_markup(string.format(' <span font-size="small">%s</span> ', spinner_frames[spinner_idx]))
   end)

   local function refresh(force)
      if busy then return end
      busy = true
      spinner_timer:start()
      local cmd = force and (M.settings.cmd .. " --force") or M.settings.cmd
      awful.spawn.easy_async(cmd, function(stdout, _, _, code)
         spinner_timer:stop()
         busy = false
         last_fetch_time = os.time()
         if code ~= 0 or stdout == "" then
            widget:set_markup(' <span font-size="small">err</span> ')
            tooltip_text = "weather fetch failed (exit " .. tostring(code) .. ")"
            return
         end
         local ok, data = pcall(cjson.decode, stdout)
         if not ok then
            widget:set_markup(' <span font-size="small">err</span> ')
            tooltip_text = "weather: invalid response"
            return
         end
         data = strip_null(data)
         local render_ok, text, ttip = pcall(function()
            return make_text(data), make_tooltip_text(data)
         end)
         if not render_ok then
            widget:set_markup(' <span font-size="small">err</span> ')
            tooltip_text = "weather: render error: " .. tostring(text)
            return
         end
         widget:set_markup(text)
         tooltip_text = ttip
      end)
   end

   local function cycle_provider()
      if busy then return end
      awful.spawn.easy_async(M.settings.cmd .. " provider", function(current_out)
         local current = current_out:gsub("%s+$", "")
         local idx = 0
         for i, p in ipairs(M.settings.providers) do
            if p == current then idx = i end
         end
         local next_provider = M.settings.providers[(idx % #M.settings.providers) + 1]
         awful.spawn.easy_async(M.settings.cmd .. " provider " .. next_provider, function()
            refresh(true)
         end)
      end)
   end

   widget:buttons(gears.table.join(
      awful.button({}, 1, function() refresh(true) end), -- left click: force a real refresh
      awful.button({}, 3, cycle_provider) -- right click: cycle to the next provider
   ))

   -- Catch up if the periodic timer's tick was missed (e.g. the machine was
   -- suspended through it) instead of silently showing stale data until the
   -- next tick happens to land - but only once we're actually overdue, so
   -- hovering repeatedly doesn't spam extra fetches against provider rate limits.
   widget:connect_signal("mouse::enter", function()
      if os.time() - last_fetch_time >= M.settings.interval then
         refresh()
      end
   end)

   local timer = gears.timer({ timeout = M.settings.interval })
   timer:connect_signal("timeout", function() refresh() end)
   timer:start()
   refresh()

   return widget
end

return M
