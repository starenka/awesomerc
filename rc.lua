-- Standard awesome library
local gears = require("gears")
awful = require("awful") -- need to be global in order to be used by awesome-client
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

require("awful.remote") -- awesome-client
require("volume")
require("blinker")
require("debian.menu") -- Load Debian menu entries
--local freedesktop = require("freedesktop")
--myosmenu = freedesktop.menu.build()

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end
-- }}}

-- {{{ Variable definitions
HOME = os.getenv("HOME")
function home(path)
   return string.format("%s/%s", HOME, path)
end

-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
beautiful.init(home(".config/awesome/themes/starenka/theme.lua"))
beautiful.notification_icon_size = 40


cmd_player_playpause = home("bin/player playpause")
cmd_player_next = home("bin/player next")
cmd_player_prev = home("bin/player prev")
cmd_player_stop = home("bin/player stop")
cmd_player_volup = home("bin/player volume-up")
cmd_player_voldown = home("bin/player volume-down")
cmd_player_current = home("bin/player current")

cmd_vol_mute = home("bin/volume mute")
cmd_vol_raise = home("bin/volume up")
cmd_vol_lower = home("bin/volume down")

cmd_disp_external_on = home("bin/monitor don")
cmd_disp_external_off = home("bin/monitor doff")
cmd_disp_builtin_on = home("bin/monitor integrated")
cmd_disp_brightness_down = home("bin/brightness down")
cmd_disp_brightness_up = home("bin/brightness up")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
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

tags = {"$", "dev", "dev:www", "[www]", "#", "d{-_-}b", "/tmp"}

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    -- awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({theme = {width = 250}})
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    {"hotkeys", function() return false, hotkeys_popup.show_help end},
    {"manual", terminal .. " -e man awesome"},
    {"edit config", editor_cmd .. " " .. awesome.conffile},
    {"restart", awesome.restart},
    {"quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({
      items = {
         {"awesome", myawesomemenu, beautiful.awesome_icon},
         {"Debian", debian.menu.Debian_menu.Debian},
         {"open terminal", terminal}
}})

mylauncher = awful.widget.launcher({
        image = beautiful.awesome_icon,
        menu = mymainmenu
    })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %b %d %H:%M ")

-- {{ Widgets

-- widget separator widget
widget_sep = wibox.widget.textbox()
widget_sep:set_text("|")
spacer = wibox.widget.textbox()
spacer:set_text(" ")

-- Keyboard layout switching
kbdcfg = {
    cmd = "setxkbmap",
    layout = {"us", "cz -variant qwerty"},
    current = 1,
    widget = wibox.widget.textbox()
}
kbdcfg.switch = function()
    kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
    local t = " " .. kbdcfg.layout[kbdcfg.current] .. " "
    kbdcfg.widget:set_text(t:gsub("%s%-variant%s", ":"))
    os.execute(kbdcfg.cmd .. t)
end
kbdcfg.widget:set_text(" " .. kbdcfg.layout[kbdcfg.current] .. " ")

-- Mouse bindings
kbdcfg.widget:buttons(awful.util.table.join(awful.button({}, 1, function() kbdcfg.switch() end)))

-- Gmail
-- cat ~/.netrc: machine mail.google.com login johndoe@gmail.com password secretpass
-- https://support.google.com/accounts/answer/185833?hl=en

-- gmailwidget = wibox.widget.textbox()
-- vicious.register(gmailwidget, vicious.widgets.gmail, '${count}<span font-size="small"> unread</span>', 60*4)

-- Battery
battery = require("battery")
battery_poll_int = 5 --seconds

-- you can override default battery settings here
-- battery.settings={method='generic', color='#dcdccc', battery='BAT0', warning={ color='#fecf35', level=30}, critical={color='red', level=15}}
batterywidget = {
    widget = wibox.widget.textbox(),
    timer = gears.timer({timeout = battery_poll_int})
}
batterywidget.widget:set_text(" ?? ")
batterywidget.timer:connect_signal("timeout",
                                   function()
                                      local is_critical, blank_text, text = battery.get_info()
                                      batterywidget.widget:set_markup(text)
                                      if is_critical then
                                         blinking(batterywidget.widget, battery_poll_init, blank_text)
                                      else
                                         blinkers[batterywidget.widget] = nil
                                      end
                                   end
)
batterywidget.timer:start()

-- Calendar
local calendar = require("calendar")
calendar({}):attach(mytextclock)

cpuwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.cpu)
vicious.register(cpuwidget,
                 vicious.widgets.cpu,
                 function(widget, args)
                    return (' <span font-size="small">CPU %02d%%</span>'):format(args[1])
                 end,
                 5)

memwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, ' <span font-size="small">MEM $2MB</span> ', 7)

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
   awful.button({}, 1, function(t) t:view_only() end),
   awful.button({modkey}, 1,
      function(t)
         if client.focus then client.focus:move_to_tag(t) end
   end),
   awful.button({}, 3, awful.tag.viewtoggle),
   awful.button({modkey}, 3,
      function(t)
         if client.focus then client.focus:toggle_tag(t) end
      end
   ),
   awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
   awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
    awful.button({}, 1,
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end
    ),
    awful.button({}, 3, client_menu_toggle_fn()),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
    function(s)
        -- Wallpaper
        set_wallpaper(s)
        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt({with_shell=true})
        -- Each screen has its own tag table.
        awful.tag(tags, s, awful.layout.layouts[1])
        -- Create an imagebox widget which will contains an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(awful.util.table.join(
                awful.button({}, 1, function() awful.layout.inc(1) end),
                awful.button({}, 3, function() awful.layout.inc(-1) end),
                awful.button({}, 4, function() awful.layout.inc(1) end),
                awful.button({}, 5, function() awful.layout.inc(-1) end)
            )
        )
        -- Create a taglist widget
        s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
        -- Create a tasklist widget
        s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)
        -- Create the wibox
        s.mywibox = awful.wibar({position = "top", screen = s})
        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            {
                -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mypromptbox,
                s.mytaglist,
                widget_sep
            },
            s.mytasklist, -- Middle widget
            {
                -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.container.margin(wibox.widget.systray(), 1, 1, 2, 2),
                spacer,
                widget_sep,
                spacer,
                --gmailwidget,
                batterywidget.widget,
                cpuwidget,
                memwidget,
                volume_widget,
                kbdcfg.widget,
                widget_sep,
                mytextclock,
                s.mylayoutbox
            }
        }
    end
)
-- }}}

-- {{{ Mouse bindings
root.buttons(
    awful.util.table.join(
        awful.button({}, 3, function() mymainmenu:toggle() end),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
    )
)
-- }}}

-- {{{ Key bindings
globalkeys =
    awful.util.table.join(
    --awful.key({ modkey, }, "s", hotkeys_popup.show_help,
    --           {description="show help", group="awesome"}),
    awful.key({modkey}, "Left", awful.tag.viewprev),
    --awful.key({ modkey, }, ",", awful.tag.viewprev),
    awful.key({modkey}, "Right", awful.tag.viewnext),
    --awful.key({ modkey, }, ".", awful.tag.viewnext),
    awful.key({modkey, altkey}, "space", awful.tag.history.restore),
    awful.key({modkey}, "Up", awful.tag.history.restore),
    awful.key({modkey}, "Down", awful.tag.history.restore),
    -- shortcut for tags
    awful.key({modkey}, "d", function() awful.screen.focused().tags[2]:view_only() end, {}), --dev
    awful.key({modkey}, "b", function() awful.screen.focused().tags[4]:view_only() end, {}), --[www]
    awful.key({modkey}, "v", function() awful.screen.focused().tags[3]:view_only() end, {}), --dev:www
    awful.key({modkey}, "c", function() awful.screen.focused().tags[5]:view_only() end, {}), --irc
    awful.key({modkey}, "/", function() awful.screen.focused().tags[1]:view_only() end, {}), --terminals
    -- misc
    awful.key({}, "Print", function() awful.spawn("spectacle") end ), -- screenshot
    awful.key({ctrlkey}, "Escape", function() awful.spawn("gnome-system-monitor") end ), -- "ktop"
    awful.key({ctrlkey, altkey}, "k", function() kbdcfg.switch() end ), -- change kb layout
    awful.key({modkey}, "k", function() awful.spawn("xkill") end ), -- xkill
    awful.key({}, "F1", function() awful.spawn("xtrlock") end ), -- lockscreen
    awful.key({modkey, shiftkey}, "x", function() awful.spawn("uxterm -e /home/starenka/.local/bin/ipython") end ), -- term w/ python
    awful.key({modkey, shiftkey}, "z", function() awful.spawn("uxterm -e 'lua -i'") end ), --term w/ lua
    -- volume
    awful.key({}, "XF86AudioMute", function() awful.spawn(cmd_vol_mute) end ),
    awful.key({}, "XF86Launch1", function() awful.spawn(cmd_vol_mute) end ),
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn(cmd_vol_raise) end ),
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn(cmd_vol_lower) end ),
    awful.key({}, "F11", function() awful.spawn(cmd_vol_lower) end ),
    awful.key({}, "F12", function() awful.spawn(cmd_vol_raise) end ),
    awful.key({shiftkey}, "F11", function() awful.spawn(cmd_player_voldown) end ),
    awful.key({shiftkey}, "F12", function() awful.spawn(cmd_player_volup) end ),
    -- audioplayer
    awful.key({modkey, shiftkey}, "Left", function() awful.spawn(cmd_player_prev) end ),
    awful.key({modkey, shiftkey}, "Right", function() awful.spawn(cmd_player_next) end ),
    awful.key({modkey, shiftkey}, "Up", function() awful.spawn(cmd_player_stop) end ),
    awful.key({modkey, shiftkey}, "Down", function() awful.spawn(cmd_player_playpause) end ), -- brightness
    awful.key({}, "XF86MonBrightnessDown", function() awful.spawn(home("bin/brightness d")) end ), -- brightness
    awful.key({}, "XF86MonBrightnessUp", function() awful.spawn(home("bin/brightness u")) end ), -- monitors
    awful.key({modkey}, "F11", function() awful.spawn(cmd_disp_external_off) end ),
    awful.key({modkey, shiftkey}, "F11", function() awful.spawn(cmd_disp_builtin_on) end ),
    awful.key({modkey}, "F12", function() awful.spawn(cmd_disp_external_on) end ),
    awful.key({modkey}, "Tab",
       function()
          awful.client.focus.history.previous()
          if client.focus then client.focus:raise() end
       end, {description = "go back", group = "client"}),
    -- }}}

    -- Standard program
    awful.key({modkey}, "Return",
       function() awful.spawn(terminal) end,
       {description = "open a terminal", group = "launcher"}),
    awful.key({modkey, "Control"}, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
    awful.key({modkey, "Control"}, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        {description = "restore minimized", group = "client"}
    ),
    -- Prompt
    awful.key({altkey}, "space",
        function()
            awful.screen.focused().mypromptbox:run()
        end,
        {description = "run prompt", group = "launcher"}
    )
)

clientkeys =
    awful.util.table.join(
    awful.key({modkey}, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
    ),
    awful.key({modkey, "Shift"}, "c",
        function(c)
            c:kill()
        end,
        {description = "close", group = "client"}
    ),
    awful.key({modkey, "Control"}, "space",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}
    ),
    awful.key({modkey, "Control"}, "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}
    ),
    awful.key({modkey}, "o",
        function(c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}
    ),
    awful.key({modkey}, "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
    ),
    awful.key({modkey}, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = "minimize", group = "client"}
    ),
    awful.key({modkey}, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "maximize", group = "client"}
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys =
        awful.util.table.join(
        globalkeys,
        -- View tag only.
        awful.key(
            {modkey},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #" .. i, group = "tag"}
        ),
        -- Toggle tag display.
        awful.key(
            {modkey, "Control"},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),
        -- Move client to tag.
        awful.key(
            {modkey, "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #" .. i, group = "tag"}
        ),
        -- Toggle tag on focused client.
        awful.key(
            {modkey, "Control", "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}
        )
    )
end

clientbuttons =
    awful.util.table.join(
      awful.button( {}, 1,
         function(c)
            client.focus = c
            c:raise()
        end
    ),
    awful.button({modkey}, 1, awful.mouse.client.move),
    awful.button({modkey}, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    -- Floating clients.
    {rule_any = {
            instance = {
                "copyq" -- Includes session name in class.
            },
            class = {
                "Gpick",
                "pinentry",
                "xtightvncviewer"
            },
            name = {
                "Event Tester" -- xev.
            },
            role = {
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {floating = true}
    },
    -- Add titlebars to normal clients and dialogs
    {rule_any = {type = {"normal", "dialog"}},
     properties = {titlebars_enabled = false} -- disable window decorators
     --,properties = {titlebars_enabled = true} -- enable window decorators
    },
    -- default apps -> tags, use xprop | grep WM_CLAS to determine window props (second item)
    -- terms

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "firefox" },
    --   properties = { screen = 1, tag = "2" } },

    -- dev
    {rule = {class = "Emacs"},
     properties = {
        screen = 1,
        tag = tags[2],
        maximized_vertical = true,
        maximized_horizontal = true,
        size_hints_honor = true
     }
    },
    -- dev:www
    {rule = {class = "firefox"}, properties = {screen = 1, tag = tags[3]}},
    {rule = {class = "Google-chrome"}, properties = {screen = 1, tag = tags[3]}},
    {rule = {class = "Chromium"}, properties = {screen = 1, tag = tags[3]}},
    -- [www]
    {rule = {class = "Vivaldi-stable"}, properties = {screen = 1, tag = tags[4]}},
    {rule = {class = "Vivaldi-snapshot"}, properties = {screen = 1, tag = tags[4]}},
    {rule = {class = "KeePassXC"}, properties = {screen = 1, tag = tags[4]}},
    -- #
    {rule = {class = "Slack"}, properties = {screen = 1, tag = tags[5]}},
    -- d{-_-}b
    {
        rule = {class = "Clementine"},
        properties = {
            screen = 1,
            tag = tags[6],
            maximized_vertical = true,
            maximized_horizontal = true
        }
    },
    {rule = {class = "cantata"}, properties = {screen = 1, tag = tags[6]}},
    {rule = {class = "Spotify"}, properties = {screen = 1, tag = tags[6]}},
    {rule = {class = "Audacity"}, properties = {screen = 1, tag = tags[6]}},
    {rule = {class = "Vlc"}, properties = {screen = 1, tag = tags[6]}},
    {rule = {class = "Smplayer2"}, properties = {screen = 1, tag = tags[6]}},
    {rule = {class = "Qmpdclient"}, properties = {screen = 1, tag = tags[6]}},
    {rule = {class = "mplayer2"}, properties = {screen = 1, tag = tags[6]}},
    {rule = {class = "Qjackctl"}, properties = {screen = 1, tag = tags[6]}},
    {rule = {class = "Qsynth"}, properties = {screen = 1, tag = tags[6]}},
    -- /tmp
    {rule = {class = "krusader"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "VirtualBox"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "vox"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "Transmission-gtk"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "Nicotine"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "Okular"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "Wireshark"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "Sublime_text"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "dosbox"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "Kcachegrind"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "Blueman-manager"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "Pavucontrol"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "org.remmina.Remmina"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "Elasticvue"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "jadx-gui-JadxGUI"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "filezilla"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "krdc"}, properties = {screen = 1, tag = tags[7]}},

    {rule = {class = "steam"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "Unciv"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "Civ5XP"}, properties = {screen = 1, tag = tags[7]}},
    {rule = {class = "TuxPaint.TuxPaint"}, properties = {screen = 1, tag = tags[7]}},

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    "request::titlebars",
    function(c)
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
            awful.button({}, 1,
                function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end
            ),
            awful.button({}, 3,
                function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end
            )
        )

        awful.titlebar(c):setup {
            {
                -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout = wibox.layout.fixed.horizontal
            },
            {
                -- Middle
                {
                    -- Title
                    align = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            {
                -- Right
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter",
    function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
            client.focus = c
        end
    end
)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- autostart items (won't run on awesome restart)
-- {{{
run_once = require("runonce")

autorun_items = {
    "ogg123 -q ~/.config/awesome/themes/starenka/login.ogg",
    "nm-applet",
    "kitty --start-as maximized $HOME/bin/startup",
    --"blueman-applet",
    "~/bin/monitor doff",
    "~/bin/redshift",
    "~/.dropbox-dist/dropboxd",
    "~/bin/nicotine",
    "slack",
    "cantata",
    "emacs",
    "vivaldi",
    --"pavucontrol"
}

for _, item in ipairs(autorun_items) do run_once.run(item) end
