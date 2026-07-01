local gears = require("gears")

local M = {}
M.blinkers = {}

-- Blink a textbox between `full` and `empty` markup.
-- Both `full` and `empty` are Pango markup strings (set via set_markup),
-- so colors and <span> tags are rendered instead of printed literally.
function M.blinking(tb, iv, full, empty)
    if tb == nil then
        return
    end
    empty = empty or ''
    local fiv = iv or 1

    if M.blinkers[tb] then
        -- keep the visible ("on") markup fresh so percentage/color
        -- changes on later updates are reflected while blinking
        M.blinkers[tb].full = full
        M.blinkers[tb].empty = empty
    else
        M.blinkers[tb] = { full = full, empty = empty, off = false }
        M.blinkers[tb].timer = gears.timer({timeout=fiv})

        M.blinkers[tb].timer:connect_signal("timeout", function()
            local b = M.blinkers[tb]
            if b == nil then return end
            if b.off then
                tb:set_markup(b.full)
                b.off = false
            else
                tb:set_markup(b.empty)
                b.off = true
            end
        end)

        M.blinkers[tb].timer:start()
    end
end

function M.stop(tb)
    local b = M.blinkers[tb]
    if b then
        b.timer:stop()
        tb:set_markup(b.full)
        M.blinkers[tb] = nil
    end
end

return M
