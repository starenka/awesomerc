local gears = require("gears")

local M = {}
M.blinkers = {}

function M.blinking(tb, iv, empty)
    if tb == nil then
        return
    end
    empty = empty or ''
    local fiv = iv or 1

    if M.blinkers[tb] then
        if M.blinkers[tb].timer.started then
            M.blinkers[tb].timer:stop()
        else
            M.blinkers[tb].timer:start()
        end
    else
        if tb.text == nil then
            return
        end
        M.blinkers[tb] = {}
        M.blinkers[tb].timer = gears.timer({timeout=fiv})
        M.blinkers[tb].text = tb.text
        M.blinkers[tb].empty = 0

        M.blinkers[tb].timer:connect_signal("timeout", function()
            if M.blinkers[tb].empty == 1 then
                tb.text = M.blinkers[tb].text
                M.blinkers[tb].empty = 0
            else
                M.blinkers[tb].empty = 1
                tb.text = empty
            end
        end)

        M.blinkers[tb].timer:start()
    end
end

return M
