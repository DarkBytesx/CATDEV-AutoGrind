local Token = nil
local ResourceName = GetCurrentResourceName()
ESX = exports["es_extended"]:getSharedObject()

local webhookURL = Config.DiscordWebhook -- Replace with your actual webhook URL

local function DiscordLog(playerName, itemName, itemLabel, itemCount, logType)
    if not webhookURL or webhookURL == '' then
        print('DiscordLog: Missing webhook URL')
        return
    end

    local logTitle = (logType == 'Bonus') and 'Bonus Item Received' or 'Item Received'
    local logColor = (logType == 'Bonus') and 65280 or 16711680 -- Green for bonus, Red for normal item

    local data = {
        username = 'Log Bot',
        embeds = {
            {
                title = logTitle,
                description = ('Player **%s** received **%s** x **%d**'):format(playerName, itemLabel, itemCount),
                color = logColor,
                fields = {
                    {
                        name = 'Item Name',
                        value = '```' .. itemName .. '```',
                        inline = true
                    },
                    {
                        name = 'Amount',
                        value = '```' .. itemCount .. '```',
                        inline = true
                    }
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) 
        if err ~= 200 then 
           -- print('DiscordLog: Failed to send log, HTTP Error:', err)
        end 
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

function RandomStr()
    local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local lowerCase = "abcdefghijklmnopqrstuvwxyz"
    local numbers = "0123456789"

    local characterSet = upperCase .. lowerCase .. numbers

    local keyLength = 32
    local output = ""

    for	i = 1, keyLength do
        local rand = math.random(#characterSet)
        output = output .. string.sub(characterSet, rand, rand)
    end
    return output
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Token = RandomStr()
end)

AddEventHandler('esx:playerLoaded', function(xplayerId, xPlayer)
    local playerId = tonumber(xplayerId)
    TriggerClientEvent(ResourceName..':Setting', playerId,Config['JobList_Sv'],Token)
end)

RegisterServerEvent(ResourceName..':ConfigSetting')
AddEventHandler(ResourceName..':ConfigSetting', function()
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    TriggerClientEvent(ResourceName..':Setting', playerId,Config['JobList_Sv'],Token)

    if Config.Debug then
        print(('^0[^2%s^0]^0[^8%s^0] ^5Token Setting^0: ^3%s'):format(ResourceName,xPlayer.getName(),Token))
    end
end)

RegisterServerEvent(ResourceName..':Giveitem_Sv')
AddEventHandler(ResourceName..':Giveitem_Sv', function(index, Tokenx)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if Tokenx ~= Token then 
        xDFunction.BanPlayer(xPlayer, 'token_erroneous')
        return
    end
    if index == nil then 
        xDFunction.BanPlayer(xPlayer, 'token_erroneous')
        return
    end

    Data = Config['JobList_Sv'][index]
    local xItem = xPlayer.getInventoryItem(Data.Rewards.ItemName)
    local xItemCount = math.random(Data.Rewards.ItemCount[1], Data.Rewards.ItemCount[2])

    if exports.ox_inventory:CanCarryItem(playerId, xItem.name, xItemCount) then
        xPlayer.addInventoryItem(xItem.name, tonumber(xItemCount))
        GetItemToInventory(xPlayer, xItem, xItemCount, '')

        if Config['DiscordLog'] then
            DiscordLog(xPlayer.getName(), xItem.name, xItem.label, xItemCount, 'Item')
        end
    else
        TriggerClientEvent(ResourceName..':InventoryFully', playerId)
        return
    end

    if Data.Bonus ~= nil then
        for k, v in pairs(Data.Bonus) do
            if math.random(1, 100) <= v.Percent then
                local xBonusCount = math.random(v.ItemCount[1], v.ItemCount[2])

                if exports.ox_inventory:CanCarryItem(playerId, v.ItemName, xBonusCount) then
                    xPlayer.addInventoryItem(v.ItemName, tonumber(xBonusCount))
                    GetItemToInventory(xPlayer, v, xBonusCount, 'bonus')

                    if Config['DiscordLog'] then
                        DiscordLog(xPlayer.getName(), v.ItemName, v.label, xBonusCount, 'Bonus')
                    end
                else
                    TriggerClientEvent(ResourceName..':InventoryFully', playerId)
                    return
                end
            end
        end
    end
end)

-- RegisterServerEvent(ResourceName..':BreakEquipment')
-- AddEventHandler(ResourceName..':BreakEquipment', function(equipmentItem)
--     local playerId = source
--     local xPlayer = ESX.GetPlayerFromId(playerId)

--     if not equipmentItem then return end

--     local breakChance = 30 

--     if math.random(1, 100) <= breakChance then
--         if exports.ox_inventory:Search(playerId, 'count', equipmentItem) > 0 then
--             exports.ox_inventory:RemoveItem(playerId, equipmentItem, 1)
--             TriggerClientEvent('ox_lib:notify', playerId, { 
--                 title = 'Equipment Broke',
--                 description = ('Your %s broke during use!'):format(equipmentItem),
--                 position = 'center-right',
--                 type = 'error' 
--             })
--         end
--     end
-- end)

function GetItemToInventory(xPlayer, xItem, xItemCount, types)
    if types == 'bonus' then
        if Config.Debug then
            print(('^0[^2%s^0]^0[^8%s^0] ^5GetItemBonus^0: ^3%s ^5Amount: ^3%s'):format(ResourceName, xPlayer.getName(), xItem.name, xItemCount))
        end
    else
        if Config.Debug then
            print(('^0[^2%s^0]^0[^8%s^0] ^5GetItem^0: ^3%s ^5Amount: ^3%s'):format(ResourceName, xPlayer.getName(), xItem.name, xItemCount))
        end
    end
end

function InventoryFull(xPlayer,xItem)
    if Config.Debug then
        print(('^0[^2%s^0]^0[^8%s^0] ^5ItemFully^0: ^3%s ^5Amount: ^3%s'):format(ResourceName,xPlayer.getName(),xItem.name,xItem.count))
    end
    TriggerClientEvent(ResourceName..':InventoryFully',xPlayer.source)

    xDFunction.Notify(xPlayer,'InvFuully','fullx')
end

CreateThread(function()
    Citizen.Wait(10)
    print([[
    
░█████╗░░█████╗░████████╗██╗░░██╗
██╔══██╗██╔══██╗╚══██╔══╝╚██╗██╔╝
██║░░╚═╝███████║░░░██║░░░░╚███╔╝░
██║░░██╗██╔══██║░░░██║░░░░██╔██╗░
╚█████╔╝██║░░██║░░░██║░░░██╔╝╚██╗
░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝

██████╗░███████╗██╗░░░██╗███████╗██╗░░░░░░█████╗░██████╗░███╗░░░███╗███████╗███╗░░██╗████████╗
██╔══██╗██╔════╝██║░░░██║██╔════╝██║░░░░░██╔══██╗██╔══██╗████╗░████║██╔════╝████╗░██║╚══██╔══╝
██║░░██║█████╗░░╚██╗░██╔╝█████╗░░██║░░░░░██║░░██║██████╔╝██╔████╔██║█████╗░░██╔██╗██║░░░██║░░░
██║░░██║██╔══╝░░░╚████╔╝░██╔══╝░░██║░░░░░██║░░██║██╔═══╝░██║╚██╔╝██║██╔══╝░░██║╚████║░░░██║░░░
██████╔╝███████╗░░╚██╔╝░░███████╗███████╗╚█████╔╝██║░░░░░██║░╚═╝░██║███████╗██║░╚███║░░░██║░░░
╚═════╝░╚══════╝░░░╚═╝░░░╚══════╝╚══════╝░╚════╝░╚═╝░░░░░╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚══╝░░░╚═╝░░░

]])
end)
