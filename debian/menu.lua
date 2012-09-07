-- automatically generated file. Do not edit (see /usr/share/doc/menu/html)

module("debian.menu")

Debian_menu = {}

Debian_menu["Debian_Applications_Accessibility"] = {
	{"Xmag","xmag"},
}
Debian_menu["Debian_Applications_AudioVideo"] = {
	{"Google Music Manager","/opt/google/musicmanager/google-musicmanager","/opt/google/musicmanager/product_logo_32.xpm"},
}
Debian_menu["Debian_Applications_Data_Management"] = {
	{"LibreOffice Base","/usr/bin/libreoffice --base","/usr/share/icons/hicolor/32x32/apps/libreoffice34-base.xpm"},
	{"SQLite database browser","/usr/bin/sqlitebrowser","/usr/share/pixmaps/sqlitebrowser.xpm"},
}
Debian_menu["Debian_Applications_Editors"] = {
	{"GVIM","/usr/bin/vim.gtk -g -f","/usr/share/pixmaps/vim-32.xpm"},
	{"Nano", "x-terminal-emulator -e ".."/bin/nano","/usr/share/nano/nano-menu.xpm"},
	{"Xedit","xedit"},
}
Debian_menu["Debian_Applications_Emulators"] = {
	{"VirtualBox","/usr/bin/virtualbox","/usr/share/pixmaps/virtualbox.xpm"},
}
Debian_menu["Debian_Applications_File_Management"] = {
	{"mc", "x-terminal-emulator -e ".."/usr/bin/mc","/usr/share/pixmaps/mc.xpm"},
}
Debian_menu["Debian_Applications_Graphics"] = {
	{"dotty","/usr/bin/dotty"},
	{"Hugin","/usr/bin/hugin"},
	{"ImageMagick","/usr/bin/display logo:","/usr/share/pixmaps/display.xpm"},
	{"lefty","/usr/bin/lefty"},
	{"LibreOffice Draw","/usr/bin/libreoffice --draw","/usr/share/icons/hicolor/32x32/apps/libreoffice34-draw.xpm"},
	{"PTBatcherGUI","/usr/bin/PTBatcherGUI"},
	{"The GIMP","/usr/bin/gimp","/usr/share/pixmaps/gimp.xpm"},
	{"X Window Snapshot","xwd | xwud"},
}
Debian_menu["Debian_Applications_Network_Communication"] = {
	{"Konversation IRC Client","/usr/bin/konversation","/usr/share/pixmaps/konversation32x32.xpm"},
	{"Mutt", "x-terminal-emulator -e ".."/usr/bin/mutt","/usr/share/pixmaps/mutt.xpm"},
	{"Pidgin","/usr/bin/pidgin","/usr/share/pixmaps/pidgin-menu.xpm"},
	{"Telnet", "x-terminal-emulator -e ".."/usr/bin/telnet"},
	{"Xbiff","xbiff"},
}
Debian_menu["Debian_Applications_Network_File_Transfer"] = {
	{"KTorrent","ktorrent","/usr/share/pixmaps/ktorrent.xpm"},
	{"Nicotine-Plus","/usr/bin/nicotine","/usr/share/pixmaps/nicotine.xpm"},
}
Debian_menu["Debian_Applications_Network_Monitoring"] = {
	{"WICD","/usr/bin/wicd-gtk","/usr/share/pixmaps/wicd-gtk.xpm"},
	{"Wireshark","/usr/bin/wireshark","/usr/share/pixmaps/wsicon32.xpm"},
	{"XHydra","/usr/bin/xhydra","/usr/share/pixmaps/xhydra.xpm"},
}
Debian_menu["Debian_Applications_Network_Web_Browsing"] = {
	{"Chromium","chromium"},
	{"Google Chrome","/opt/google/chrome/google-chrome","/opt/google/chrome/product_logo_32.xpm"},
	{"Iceweasel","iceweasel","/usr/share/pixmaps/iceweasel.xpm"},
	{"Lynx-cur", "x-terminal-emulator -e ".."lynx"},
	{"Opera","/usr/bin/opera","/usr/share/pixmaps/opera-browser.xpm"},
	{"Opera Next","/usr/bin/opera-next","/usr/share/pixmaps/opera-next-browser.xpm"},
	{"w3af","/usr/share/w3af/w3af_gui","/usr/share/pixmaps/w3af.xpm"},
	{"w3m", "x-terminal-emulator -e ".."/usr/bin/w3m /usr/share/doc/w3m/MANUAL.html"},
}
Debian_menu["Debian_Applications_Network"] = {
	{ "Communication", Debian_menu["Debian_Applications_Network_Communication"] },
	{ "File Transfer", Debian_menu["Debian_Applications_Network_File_Transfer"] },
	{ "Monitoring", Debian_menu["Debian_Applications_Network_Monitoring"] },
	{ "Web Browsing", Debian_menu["Debian_Applications_Network_Web_Browsing"] },
}
Debian_menu["Debian_Applications_Office"] = {
	{"FreeMind","/usr/bin/freemind","/usr/share/pixmaps/FreeMindWindowIcon.xpm"},
	{"LibreOffice Calc","/usr/bin/libreoffice --calc","/usr/share/icons/hicolor/32x32/apps/libreoffice34-calc.xpm"},
	{"LibreOffice Impress","/usr/bin/libreoffice --impress","/usr/share/icons/hicolor/32x32/apps/libreoffice34-impress.xpm"},
	{"LibreOffice Writer","/usr/bin/libreoffice --writer","/usr/share/icons/hicolor/32x32/apps/libreoffice34-writer.xpm"},
}
Debian_menu["Debian_Applications_Programming"] = {
	{"Erlang Shell", "x-terminal-emulator -e ".."/usr/bin/erl","/usr/share/pixmaps/erlang.xpm"},
	{"GDB", "x-terminal-emulator -e ".."/usr/bin/gdb"},
	{"Giggle","/usr/bin/giggle"},
	{"Python (v2.6)", "x-terminal-emulator -e ".."/usr/bin/python2.6","/usr/share/pixmaps/python2.6.xpm"},
	{"Python (v2.7)", "x-terminal-emulator -e ".."/usr/bin/python2.7","/usr/share/pixmaps/python2.7.xpm"},
	{"Python (v3.1)", "x-terminal-emulator -e ".."/usr/bin/python3.1","/usr/share/pixmaps/python3.1.xpm"},
	{"Python (v3.2)", "x-terminal-emulator -e ".."/usr/bin/python3.2","/usr/share/pixmaps/python3.2.xpm"},
	{"Ruby (irb1.8)", "x-terminal-emulator -e ".."/usr/bin/irb1.8"},
	{"Ruby (irb1.9.1)", "x-terminal-emulator -e ".."/usr/bin/irb1.9.1"},
	{"Sun Java 6 Web Start","/usr/lib/jvm/java-6-sun-1.6.0.26/bin/javaws -viewer","/usr/share/pixmaps/sun-java6.xpm"},
	{"Tclsh8.5", "x-terminal-emulator -e ".."/usr/bin/tclsh8.5"},
	{"TkWish8.5","x-terminal-emulator -e /usr/bin/wish8.5"},
}
Debian_menu["Debian_Applications_Science_Mathematics"] = {
	{"Bc", "x-terminal-emulator -e ".."/usr/bin/bc"},
	{"Dc", "x-terminal-emulator -e ".."/usr/bin/dc"},
	{"LibreOffice Math","/usr/bin/libreoffice --math","/usr/share/icons/hicolor/32x32/apps/libreoffice34-math.xpm"},
	{"Xcalc","xcalc"},
}
Debian_menu["Debian_Applications_Science"] = {
	{ "Mathematics", Debian_menu["Debian_Applications_Science_Mathematics"] },
}
Debian_menu["Debian_Applications_Shells"] = {
	{"Bash", "x-terminal-emulator -e ".."/bin/bash --login"},
	{"Dash", "x-terminal-emulator -e ".."/bin/dash -i"},
	{"Sh", "x-terminal-emulator -e ".."/bin/sh --login"},
}
Debian_menu["Debian_Applications_Sound"] = {
	{"Amarok","/usr/bin/amarok"},
	{"Clementine","/usr/bin/clementine"},
	{"Last.fm","/usr/bin/lastfm","/usr/share/pixmaps/lastfm32.xpm"},
	{"moc", "x-terminal-emulator -e ".."/usr/bin/mocp"},
	{"TiMidity++","timidity -ia","/usr/share/pixmaps/timidity.xpm"},
}
Debian_menu["Debian_Applications_System_Administration"] = {
	{"Aptitude (terminal)", "x-terminal-emulator -e ".."/usr/bin/aptitude-curses"},
	{"Debian Task selector", "x-terminal-emulator -e ".."su-to-root -c tasksel"},
	{"Editres","editres"},
	{"GNOME partition editor","su-to-root -X -c /usr/sbin/gparted","/usr/share/pixmaps/gparted.xpm"},
	{"GTK+ 2.0 theme manager","/usr/bin/gtk-chtheme","/usr/share/pixmaps/gtk-chtheme.xpm"},
	{"Openbox Configuration Manager","/usr/bin/obconf","/usr/share/pixmaps/obconf.xpm"},
	{"OpenJDK Java 6 Policy Tool","/usr/lib/jvm/java-6-openjdk-amd64/bin/policytool","/usr/share/pixmaps/openjdk-6.xpm"},
	{"OpenJDK Java 7 Policy Tool","/usr/lib/jvm/java-7-openjdk-amd64/bin/policytool","/usr/share/pixmaps/openjdk-7.xpm"},
	{"QtConfig","/usr/bin/qtconfig-qt4"},
	{"Reportbug", "x-terminal-emulator -e ".."/usr/bin/reportbug --exit-prompt"},
	{"Reportbug (GTK+)","/usr/bin/reportbug --exit-prompt --ui gtk2"},
	{"Sun Java 6 Plugin Control Panel","/usr/lib/jvm/java-6-sun-1.6.0.26/bin/ControlPanel","/usr/share/pixmaps/sun-java6.xpm"},
	{"Xclipboard","xclipboard"},
	{"Xfontsel","xfontsel"},
	{"Xkill","xkill"},
	{"Xrefresh","xrefresh"},
}
Debian_menu["Debian_Applications_System_Hardware"] = {
	{"Xvidtune","xvidtune"},
}
Debian_menu["Debian_Applications_System_Monitoring"] = {
	{"htop", "x-terminal-emulator -e ".."/usr/bin/htop"},
	{"Pstree", "x-terminal-emulator -e ".."/usr/bin/pstree.x11","/usr/share/pixmaps/pstree16.xpm"},
	{"Top", "x-terminal-emulator -e ".."/usr/bin/top"},
	{"Xconsole","xconsole -file /dev/xconsole"},
	{"Xev","x-terminal-emulator -e xev"},
	{"Xload","xload"},
}
Debian_menu["Debian_Applications_System_Package_Management"] = {
	{"Opera Next Widget Manager","/usr/bin/opera-next-widget-manager","/usr/share/pixmaps/opera-next-widget-manager.xpm"},
	{"Opera Widget Manager","/usr/bin/opera-widget-manager","/usr/share/pixmaps/opera-widget-manager.xpm"},
	{"Synaptic Package Manager","/usr/bin/su-to-root -X -c /usr/sbin/synaptic","/usr/share/synaptic/pixmaps/synaptic_32x32.xpm"},
}
Debian_menu["Debian_Applications_System_Security"] = {
	{"Sun Java 6 Policy Tool","/usr/lib/jvm/java-6-sun-1.6.0.26/bin/policytool","/usr/share/pixmaps/sun-java6.xpm"},
}
Debian_menu["Debian_Applications_System"] = {
	{ "Administration", Debian_menu["Debian_Applications_System_Administration"] },
	{ "Hardware", Debian_menu["Debian_Applications_System_Hardware"] },
	{ "Monitoring", Debian_menu["Debian_Applications_System_Monitoring"] },
	{ "Package Management", Debian_menu["Debian_Applications_System_Package_Management"] },
	{ "Security", Debian_menu["Debian_Applications_System_Security"] },
}
Debian_menu["Debian_Applications_Terminal_Emulators"] = {
	{"X-Terminal as root (GKsu)","/usr/bin/gksu -u root /usr/bin/x-terminal-emulator","/usr/share/pixmaps/gksu-debian.xpm"},
}
Debian_menu["Debian_Applications_Text"] = {
	{"Poedit","/usr/bin/poeditor","/usr/share/pixmaps/poedit.xpm"},
}
Debian_menu["Debian_Applications_Video"] = {
	{"GNOME MPlayer","gnome-mplayer","/usr/share/pixmaps/gnome-mplayer.xpm"},
	{"gxine video player","/usr/bin/gxine","/usr/share/gxine/pixmaps/gxine-icon.xpm"},
	{"VLC media player","/usr/bin/qvlc","/usr/share/icons/hicolor/32x32/apps/vlc.xpm"},
}
Debian_menu["Debian_Applications_Viewers"] = {
	{"digikam","/usr/bin/digikam"},
	{"Evince","/usr/bin/evince","/usr/share/pixmaps/evince.xpm"},
	{"MPlayer","/usr/bin/gmplayer","/usr/share/pixmaps/mplayer.xpm"},
	{"Xditview","xditview"},
}
Debian_menu["Debian_Applications"] = {
	{ "Accessibility", Debian_menu["Debian_Applications_Accessibility"] },
	{ "AudioVideo", Debian_menu["Debian_Applications_AudioVideo"] },
	{ "Data Management", Debian_menu["Debian_Applications_Data_Management"] },
	{ "Editors", Debian_menu["Debian_Applications_Editors"] },
	{ "Emulators", Debian_menu["Debian_Applications_Emulators"] },
	{ "File Management", Debian_menu["Debian_Applications_File_Management"] },
	{ "Graphics", Debian_menu["Debian_Applications_Graphics"] },
	{ "Network", Debian_menu["Debian_Applications_Network"] },
	{ "Office", Debian_menu["Debian_Applications_Office"] },
	{ "Programming", Debian_menu["Debian_Applications_Programming"] },
	{ "Science", Debian_menu["Debian_Applications_Science"] },
	{ "Shells", Debian_menu["Debian_Applications_Shells"] },
	{ "Sound", Debian_menu["Debian_Applications_Sound"] },
	{ "System", Debian_menu["Debian_Applications_System"] },
	{ "Terminal Emulators", Debian_menu["Debian_Applications_Terminal_Emulators"] },
	{ "Text", Debian_menu["Debian_Applications_Text"] },
	{ "Video", Debian_menu["Debian_Applications_Video"] },
	{ "Viewers", Debian_menu["Debian_Applications_Viewers"] },
}
Debian_menu["Debian_Games_Blocks"] = {
	{"Crack Attack!","/usr/games/crack-attack","/usr/share/pixmaps/crack-attack.xpm"},
	{"Frozen-Bubble","/usr/games/frozen-bubble","/usr/share/pixmaps/frozen-bubble.xpm"},
}
Debian_menu["Debian_Games_Toys"] = {
	{"Oclock","oclock"},
	{"Xclock (analog)","xclock -analog"},
	{"Xclock (digital)","xclock -digital -update 1"},
	{"Xeyes","xeyes"},
	{"Xlogo","xlogo"},
}
Debian_menu["Debian_Games"] = {
	{ "Blocks", Debian_menu["Debian_Games_Blocks"] },
	{ "Toys", Debian_menu["Debian_Games_Toys"] },
}
Debian_menu["Debian_Help"] = {
	{"Info", "x-terminal-emulator -e ".."info"},
	{"Xman","xman"},
}
Debian_menu["Debian_Screen_Locking"] = {
	{"Lock Screen (XScreenSaver)","/usr/bin/xscreensaver-command -lock"},
}
Debian_menu["Debian_Screen_Saving"] = {
	{"Activate ScreenSaver (Next)","/usr/bin/xscreensaver-command -next"},
	{"Activate ScreenSaver (Previous)","/usr/bin/xscreensaver-command -prev"},
	{"Activate ScreenSaver (Random)","/usr/bin/xscreensaver-command -activate"},
	{"Demo Screen Hacks","/usr/bin/xscreensaver-command -demo"},
	{"Disable XScreenSaver","/usr/bin/xscreensaver-command -exit"},
	{"Enable XScreenSaver","/usr/bin/xscreensaver"},
	{"Reinitialize XScreenSaver","/usr/bin/xscreensaver-command -restart"},
	{"ScreenSaver Preferences","/usr/bin/xscreensaver-command -prefs"},
}
Debian_menu["Debian_Screen"] = {
	{ "Locking", Debian_menu["Debian_Screen_Locking"] },
	{ "Saving", Debian_menu["Debian_Screen_Saving"] },
}
Debian_menu["Debian"] = {
	{ "Applications", Debian_menu["Debian_Applications"] },
	{ "Games", Debian_menu["Debian_Games"] },
	{ "Help", Debian_menu["Debian_Help"] },
	{ "Screen", Debian_menu["Debian_Screen"] },
}
