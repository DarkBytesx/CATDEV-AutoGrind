indexZoner = 1
Running = false
PropList = {}
MaxObject = 1
automode = false
Working = ''
IsPickup = false
Cancel = false
SvConfig = {}
PropHand = nil
AutoModeCount = 0
Token = nil
Objects = {}


PlayEffect = function(object,particleDictionary,particleName)
    RequestNamedPtfxAsset(particleDictionary)
    while not HasNamedPtfxAssetLoaded(particleDictionary) do
        Citizen.Wait(0)
    end
    SetPtfxAssetNextCall(particleDictionary)
    StartParticleFxNonLoopedOnEntity(particleName, object,0.0,0.0,0.0,0.0, 180.0, 0.0,0.5, false,false, false)
end

ui_update = function(count)
    SendNUIMessage(
        {
            type = "UPDATE_INFO_COUNT",
            count = count,
        }
    )
end

ui_key = function(val)
    SendNUIMessage(
        {
            type = "UPDATE_UI_KEY",
            data = val,
        }
    )
end

ui_settime = function(time)
    SendNUIMessage(
        {
            type = "UPDATE_TIME",
            time = time / 1000,
        }
    )
end
display = function(index)
    SendNUIMessage(
    {
        type = "UI_OPEN",
        count = 0,
        itemname = Config['JobList'][index].UI.item_name,
        labeltext = Config['JobList'][index].UI.item_label,
        imgparth = Config['Interface'].ImgPath,
    })
end

close_display = function()
    SendNUIMessage(
        {
            type = "UPDATE_UI_CLOSED",
        }
    )
end

SetCollision = function(index)
    if not collision then
        CreateThread(function()
            collision = true
            while collision do
                Wait(300)
                local PlayerxD = PlayerPedId()
                local PlayerCoords = GetEntityCoords(PlayerxD)
                local x , y , z = table.unpack(Config['JobList'][index].position)
                local radius = GetDistanceBetweenCoords(PlayerCoords, x, y, z, true)
                if radius < 30.0 then
                    for k,v in ipairs(PropList) do
                        SetEntityNoCollisionEntity(v,PlayerxD,false)
                    end
                else
                    collision = not collision
                    break;
                end
            end
        end)
    end
end

function CheckItem(item_name)
    local count = exports.ox_inventory:Search('count', item_name)
    print(('[DEBUG] Checking for item: %s, Found: %s'):format(item_name, count)) -- Debug line
    return count > 0
end



function CheckLimit(item_name)
    local inventory = ESX.GetPlayerData().inventory
    for i=1, #inventory do
      local item = inventory[i]
      if item_name == item.name then
        return item.limit
      end
    end
    return false
end

function CheckCount(item_name)
    local inventory = ESX.GetPlayerData().inventory
    for i=1, #inventory do
      local item = inventory[i]
      if item_name == item.name and item.count > 0 then
        return item.count
      end
    end
    return false
end


Config['grandZ'] = {    28.0,    30.0,    32.0,    34.0,    36.0,    37.0,    38.0,    40.0,    42.0,    43.0,    44.0,    45.0,    46.0,    47.0,    48.0,    49.0,    50.0,    51.0,    52.0,    53.0,    54.0,    55.0,    56.0,    57.0,    58.0,    59.0,    60.0,    61.0,    62.0,    63.0,    64.0,    65.0,    66.0,    67.0,    68.0,    69.0,    70.0,    107.0,    108.0,    109.0,    202.0,    203.0,    204.0}

function GenerateCrabCoords(v,scale)
    Config["spawnrandomX"] = {-scale, scale}
    Config["spawnrandomY"] = {-scale, scale}
    while true do
        local x , y , z = table.unpack(v)
        Citizen.Wait(7)

        local crabCoordX, crabCoordY

        math.randomseed(GetGameTimer())
        local modX = math.random(Config["spawnrandomX"][1], Config["spawnrandomX"][2])

        Citizen.Wait(100)

        math.randomseed(GetGameTimer())
        local modY = math.random(Config["spawnrandomY"][1], Config["spawnrandomY"][2])

        crabCoordX = x + modX
        crabCoordY = y + modY

        local coordZ = GetCoordZ(crabCoordX, crabCoordY)
        local coord = vector3(crabCoordX, crabCoordY, coordZ)
        if ValidateObjectCoord(coord, x, y, z) then
            return coord
        end
    end
end

function GetCoordZ(x, y)
    local groundCheckHeights = Config.grandZ
    for i, height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

        if foundGround then
            return z
        end
    end
    return 41.33
end

function ValidateObjectCoord(plantCoord, x,y,z)
    if MaxObject > 0 then
        local validate = true

        for k, v in pairs(PropList) do
            if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 3 then
                validate = false
            end
        end

        if GetDistanceBetweenCoords(plantCoord, x, y, z, false) > 20 then
            validate = false
        end

        return validate
    else
        return true
    end
end

function DeleteObject(nearbyObject,nearbyID)
    DeleteEntity(nearbyObject)
    ESX.Game.DeleteObject(nearbyObject)
    table.remove(PropList, nearbyID)
    MaxObject = MaxObject - 1
end

function DeleteAllProp()
    for k , v in ipairs(PropList) do 
        DeleteEntity(v)
        ESX.Game.DeleteObject(v)
    end
    ESX.Game.DeleteObject(PropHand)
    MaxObject = 0
    automode = false
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(10)
	end
end

function IsWorking()
    local jobConfig = Config['JobList'][indexZoner]

    if jobConfig.equipment ~= nil then
        local requiredEquipments = jobConfig.equipment.working
        local worklabel = jobConfig.equipment.label

        local hasAnyEquipment = false

        for _, equipment in ipairs(requiredEquipments) do
            if CheckItem(equipment) then
                hasAnyEquipment = true
                break
            end
        end

        if not hasAnyEquipment then
            xDFunction.Notify('error', ('You need at least one of the following to work: %s'):format(worklabel))
            return 'NOT_EQUIPMENT'
        end
    end

    if jobConfig.Agency ~= nil then
        if not xDFunction.CheckAgency(jobConfig.Agency) then
            xDFunction.Notify('error', 'Insufficient agency availability')
            return 'NOT_SERVICE'
        end
    end

    if jobConfig.BackListJob ~= nil then
        if jobConfig.BackListJob[GetJob()] then
            xDFunction.Notify('error', 'This agency is not allowed to perform this job')
            return 'NOT_JOB'
        end
    end

    return 'READY'
end