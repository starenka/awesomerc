blinkers = {}
function blinking(tb,iv,empty)
    if (tb==nil) then 
        return
    end
    empty = empty or ''
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
                tb.text = empty
            end
        end)

        blinkers[tb].timer:start()

    end
end
