-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
gears = require("gears")
awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
menubar = require("menubar")

-- Initialize theme
beautiful.init(gears.filesystem.get_configuration_dir()  .. "themes/nord.lua")

require('globals')
keys = require('keys')
require('titlebar')
local bar = require('bar')
local rules = require('rules')

-- Error handling
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
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ 
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err) 
        })

        in_error = false
    end)
end



-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

-- Add statusbar
awful.screen.connect_for_each_screen(bar.createBar)

-- Mouse bindings
-- root.buttons(gears.table.join(
--     awful.button({ }, 3, function () mymainmenu:toggle() end),
--     awful.button({ }, 4, awful.tag.viewnext),
--     awful.button({ }, 5, awful.tag.viewprev)
-- ))

-- Set  Key bindings
root.keys(keys.globalkeys)


awful.rules.rules = rules

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.util.spawn_with_shell("~/.config/awesome/autorun.sh")
