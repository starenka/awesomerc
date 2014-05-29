-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- awesome-client
require("awful.remote")

require("debian.menu")

require('blinker')
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("@AWESOME_THEMES_PATH@/default/theme.lua")
beautiful.init(string.format("%s/.config/awesome35/themes/starenka/theme.lua", os.getenv("HOME")))


-- This is used later as the default terminal and editor to run.
terminal = "terminator"
editor = os.getenv("EDITOR") or "nano"
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


-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
  awful.layout.suit.floating,
  awful.layout.suit.tile.left,
  --awful.layout.suit.tile.bottom,
  --awful.layout.suit.tile.top,
  --awful.layout.suit.fair,
  --awful.layout.suit.fair.horizontal,
  --awful.layout.suit.spiral,
  --awful.layout.suit.spiral.dwindle,
  --awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  --awful.layout.suit.magnifier
  awful.layout.suit.tile
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
  names = { '$', 'dev', 'dev:www', '[www]', '#', 'd{-_-}b', '/tmp' },
  layout = {
    layouts[1], layouts[1], layouts[1], layouts[1], layouts[2], layouts[1], layouts[1], layouts[1]
  }
}

for s = 1, screen.count() do
  tags[s] = awful.tag(tags.names, s, tags.layout)
end


-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
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

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


-- Keyboard layout switching
kbdcfg = {
  cmd = "setxkbmap",
  layout = { "us", "cz -variant qwerty" },
  current = 1,
  widget = wibox.widget.textbox()
}
kbdcfg.switch = function()
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  local t = " " .. kbdcfg.layout[kbdcfg.current] .. " "
  kbdcfg.widget:set_text(t:gsub('%s%-variant%s', ':'))
  os.execute(kbdcfg.cmd .. t)
end
kbdcfg.widget:set_text(" " .. kbdcfg.layout[kbdcfg.current] .. " ")
-- Mouse bindings
kbdcfg.widget:buttons(awful.util.table.join(awful.button({}, 1,
                             function() kbdcfg.switch() end)))

-- Gmail widget
-- cat ~/.netrc: machine mail.google.com login johndoe@gmail.com password secretpass

awful.widget.gmail = require('awful.widget.gmail')
gmailwidget = awful.widget.gmail.new()

-- battery
battery = require('battery')
battery_poll_int = 7 --seconds

-- you can override default battery settings here
-- battery.settings={method='generic', color='#dcdccc', battery='BAT0', warning={ color='#fecf35', level=30}, critical={color='red', level=15}}
battery.settings.method = 'smapi'
batterywidget = {
  widget = wibox.widget.textbox(),
  timer = timer({ timeout = battery_poll_int })
}
batterywidget.widget:set_text(" ?? ")
batterywidget.timer:connect_signal("timeout",
    function()
       local is_critical, blank_text, text = battery.get_info()
       batterywidget.widget:set_markup(text)
       if is_critical then blinking(batterywidget.widget, battery_poll_init, blank_text)
       else blinkers[batterywidget.widget] = nil
       end
    end
)
batterywidget.timer:start()

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock(" %b %d, %H:%M ")

-- calendar
require('awful.widget.calendar2')
calendar2.addCalendarToWidget(mytextclock)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
   awful.button({}, 1, awful.tag.viewonly),
   awful.button({ modkey }, 1, awful.client.movetotag),
   awful.button({}, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, awful.client.toggletag),
   awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
   awful.button({}, 1, function (c)
           if c == client.focus then
              c.minimized = true
           else
              -- Without this, the following
              -- :isvisible() makes no sense
              c.minimized = false
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


-- widget separator widget
widget_sep = wibox.widget.textbox()
widget_sep:set_text("|")
spacer = wibox.widget.textbox()
spacer:set_text(" ")

-- launcher
for s = 1, screen.count() do
  -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(awful.button({}, 1, function() awful.layout.inc(layouts, 1) end),
    awful.button({}, 3, function() awful.layout.inc(layouts, -1) end),
    awful.button({}, 4, function() awful.layout.inc(layouts, 1) end),
    awful.button({}, 5, function() awful.layout.inc(layouts, -1) end)))
  -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

  -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(spacer)
    left_layout:add(mypromptbox[s])
    left_layout:add(mytaglist[s])
    left_layout:add(spacer)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(gmailwidget)
    right_layout:add(spacer)
    right_layout:add(widget_sep)
    right_layout:add(batterywidget.widget)
    right_layout:add(widget_sep)
    right_layout:add(kbdcfg.widget)
    right_layout:add(widget_sep)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])


    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(awful.button({}, 3, function() mymainmenu:toggle() end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)))
-- }}}


-- {{{ Key bindings (use xev)
globalkeys = awful.util.table.join(awful.key({ modkey, }, "Left", awful.tag.viewprev),
  awful.key({ modkey, }, ",", awful.tag.viewprev),
  awful.key({ modkey, }, "Right", awful.tag.viewnext),
  awful.key({ modkey, }, ".", awful.tag.viewnext),
  awful.key({ modkey, altkey }, "space", awful.tag.history.restore),
  awful.key({ modkey, }, "Up", awful.tag.history.restore),
  awful.key({ modkey, }, "Down", awful.tag.history.restore),

  awful.key({ altkey, }, "Tab", function () awful.client.focus.byidx(1) if client.focus then client.focus:raise() end end),
  awful.key({ altkey, shiftkey }, "Tab", function () awful.client.focus.byidx(-1) if client.focus then client.focus:raise() end end),
  --awful.key({ modkey, }, "w", function() mymainmenu:show({ keygrabber = true }) end),

  -- Layout manipulation
  awful.key({ modkey, shiftkey }, "j", function() awful.client.swap.byidx(1) end),
  awful.key({ modkey, shiftkey }, "k", function() awful.client.swap.byidx(-1) end),
  awful.key({ modkey, ctrlkey }, "j", function() awful.screen.focus_relative(1) end),
  awful.key({ modkey, ctrlkey }, "k", function() awful.screen.focus_relative(-1) end),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey, }, "Tab",
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

  -- Resizing
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
  awful.key({ modkey }, "b", function() awful.tag.viewonly(tags[mouse.screen][4]) end), --browser [www]
  awful.key({ modkey }, "d", function() awful.tag.viewonly(tags[mouse.screen][2]) end), --dev
  awful.key({ modkey }, "v", function() awful.tag.viewonly(tags[mouse.screen][3]) end), --dev:www
  awful.key({ modkey }, "c", function() awful.tag.viewonly(tags[mouse.screen][5]) end), --irc/im
  awful.key({ modkey }, "/", function() awful.tag.viewonly(tags[mouse.screen][1]) end), --terminals

  awful.key({ ctrlkey, altkey }, "k", function() kbdcfg.switch() end),

  -- volume
  awful.key({}, "XF86AudioMute", function() awful.util.spawn("amixer xprosset Master toggle") end ),
  awful.key({}, "XF86Launch1", function() awful.util.spawn("amixer xprosset Master toggle") end ),
  awful.key({}, "XF86AudioRaiseVolume", function() awful.util.spawn("amixer -c0 set Master 2+ unmute") end),
  awful.key({}, "XF86AudioLowerVolume", function() awful.util.spawn("amixer -c0 set Master 2- unmute") end),
  awful.key({}, "F12", function() awful.util.spawn("amixer -c0 set Master 2+ unmute") end),
  awful.key({}, "F11", function() awful.util.spawn("amixer -c0 set Master 2- unmute") end),

  -- clementine
  awful.key({ modkey, shiftkey }, "Left", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Prev") end),
  awful.key({ modkey, shiftkey }, "Right", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Next") end),
  awful.key({}, "XF86AudioPrev", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Prev") end),
  awful.key({}, "XF86AudioNext", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Next") end),
  awful.key({}, "XF86AudioPlay", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Play") end),
  awful.key({}, "XF86AudioStop", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Pause") end),
  awful.key({ modkey, shiftkey }, "Up", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Play") end),
  awful.key({ modkey, shiftkey }, "Down", function() awful.util.spawn("qdbus org.mpris.clementine /Player org.freedesktop.MediaPlayer.Pause") end),

  -- misc
  awful.key({ altkey, }, "space", function() mypromptbox[mouse.screen]:run() end), --launcher
  awful.key({}, "Print", function() awful.util.spawn("ksnapshot") end), -- screenshot
  awful.key({ ctrlkey }, "Escape", function() awful.util.spawn("ksysguard") end), -- "ktop"

  -- awful.key({ modkey }, "x",
  --            function ()
  --                awful.prompt.run({ prompt = "Run Lua code: " },
  --                mypromptbox[mouse.screen].widget,
  --                awful.util.eval, nil,
  --                awful.util.getdir("cache") .. "/history_eval")
  --            end),


  awful.key({ modkey }, "a", function() awful.util.spawn("uxterm -e '~/bin/repls'") end), -- spawn term w/ REPL choices
  awful.key({ modkey }, "x", function() awful.util.spawn("uxterm -e 'bpython'") end), -- spawn term w/ python
  awful.key({ modkey }, "z", function() awful.util.spawn("uxterm -e 'lua5.2 -i'") end) -- spawn term w/ lua
)

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
   keynumber = math.min(9, math.max(#tags[s], keynumber))
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
                     focus = awful.client.focus.filter,
      keys = clientkeys,
      buttons = clientbuttons,
      maximized_vertical = false,
      maximized_horizontal = false
    }
  },
  {
    rule = { class = "MPlayer" },
    properties = { floating = true }
  },
  {
    rule = { class = "gimp" },
    properties = { floating = true }
  },

  -- default apps -> tags, use xprop | grep WM_CLAS to determine window props
  -- terms

  -- dev
  { rule = { class = "Emacs" }, properties = { tag = tags[1][2], maximized_vertical = true, maximized_horizontal = true, size_hints_honor = true } },
  { rule = { class = "Gvim" }, properties = { tag = tags[1][2] } },

  -- dev:www
  { rule = { class = "Iceweasel" }, properties = { tag = tags[1][3] } },
  { rule = { class = "Firefox-bin" }, properties = { tag = tags[1][3] } },
  { rule = { class = "Google-chrome" }, properties = { tag = tags[1][3] }},
  { rule = { class = "Chromium" }, properties = { tag = tags[1][3] }},
  { rule = { class = "Midori" }, properties = { tag = tags[1][3] }},

  -- [www]
  { rule = { class = "OperaNext" }, properties = { tag = tags[1][4] } },
  { rule = { class = "Opera" }, properties = { tag = tags[1][4] } },
  { rule = { class = "Keepassx" }, properties = { tag = tags[1][4] } },

  -- #
  { rule = { class = "Pidgin" }, properties = { tag = tags[1][5] } },
  { rule = { class = "Konversation" }, properties = { tag = tags[1][5] } },
  { rule = { class = "Geary" }, properties = { tag = tags[1][5] } },

  -- d{-_-}b
  { rule = { class = "Clementine" }, properties = { tag = tags[1][6] } },
  { rule = { class = "Sonata" }, properties = { tag = tags[1][6] } },
  { rule = { class = "Audacity" }, properties = { tag = tags[1][6] } },
  { rule = { class = "Vlc" }, properties = { tag = tags[1][6] } },
  { rule = { class = "Smplayer2" }, properties = { tag = tags[1][6] } },
  { rule = { class = "Qmpdclient" }, properties = { tag = tags[1][6] } },
  { rule = { class = "mplayer2" }, properties = { tag = tags[1][6] } },

  -- /tmp
  { rule = { class = "Krusader" }, properties = { tag = tags[1][7] } },
  { rule = { class = "VirtualBox" }, properties = { tag = tags[1][7] } },
  { rule = { class = "vox" }, properties = { tag = tags[1][7] } },
  { rule = { class = "Ktorrent" }, properties = { tag = tags[1][7] } },
  { rule = { class = "Nicotine" }, properties = { tag = tags[1][7] } },
  { rule = { class = "jd-Main" }, properties = { tag = tags[1][7] } },
  { rule = { class = "Okular" }, properties = { tag = tags[1][7] } },
  { rule = { class = "Wireshark" }, properties = { tag = tags[1][7] } },
  { rule = { class = "Kate" }, properties = { tag = tags[1][7] } },
  { rule = { class = "Sublime_text" }, properties = { tag = tags[1][7] } },
  { rule = { class = "Sublime" }, properties = { tag = tags[1][7] } },
  { rule = { class = "dosbox" }, properties = { tag = tags[1][7] },},
  { rule = { class = "Kcachegrind" }, properties = { tag = tags[1][7] },},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
-- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
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

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- autostart items (won't run on awesome restart)
-- {{{
run_once = require("runonce")

autorun_items =
{
    "ogg123 -q ~/.config/awesome/themes/starenka/login.ogg",
    "terminator -x ~/bin/startup",
    --"ktorrent",
    "wicd-client -o",
    "dropbox start",
    --"emacs",
    --"klipper",
}

for index, item in ipairs(autorun_items) do
  run_once.run(item)
end


-- remove spawn cursor
local oldspawn = awful.util.spawn
awful.util.spawn = function(s)
  oldspawn(s, false)
end

-- function find_tag (name, s) local s = s or mouse.screen for _, t in pairs(tags[s]) do if t.name == name then return t end end end
