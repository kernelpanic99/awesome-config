local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local globals = require('globals')
local naughty = require("naughty")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

naughty.config.defaults.margin = 10

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"
local volume_notification = { id = nil }

local function volume(command)
    local dir = gears.filesystem.get_configuration_dir() .. "scripts/"

    awful.spawn.easy_async(dir .. "vol.sh " .. command, function(stdout)
        volume_notification = naughty.notify({
            title = 'Volume control',
            text = "Volume: " .. stdout,
            replaces_id = volume_notification.id,
        })
    end)
end

local globalkeys = gears.table.join(
        awful.key({ modkey, "Control" }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
        awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
        awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
        awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

        awful.key({ modkey }, "j", function()
            awful.client.focus.byidx(1)
        end, { description = "focus next by index", group = "client" }),
        awful.key({ modkey }, "k", function()
            awful.client.focus.byidx(-1)
        end, { description = "focus previous by index", group = "client" }),
-- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
--           {description = "show main menu", group = "awesome"}),

-- Layout manipulation
        awful.key({ modkey, "Shift" }, "j", function()
            awful.client.swap.byidx(1)
        end, { description = "swap with next client by index", group = "client" }),
        awful.key({ modkey, "Shift" }, "k", function()
            awful.client.swap.byidx(-1)
        end, { description = "swap with previous client by index", group = "client" }),
        awful.key({ modkey, "Control" }, "j", function()
            awful.screen.focus_relative(1)
        end, { description = "focus the next screen", group = "screen" }),
        awful.key({ modkey, "Control" }, "k", function()
            awful.screen.focus_relative(-1)
        end, { description = "focus the previous screen", group = "screen" }),
        awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
        awful.key({ modkey }, "Tab", function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end, { description = "go back", group = "client" }),

-- Standard program
        awful.key({ modkey }, "Return", function()
            awful.spawn(globals.terminal)
        end, { description = "open a terminal", group = "launcher" }),
        awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
        awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
        awful.key({ modkey }, "w", function()
            awful.spawn(globals.browser)
        end, { description = "Start browser", group = "launcher" }),

        awful.key({ modkey }, "e", function()
            awful.spawn("pcmanfm")
        end, { description = "Start file manager", group = "launcher" }),

        awful.key({ modkey }, "y", function()
            awful.spawn("keepassxc")
        end, { description = "Start password manager", group = "launcher" }),

        awful.key({ modkey }, "t", function()
            awful.spawn("skypeforlinux")
        end, { description = "Start Skype", group = "launcher" }),

        awful.key({ modkey }, "x", function()
            awful.spawn("audacious")
        end, { description = "Start Player", group = "launcher" }),

        awful.key({ modkey, "Shift" }, "w", function()
            awful.spawn("chromium")
        end, { description = "Start Chromium", group = "launcher" }),
        
        awful.key({ modkey, "Control" }, "w", function()
            awful.spawn("firefox-developer-edition")
        end, { description = "Start Firefox dev edition", group = "launcher" }),

        awful.key({ modkey }, "d", function()
            awful.spawn.with_shell("rofi -show combi")
        end, { description = "Rofi", group = "launcher" }),

        awful.key({}, "Print", function()
            awful.spawn("flameshot gui")
        end, { description = "Flameshot", group = "launcher" }),


        awful.key({ modkey }, "l", function()
            awful.tag.incmwfact(0.05)
        end, { description = "increase master width factor", group = "layout" }),

        awful.key({ modkey }, "h", function()
            awful.tag.incmwfact(-0.05)
        end, { description = "decrease master width factor", group = "layout" }),

        awful.key({ modkey, "Shift" }, "h", function()
            awful.tag.incnmaster(1, nil, true)
        end, { description = "increase the number of master clients", group = "layout" }),

        awful.key({ modkey, "Shift" }, "l", function()
            awful.tag.incnmaster(-1, nil, true)
        end, { description = "decrease the number of master clients", group = "layout" }),

        awful.key({ modkey, "Control" }, "h", function()
            awful.tag.incncol(1, nil, true)
        end, { description = "increase the number of columns", group = "layout" }),

        awful.key({ modkey, "Control" }, "l", function()
            awful.tag.incncol(-1, nil, true)
        end, { description = "decrease the number of columns", group = "layout" }),

        awful.key({ modkey }, "space", function()
            awful.layout.inc(1)
        end, { description = "select next", group = "layout" }),

        awful.key({ modkey, "Shift" }, "space", function()
            awful.layout.inc(-1)
        end, { description = "select previous", group = "layout" }),

        awful.key({ modkey, "Control" }, "n", function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", { raise = true })
            end
        end, { description = "restore minimized", group = "client" }),

        awful.key({ modkey }, "l", function()
            awful.spawn('xsecurelock')
        end, { description = "restore minimized", group = "client" }),

-- Volume control
        awful.key({}, "XF86AudioRaiseVolume", function()
            volume("inc")
        end, { description = "Increase volume", group = "media" }),
        awful.key({}, "XF86AudioLowerVolume", function()
            volume("dec")
        end, { description = "Decrease volume", group = "media" }),

-- Player controls
        awful.key({}, "XF86AudioNext", function()
            awful.spawn("playerctl -a next")
        end, { description = "Next track", group = "media" }),
        awful.key({}, "XF86AudioPrev", function()
            awful.spawn("playerctl -a previous")
        end, { description = "Previous track", group = "media" }),
        awful.key({}, "XF86AudioPause", function()
            awful.spawn("playerctl -a pause")
        end, { description = "Pause", group = "media" }),
        awful.key({}, "XF86AudioPlay", function()
            awful.spawn("playerctl -a play")
        end, { description = "Play", group = "media" }),

-- Rofi plugins
        awful.key({ modkey }, "p", function()
            awful.spawn.with_shell("rofi -show power-menu:~/.config/awesome/rofi/power-menu")
        end, { description = "Power menu", group = "media" }),
        awful.key({ modkey }, "c", function()
            awful.spawn(globals.terminal .." -e qalc")
        end, { description = "Calculator", group = "media" }),
        awful.key({ modkey }, "b", function()
            awful.spawn.with_shell("~/.config/awesome/rofi/rofi-bluetooth")
        end, { description = "Bluetooth", group = "media" })
)

local clientkeys = gears.table.join(
        awful.key(
                { modkey }, "f", function(c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end,
                { description = "toggle fullscreen", group = "client" }
        ),
        awful.key(
                { modkey }, "q", function(c)
                    c:kill()
                end,
                { description = "close", group = "client" }
        ),
        awful.key(
                { modkey, "Control" }, "space",
                awful.client.floating.toggle,
                { description = "toggle floating", group = "client" }
        ),
        awful.key(
                { modkey, "Control" }, "Return", function(c)
                    c:swap(awful.client.getmaster())
                end,
                { description = "move to master", group = "client" }
        ),
        awful.key(
                { modkey }, "o", function(c)
                    c:move_to_screen()
                end,
                { description = "move to screen", group = "client" }
        ),
        awful.key(
                { modkey }, "t", function(c)
                    c.ontop = not c.ontop
                end,
                { description = "toggle keep on top", group = "client" }
        ),
        awful.key({ modkey }, "n", function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
                { description = "minimize", group = "client" }
        ),
        awful.key({ modkey }, "s", function(c)
            c.maximized = not c.maximized
            c:raise()
        end, { description = "(un)maximize", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(
            globalkeys,
    -- View tag only.
            awful.key({ modkey }, "#" .. i + 9, function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
                    { description = "view tag #" .. i, group = "tag" }
            ),
    -- Toggle tag display.
            awful.key({ modkey, "Control" }, "#" .. i + 9, function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
                    { description = "toggle tag #" .. i, group = "tag" }
            ),
    -- Move client to tag.
            awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end, { description = "move focused client to tag #" .. i, group = "tag" }),
    -- Toggle tag on focused client.
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end, { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

local clientbuttons = gears.table.join(
        awful.button({}, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end),
        awful.button({ modkey }, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({ modkey }, 3, function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end)
)

return {
    globalkeys = globalkeys,
    client_keys = clientkeys,
    client_buttons = clientbuttons,
    modkey = modkey,
}
