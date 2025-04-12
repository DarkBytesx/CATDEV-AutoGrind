local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local scale_size = 15
local isDead = false
local ResourceName = GetCurrentResourceName()
local PlayerData = {}
Citizen.CreateThread(function()
    while ESX == nil do
    ESX = exports["es_extended"]:getSharedObject()
		Citizen.Wait(0)
	end

    while (ESX.GetPlayerData() == nil or ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job.name == nil) do
		Wait(100)
	end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function GetJob()
    if (PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.name ~= nil) then
        return PlayerData.job.name
	end
	return nil
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    --print(('^0[^2%s^0] ^5Loading Resource ^0: ^0(^3%s^0)'):format(ResourceName,ResourceName))
    Citizen.Wait(1000)
    TriggerServerEvent(ResourceName..':ConfigSetting')
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
    if IsPickup then
        CancelWorking()
    end
end)

AddEventHandler('playerSpawned', function(spawn)
    if isDead then 
        isDead = false
    end
end)

RegisterNetEvent(ResourceName..':Setting', function(data,t)
	SvConfig = data
    Token = t
    --print(('^0[^2%s^0] ^5Loading Resource ^2Successfully'):format(ResourceName))
    if Config.Debug then 
        --print(('^0[^2%s^0] ^5Token^0: ^3%s'):format(ResourceName,Token))
    end
end)

Citizen.CreateThread(function()
    for k , v in ipairs(Config['JobList']) do 
        if v.Blips then
            local x , y , z = table.unpack(v.position)
            local Blips_ = AddBlipForCoord(x, y, z)
            SetBlipSprite (Blips_, v.Blips.Sprite)
            SetBlipDisplay(Blips_, 4)
            SetBlipScale  (Blips_, v.Blips.Size)
            SetBlipColour (Blips_, v.Blips.Color)
            SetBlipAsShortRange(Blips_, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.Blips.Text)
            EndTextCommandSetBlipName(Blips_)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k , v in ipairs(Config['JobList']) do 
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local x , y , z = table.unpack(v.position)
            local radius = GetDistanceBetweenCoords(PlayerCoords, x, y, z, true)
            if radius <= (v.scale + scale_size) then
                indexZoner = k
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        local x , y , z = table.unpack(Config['JobList'][indexZoner].position)
        local radius = GetDistanceBetweenCoords(PlayerCoords, x, y, z, true)
        if radius <= (Config['JobList'][indexZoner].scale + scale_size) and (not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped)) then
            SpawnObjects(indexZoner)
            display(indexZoner)
        else
            DeleteAllProp()
        end
    end
end)

sleep3 = false
collision = false
local Ready = false
local PressSec = false
local GameTimes = GetGameTimer()
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        sleep3 = true
        if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsEntityDead(PlayerPedId()) then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local x , y , z = table.unpack(Config['JobList'][indexZoner].position)
            local radius = GetDistanceBetweenCoords(PlayerCoords, x, y, z, true)
            Working = 'READY'
            if radius <= (Config['JobList'][indexZoner].scale + scale_size) and not isDead then
                local nearbyObject, nearbyID
                sleep3 = false

                for i = 1, #PropList, 1 do
                    if GetDistanceBetweenCoords(coords, GetEntityCoords(PropList[i]), false) < Config['JobList'][indexZoner].Object.radius then
                        nearbyObject, nearbyID = PropList[i], i
                    end
                end

                SetCollision(indexZoner)
                if IsControlPressed(0,Keys['E']) and not IsEntityDead(PlayerPedId()) and not automode then
                    if not PressSec then
                        delay = GetGameTimer() + (1 * 1000)
                        PressSec = true
                    end

                    if delay < GetGameTimer() and not Ready then
                        Working = IsWorking()
                        if Working == 'READY' then
                            --TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Ready'}})
                            Ready = true
                            AutoMode(indexZoner)
                            automode = true
                            ui_key(true)
                            ui_update(0)
                        else
                            --TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'ERROR'}})
                        end
                    end
                end
                if IsControlJustReleased(0,Keys['E']) and PressSec then
                    PressSec = false
                    Ready = false
                end

                if (nearbyObject and IsPedOnFoot(playerPed)) then
                    if not automode and not IsPickup then
                        -- lib.showTextUI('[E] Start Working', {
                        --     position = 'right-center', -- Adjust position if needed
                        --     icon = 'briefcase', -- Optional icon
                        --     style = {
                        --         borderRadius = 5,
                        --         backgroundColor = '#333333',
                        --         color = '#ffffff'
                        --     }
                        -- })
                    end

                    if IsControlJustPressed(0,Keys['E']) and not IsPickup or automode and not IsPickup then
                        Working = IsWorking()
                        if Working == 'READY' then
                            IsPickup = true
                            PickupItem(indexZoner,nearbyObject, nearbyID)
                        end
                    end
                end
                if Working ~= 'READY' then
                    Citizen.Wait(2000)
                end
            else
                collision = false
                close_display()
            end
        end

        if sleep3 then 
            Citizen.Wait(1000)
        end
    end
end)

function AutoMode(index)
    if not isDead then
        onPlayerCancle()
        Citizen.CreateThread(function()
            while automode do
                if not IsPickup then 
                    local playerPed = PlayerPedId()
                    local coords = GetEntityCoords(playerPed)
                    for k,v in ipairs(PropList) do
                        Entity = v
                    end
                    FreezeEntityPosition(Entity,true)
                    local EntityCoords = GetEntityCoords(Entity)
                    if not Running then
                        TaskGoStraightToCoord(playerPed,EntityCoords.x, EntityCoords.y, EntityCoords.z, 2.0,-1,0,0)
                        Running = true
                    end
                end
                Citizen.Wait(1000)
            end
        end)
    end
end

onPlayerCancle = function()
    Citizen.CreateThread(function()
        while automode do
            Wait(0)
            if IsControlJustPressed(0,Keys['X']) then
                CancelWorking()
            end
        end
    end)
end

function GiveItem(index)
    if not isDead then
        TriggerServerEvent(ResourceName..':Giveitem_Sv', index, Token)
        AutoModeCount = AutoModeCount + 1
        ui_update(AutoModeCount)
        IsPickup = false
        ClearPedTasks(PlayerPedId())
        ESX.Game.DeleteObject(PropHand)
        Running = false
    end
end

function PickupItem(index, nearbyObject, nearbyID)
    if not isDead then
        local time = nil
        if automode then 
            time = Config['JobList'][index].TakeItem.TimeAutoMode
        else
            time = Config['JobList'][index].TakeItem.TimeStandard
        end
        if IsPickup then
            ClearPedTasksImmediately(PlayerPedId())
            ClearPedTasks(PlayerPedId())
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
            ui_settime(time)
            if Config['JobList'][index].Object.Player ~= nil then 
                GiveHandItems(index)
            end
            if Config['JobList'][index].Animation then
                if Config['JobList'][index].Animation.animDict == nil or Config['JobList'][index].Animation.animDict == '' then
                    TaskStartScenarioInPlace(PlayerPedId(), Config['JobList'][index].Animation.animName, 0, false)
                else
                    loadAnimDict(Config['JobList'][index].Animation.animDict)
                    TaskPlayAnim((PlayerPedId()), Config['JobList'][index].Animation.animDict, Config['JobList'][index].Animation.animName, 2.0, 2.0, -1, 1, 0, false, false, false)
                end
            end

            -- local equipmentItem = Config['JobList'][index].equipment.working
            -- TriggerServerEvent(ResourceName..':BreakEquipment', equipmentItem) 

            TriggerEvent("mythic_progbar:client:progress", {
                name = "unique_action_name",
                duration = time,
                label = Config['JobList'][index].labeltext,
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
            }, function(status)
                if not status then
                    ESX.Game.DeleteObject(PropHand)
                    DeleteObject(nearbyObject, nearbyID)
                    GiveItem(index)
                else
                    ESX.Game.DeleteObject(PropHand)
                    IsPickup = false
                    CancelWorking()
                end
            end)
        end
    end
end


RegisterNetEvent(ResourceName..':InventoryFully')
AddEventHandler(ResourceName..':InventoryFully', function()
    CancelWorking()
    TriggerEvent('InteractSound_CL:PlayOnOne', 'alarm_farm', 0.1)
    lib.notify({
        title = 'Inventory Full',
        description = 'You cannot carry more items!',
        position = 'center-right',
        type = 'error' -- 'info', 'success', 'warning', 'error'
    })
end)

function CancelWorking()
    ClearPedTasksImmediately(PlayerPedId())
    ClearPedTasks(PlayerPedId())
    Running = false
    Cancel = false
    automode = false
    AutoModeCount = 0
    IsPickup = false
    ESX.Game.DeleteObject(PropHand)
    ui_settime(0)
    ui_key(0)
end

function GiveHandItems(index)
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local prop = CreateObject(GetHashKey(Config['JobList'][index].Object.Player.PropName), x, y, z + 0.2, true, true, true)
    local boneIndex = GetPedBoneIndex(ped, Config['JobList'][index].Object.Player.Bone)
    local xPos, yPos, zPos, xRot, yRot, zRot =
    Config['JobList'][index].Object.Player.Pos[1],
    Config['JobList'][index].Object.Player.Pos[2],
    Config['JobList'][index].Object.Player.Pos[3],
    Config['JobList'][index].Object.Player.Ro[1],
    Config['JobList'][index].Object.Player.Ro[2],
    Config['JobList'][index].Object.Player.Ro[3]

    PropHand = prop
    AttachEntityToEntity(prop, ped, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, true, true, false, true, 1, true)
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for k , v in ipairs(PropList) do 
        DeleteEntity(v)
        ESX.Game.DeleteObject(v)
    end
    ESX.Game.DeleteObject(PropHand)
    ClearPedTasks(PlayerPedId())
    
end)



function SpawnObjects(index)
    if Config['JobList'][index].Object.Types == 'PED' then
        while MaxObject < Config['JobList'][index].Object.MaxObject do
            Citizen.Wait(0)
            RequestModel(GetHashKey(Config['JobList'][index].Object.Job.PropName))
            local Coords = GenerateCrabCoords(Config['JobList'][index].position,Config['JobList'][index].scale)

            Animal = CreatePed(5, GetHashKey(Config['JobList'][index].Object.Job.PropName), Coords.x, Coords.y, Coords.z, 0.0, false, false)
            FreezeEntityPosition(Animal, Config.Freezemodel)
            TaskWanderStandard(Animal, true, true)
            SetEntityAsMissionEntity(Animal, true, true)
            SetEntityHealth(Animal, GetEntityMaxHealth(Animal))
            SetPedCanRagdollFromPlayerImpact(Animal, false)
            TaskWanderInArea(Animal, Coords.x, Coords.y, Coords.z, 1.0, 1.0, 1.0)
            local Notja = (math.random(1.0, 359.0) + 0.5)

            SetEntityHeading(Animal, Notja)
            table.insert(PropList, Animal)
            MaxObject = MaxObject + 1 
            local particleDictionary = "scr_sr_adversary"
            local particleName = "scr_sr_lg_take_zone"
            PlayEffect(Animal,particleDictionary,particleName) 
        end
    else
        while MaxObject < Config['JobList'][index].Object.MaxObject do
            Citizen.Wait(1)
            local CrabCoords = GenerateCrabCoords(Config['JobList'][index].position,Config['JobList'][index].scale)
            local Listobg1 = {
                {Name = Config['JobList'][index].Object.Job.PropName}
            }
            local random_obg1 = math.random(#Listobg1)
            ESX.Game.SpawnLocalObject(Listobg1[random_obg1].Name,CrabCoords,function(object)
                PlaceObjectOnGroundProperly(object)
                FreezeEntityPosition(object, true)
                local ObjectCoords = GetEntityCoords(object)
            
                local particleDictionary = "scr_sr_adversary"
                local particleName = "scr_sr_lg_take_zone"
                PlayEffect(object,particleDictionary,particleName)                     

                table.insert(PropList, object)
                MaxObject = MaxObject + 1
            end)
        end
        if MaxObject >= Config['JobList'][index].Object.MaxObject and Config.Debug then
            --print(('^0[^2%s^0] ^5SpawnObject ^0: ^0(^3%s^0)'):format(ResourceName,MaxObject))
        end
    end
end