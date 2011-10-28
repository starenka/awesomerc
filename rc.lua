-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/starenka/.config/awesome/themes/starenka/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "terminator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"
shiftkey = "Shift"

battery_poll_int = 7
battery_id = 'BAT0'

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
	names  = { 'terms', 	'dev', 		'dev:www', 	'[www]', 	'#', 		'd{-_-}b', 	'/tmp', },
	layout = { layouts[1], 	layouts[1], 	layouts[1], 	layouts[1], 	layouts[6], 	layouts[1], 	layouts[1],
}}
 
for s = 1, screen.count() do
	tags[s] = awful.tag(tags.names, s, tags.layout)
end


-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
  { "restart", awesome.restart },
  { "quit", awesome.quit }
}

mymainmenu = awful.menu({
  items = {
    { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "Debian", debian.menu.Debian_menu.Debian },
    { "open terminal", terminal }
  }
})

mylauncher = awful.widget.launcher({
  image = image(beautiful.awesome_icon),
  menu = mymainmenu
})
-- }}}

-- Keyboard layout switching
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { "us", "cz -variant qwerty", }
kbdcfg.current = 1 -- us is our default layout
kbdcfg.widget = widget({ type = "textbox", align = "right" })
kbdcfg.widget.text = " " .. kbdcfg.layout[kbdcfg.current] .. " "
kbdcfg.switch = function()
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  local t = " " .. kbdcfg.layout[kbdcfg.current] .. " "
  --local m = kbdcfg.layout[kbdcfg.current]:gmatch("%S+")
  kbdcfg.widget.text = t
  os.execute(kbdcfg.cmd .. t)
end
-- Mouse bindings
kbdcfg.widget:buttons(awful.util.table.join(awful.button({}, 1, function() kbdcfg.switch() end)))

-- Gmail widget
awful.widget.gmail = require('awful.widget.gmail')
gmailwidget = awful.widget.gmail.new()

-- battery
batterywidget = widget({type = "textbox", name = "batterywidget", align = "right" })
batterywidget.text = " ?? "


-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }," %b %d, %H:%M ")

-- Create a systray
mysystray = widget({ type = "systray" })

-- calendar
require('awful.widget.calendar2')
calendar2.addCalendarToWidget(mytextclock)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(awful.button({}, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev))
mytasklist = {}
mytasklist.buttons = awful.util.table.join(awful.button({}, 1, function(c)
  if c == client.focus then
    c.minimized = true
  else
    if not c:isvisible() then
      awful.tag.viewonly(c:tags()[1])
    end
    -- This will also un-minimize
    -- the client, if needed
    client.focus = c
    c:raise()
  end
end),
  awful.button({}, 3, function()
    if instance then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ width = 250 })
    end
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end))



-- Left padding
padding_left = widget({type = "textbox", name = "left-padding", align = "left"})
padding_left.text = " "
-- Right padding
padding_right = widget({type = "textbox", name = "right-padding", align = "right"})
padding_right.text = " "
--widget sep
widget_sep = widget({type = "textbox", name = "widget-sep", align = "right"})
widget_sep.text = "|"

for s = 1, screen.count() do
  -- Create a promptbox for each screen
  mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(awful.button({}, 1, function() awful.layout.inc(layouts, 1) end),
    awful.button({}, 3, function() awful.layout.inc(layouts, -1) end),
    awful.button({}, 4, function() awful.layout.inc(layouts, 1) end),
    awful.button({}, 5, function() awful.layout.inc(layouts, -1) end)))
  -- Create a taglist widget
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

  -- Create a tasklist widget
  mytasklist[s] = awful.widget.tasklist(function(c)
    return awful.widget.tasklist.label.currenttags(c, s)
  end, mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s })
  -- Add widgets to the wibox - order matters
  mywibox[s].widgets = {
    {
      mylauncher,
      padding_left,
      mypromptbox[s],
      mytaglist[s],
	  padding_right,
	  padding_right,
      layout = awful.widget.layout.horizontal.leftright
    },
    {
      mylayoutbox[s],
      mytextclock,
      widget_sep,
      kbdcfg.widget,
      widget_sep,
      batterywidget,
      widget_sep,
      padding_right,
      gmailwidget,
      layout = awful.widget.layout.horizontal.rightleft
    },
    s == 1 and mysystray or nil,
    mytasklist[s],
    layout = awful.widget.layout.horizontal.rightleft
  }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(awful.button({}, 3, function() mymainmenu:toggle() end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  awful.key({ modkey, }, "Left", awful.tag.viewprev),
  awful.key({ modkey, }, ",", awful.tag.viewprev),
  awful.key({ modkey, }, "Right", awful.tag.viewnext),
  awful.key({ modkey, }, ".", awful.tag.viewnext),
  awful.key({ modkey, altkey }, "space", awful.tag.history.restore),
  awful.key({ modkey, }, "Up", awful.tag.history.restore),
  awful.key({ modkey, }, "Down", awful.tag.history.restore),

  --    awful.key({ altkey,           }, "Tab",
  --        function ()
  --            awful.client.focus.byidx( 1)
  --            if client.focus then client.focus:raise() end
  --        end),
  --    awful.key({ altkey, shiftkey   }, "Tab",
  --        function ()
  --            awful.client.focus.byidx(-1)
  --            if client.focus then client.focus:raise() end
  --        end),
  awful.key({ modkey, }, "w", function() mymainmenu:show({ keygrabber = true }) end),

  -- Layout manipulation
  awful.key({ modkey, shiftkey }, "j", function() awful.client.swap.byidx(1) end),
  awful.key({ modkey, shiftkey }, "k", function() awful.client.swap.byidx(-1) end),
  awful.key({ modkey, ctrlkey }, "j", function() awful.screen.focus_relative(1) end),
  awful.key({ modkey, ctrlkey }, "k", function() awful.screen.focus_relative(-1) end),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
  awful.key({ altkey, }, "Tab",
    function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end),		

  -- Standard program
  awful.key({ modkey, }, "Return", function() awful.util.spawn(terminal) end),
  awful.key({ modkey, ctrlkey }, "r", awesome.restart),
  awful.key({ modkey, shiftkey }, "q", awesome.quit),

  awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end),
  awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end),
  awful.key({ modkey, shiftkey }, "h", function() awful.tag.incnmaster(1) end),
  awful.key({ modkey, shiftkey }, "l", function() awful.tag.incnmaster(-1) end),
  awful.key({ modkey, ctrlkey }, "h", function() awful.tag.incncol(1) end),
  awful.key({ modkey, ctrlkey }, "l", function() awful.tag.incncol(-1) end),
  awful.key({ modkey, }, "space", function() awful.layout.inc(layouts, 1) end),
  awful.key({ modkey, shiftkey }, "space", function() awful.layout.inc(layouts, -1) end),

  awful.key({ modkey, ctrlkey }, "n", awful.client.restore),

  -- shortcuts for tags
  awful.key({ ctrlkey, altkey }, "space", function() awful.tag.viewonly(tags[mouse.screen][1]) end),
  awful.key({ modkey }, "b", function() awful.tag.viewonly(tags[mouse.screen][4]) end), --browser aka [www]
  awful.key({ modkey }, "d", function() awful.tag.viewonly(tags[mouse.screen][2]) end), --dev
  awful.key({ modkey }, "v", function() awful.tag.viewonly(tags[mouse.screen][2]) end), --dev
  awful.key({ modkey }, "c", function() awful.tag.viewonly(tags[mouse.screen][5]) end), --irc/im
  awful.key({ modkey }, "/", function() awful.tag.viewonly(tags[mouse.screen][1]) end), --terminals

  awful.key({ ctrlkey, altkey }, "k", function() kbdcfg.switch() end),

  -- volume
  awful.key({}, "XF86AudioRaiseVolume", function() awful.util.spawn("amixer -c 0 set Master 2+ unmute") end),
  awful.key({}, "XF86AudioLowerVolume", function() awful.util.spawn("amixer -c 0 set Master 2- unmute") end),
  -- awful.key({}, "XF86AudioLowerVolume", function() awful.util.spawn("amixer -c 0 set Master nmute") end),

  -- clementine
  awful.key({}, "XF86AudioPrev", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Prev") end),
  awful.key({}, "XF86AudioNext", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Next") end),
  awful.key({}, "XF86AudioPlay", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Play") end),
  awful.key({}, "XF86AudioStop", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Pause") end),
  --  awful.key({}, "XF86AudioStop", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Stop") end),

  -- misc
  awful.key({ altkey, }, "space", function() mypromptbox[mouse.screen]:run() end), --prompt
  awful.key({}, "Print", function() awful.util.spawn("ksnapshot") end), -- screenshot

  awful.key({ modkey }, "x",
    function()
      awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end))

clientkeys = awful.util.table.join(awful.key({ modkey, }, "f", function(c) c.fullscreen = not c.fullscreen end),
  awful.key({ modkey, shiftkey }, "c", function(c) c:kill() end),
  awful.key({ modkey, ctrlkey }, "space", awful.client.floating.toggle),
  awful.key({ modkey, ctrlkey }, "Return", function(c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey, }, "o", awful.client.movetoscreen),
  awful.key({ modkey, shiftkey }, "r", function(c) c:redraw() end),
  awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end),
  awful.key({ modkey, }, "n",
    function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end),
  awful.key({ modkey, }, "m",
    function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c.maximized_vertical = not c.maximized_vertical
    end))

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
      function()
        local screen = mouse.screen
        if tags[screen][i] then
          awful.tag.viewonly(tags[screen][i])
        end
      end),
    awful.key({ modkey, ctrlkey }, "#" .. i + 9,
      function()
        local screen = mouse.screen
        if tags[screen][i] then
          awful.tag.viewtoggle(tags[screen][i])
        end
     end),
    awful.key({ modkey, shiftkey }, "#" .. i + 9,
      function()
        if client.focus and tags[client.focus.screen][i] then
          awful.client.movetotag(tags[client.focus.screen][i])
        end
      end),
    awful.key({ modkey, ctrlkey, shiftkey }, "#" .. i + 9,
      function()
        if client.focus and tags[client.focus.screen][i] then
          awful.client.toggletag(tags[client.focus.screen][i])
        end
      end))
end

clientbuttons = awful.util.table.join(awful.button({}, 1, function(c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = true,
      keys = clientkeys,
      buttons = clientbuttons
    }
  },
  {
    rule = { class = "MPlayer" },
    properties = { floating = true }
  },
  {
    rule = { class = "pinentry" },
    properties = { floating = true }
  },
  {
    rule = { class = "gimp" },
    properties = { floating = true }
  },

  -- default apps -> tags
  -- xprop | grep WM_CLAS
  { rule = { class = "OperaNext" }, properties = { tag = tags[1][4] } },
  { rule = { class = "Iceweasel" }, properties = { tag = tags[1][3] } },
  { rule = { class = "Wireshark" }, properties = { tag = tags[1][3] } },
  { rule = { class = "Krusader" }, properties = { tag = tags[1][7] } },
  { rule = { class = "Pidgin" }, properties = { tag = tags[1][5] } },
  { rule = { class = "Konversation" }, properties = { tag = tags[1][5] } },
  { rule = { class = "Kate" }, properties = { tag = tags[1][7] } },
  { rule = { class = "Clementine" }, properties = { tag = tags[1][6] } },
  { rule = { class = "Vlc" }, properties = { tag = tags[1][6] } },
  { rule = { class = "Gvim" }, properties = { tag = tags[1][2] } },
  { rule = { class = "jd-Main" }, properties = { tag = tags[1][7] } },
  { rule = { class = "Okular" }, properties = { tag = tags[1][7] } },
  { rule = { class = "java-lang-Thread" }, properties = { tag = tags[1][2] } }, --pycharm
  { rule = { class = "Keepassx" }, properties = { tag = tags[1][7] } },


}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function(c, startup)
-- Add a titlebar
--awful.titlebar.add(c, { modkey = modkey })

-- Enable sloppy focus
  c:add_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)

  if not startup then
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Put windows in a smart way, only if they does not set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- @TODO as a signal
awful.hooks.timer.register(battery_poll_int, function()
  battery(battery_id)
end)

-- runonce

require("lfs")
-- {{{ Run programm once
local function processwalker()
  local function yieldprocess()
    for dir in lfs.dir("/proc") do
      -- All directories in /proc containing a number, represent a process
      if tonumber(dir) ~= nil then
        local f, err = io.open("/proc/" .. dir .. "/cmdline")
        if f then
          local cmdline = f:read("*all")
          f:close()
          if cmdline ~= "" then
            coroutine.yield(cmdline)
          end
        end
      end
    end
  end

  return coroutine.wrap(yieldprocess)
end

local function run_once(process, cmd)
  assert(type(process) == "string")
  local regex_killer = {
    ["+"] = "%+",
    ["-"] = "%-",
    ["*"] = "%*",
    ["?"] = "%?"
  }

  for p in processwalker() do
    if p:find(process:gsub("[-+?*]", regex_killer)) then
      return
    end
  end
  return awful.util.spawn(cmd or process)
end

-- }}}

run_once("terminator")
awful.util.spawn("rm -rf /var/tmp/kdecache-starenka; qdbus org.kde.kded /kded loadModule powerdevil")
-- Use the second argument, if the programm you wanna start, 
-- differs from the what you want to search.
-- run_once("redshift", "nice -n19 redshift -l 51:14 -t 5700:4500")

-- function find_tag (name, s) local s = s or mouse.screen for _, t in pairs(tags[s]) do if t.name == name then return t end end end

-- remove spawn cursor
local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
  oldspawn(s, false)
end


-- mess starts here
blinkers = {}
function blinking(tb,iv,es)
    if (tb==nil) then 
        return
    end
    local fiv = iv or 1
    if blinkers[tb] then
        if blinkers[tb].timer.started then
            blinkers[tb].timer:stop()
        else
            blinkers[tb].timer:start()
        end
    else
        if (tb.text == nil) then
            return
        end
        blinkers[tb]= {}
        blinkers[tb].timer = timer({timeout=fiv})
        blinkers[tb].text = tb.text
        blinkers[tb].empty = 0

        blinkers[tb].timer:add_signal("timeout", function ()
            if (blinkers[tb].empty==1) then
                tb.text = blinkers[tb].text
                blinkers[tb].empty=0
            else
                blinkers[tb].empty=1
                tb.text = string.rep(" ",es)
            end
        end)

        blinkers[tb].timer:start()

    end
end

-- @TODO to module
function battery(adapter)
     spacer = ""
     local fcur = io.open("/sys/class/power_supply/"..adapter.."/energy_now")
     local fcap = io.open("/sys/class/power_supply/"..adapter.."/energy_full")
     local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
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
	   --color = '#C80003'
	   color = 'red'
         end
         battery = battery
     else
         dir = "="
         battery = "100"
     end
     text = spacer..dir..battery.."%"..spacer
     batterywidget.text = '<span color="'..color..'">'..text..'</span>'
     if blink == 1 then
       blinking(batterywidget, 1.2, string.len(text))
     end
     fcur:close()
     fcap:close()
     fsta:close()
 end
