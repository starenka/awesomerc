--  strenka's theme based on "Zenburn" awesome theme  --

-- {{{ Main
theme = {}
-- }}}

local THEME_DIR = string.format("%s/.config/awesome/themes/starenka/", os.getenv("HOME"))

-- {{{ Styles
--theme.font      = "andale mono 8.5"
--theme.font      = "dejavu sans mono 8"
--theme.font      = "monospace 7.3"
theme.font      = "monospace 8.5"

-- {{{ Colors
theme.fg_normal = "#DCDCCC"
theme.fg_focus  = "#F0DFAF"
theme.fg_focus  = "#fecf35"
--theme.fg_urgent = "#CC9393"
theme.fg_urgent = "#FFFFFF"
theme.bg_normal = "#232323"
theme.bg_focus  = "#1E2320"
theme.bg_focus = "#232323"
--theme.bg_urgent = "#232323"
theme.bg_urgent = "#FF6600"

-- }}}

-- {{{ Borders
theme.border_width  = "1"
theme.border_normal = "#232323"
theme.border_focus  = "#6F6F6F"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#232323"
theme.titlebar_bg_normal = "#232323"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
-- theme.taglist_bg_focus = "#FFFFFF"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#232323"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "16"
theme.menu_width  = "160"
-- }}}

-- {{{ Icons
-- {{{ Taglist
-- these are somehow stretched, turning them off (don't really need those)
theme.taglist_squares_sel   = THEME_DIR .. "taglist/squarefz.png"
theme.taglist_squares_unsel = THEME_DIR .. "taglist/squarefz.png"
--theme.taglist_squares_resize = "true"
-- }}}

-- {{{ Misc
theme.awesome_icon           = THEME_DIR .. "debian-icon.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
theme.tasklist_font = "monospace 7.5"
theme.tasklist_disable_icon = true

--theme.tasklist_bg_focus = '#FFFFFF'
--theme.tasklist_font = "Droid Sans Mono 8"
--theme.tasklist_floating_icon = "~/.config/awesome/themes/default/tasklist/floating.png"
--theme.tasklist_floating_icon = THEME_DIR .. "titlebar/ontop_focus_active.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = THEME_DIR .. "layouts/tile.png"
theme.layout_tileleft   = THEME_DIR .. "layouts/tileleft.png"
theme.layout_tilebottom = THEME_DIR .. "layouts/tilebottom.png"
theme.layout_tiletop    = THEME_DIR .. "layouts/tiletop.png"
theme.layout_fairv      = THEME_DIR .. "layouts/fairv.png"
theme.layout_fairh      = THEME_DIR .. "layouts/fairh.png"
theme.layout_spiral     = THEME_DIR .. "layouts/spiral.png"
theme.layout_dwindle    = THEME_DIR .. "layouts/dwindle.png"
theme.layout_max        = THEME_DIR .. "layouts/max.png"
theme.layout_fullscreen = THEME_DIR .. "layouts/fullscreen.png"
theme.layout_magnifier  = THEME_DIR .. "layouts/magnifier.png"
theme.layout_floating   = THEME_DIR .. "layouts/floating.png"
-- }}}

theme.wallpaper = THEME_DIR .. "awesome2.png"

-- {{{ Titlebar
theme.titlebar_close_button_focus  = THEME_DIR .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal = THEME_DIR .. "titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = THEME_DIR .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = THEME_DIR .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = THEME_DIR .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = THEME_DIR .. "titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = THEME_DIR .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = THEME_DIR .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = THEME_DIR .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = THEME_DIR .. "titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = THEME_DIR .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = THEME_DIR .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = THEME_DIR .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = THEME_DIR .. "titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = THEME_DIR .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = THEME_DIR .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = THEME_DIR .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = THEME_DIR .. "titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
