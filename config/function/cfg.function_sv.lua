xDFunction = {}

-- token_erroneous = โทเค้นไม่ถูกต้อง
-- spammer = Trigger รัวเกินไป
xDFunction.BanPlayer = function(xPlayer,types)
    
end

xDFunction.Notify = function(xPlayer, Type_noti, text)
    if Type_noti == 'InvFuully' then
        Type_noti = 'error'
    end

    lib.notify({
        id = 'AutoCollect',
        title = 'Auto Collect',
        description = text,
        type = Type_noti,
        position = 'top-right', -- Your preferred position
        duration = 4000
    })
end
