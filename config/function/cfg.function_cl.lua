xDFunction = {}


xDFunction.Notify = function(Type, text)
    lib.notify({
        id = 'autocl',
        title = 'Auto Collect',
        description = text,
        type = Type,
        position = 'center-right', -- Your preferred notification position
        duration = 4000
    })
end


-- xDFunction.KeyPress = function(text)
--     exports['AFU.Toastify']:show({
--         { type = 'text', prop = 'กด' },  -- หาก type เป็น text ในส่วนของ prop ที่เราใส่เข้าไปจะกลายเป็นข้อความ
--         { type = 'key', prop = 'E' },  -- หาก type เป็น key ในส่วนของ prop ที่เราใส่เข้าไปจะกลายเป็นข้อความที่มีกรอบเหมือนปุ่มครอบ
--         { type = 'text', prop = 'เพื่อเนิ่มทำงาน' }, -- หาก type เป็น text ในส่วนของ prop ที่เราใส่เข้าไปจะกลายเป็นข้อความ
--      })
-- end

xDFunction.CheckAgency = function(Agency)
    if exports.Dv_Hunter_Check:CheckPolice(Agency['police']) or Agency['police'] == 0 then
        return true
	end
    return false
end