vRPin = {}
Tunnel.bindInterface("vrp_inventoryhud",vRPin)
vRPserver = Tunnel.getInterface("vRP","vrp_inventoryhud")
INserver = Tunnel.getInterface("vrp_inventoryhud","vrp_inventoryhud")
vRP = Proxy.getInterface("vRP")

local isInInventory = false
local isInHotbar = false

RegisterCommand('inventory',function()
    if not vRP.isInComa() and not vRP.isHandcuffed() then
        local playerId = PlayerId()
        local playerSource = GetPlayerServerId(playerId)
        INserver.inventoryOpened({playerSource})
    end
end)
RegisterKeyMapping('inventory', 'Open Inventory', 'keyboard', 'F1')

for i=1, 5 do 
    RegisterCommand('slot' .. i,function()
        if not vRP.isInComa() and not vRP.isHandcuffed() then
            INserver.useHotbarItem({i})
        end
    end)
    RegisterKeyMapping('slot' .. i, 'Uses the item in slot ' .. i, 'keyboard', i)
end

RegisterCommand('hotbar',function()
    if not isInHotbar and not isInInventory then
        local playerId = PlayerId()
        local playerSource = GetPlayerServerId(playerId)
        INserver.getHotbarItems({playerSource}, function(hotbarItems)
            SendNUIMessage({
                action = "showHotbar",
                hotbarItems = hotbarItems
            })
        end)

        isInHotbar = true
        SetTimeout(2000, function()
            isInHotbar = false
        end)
    end
end)
RegisterKeyMapping('hotbar', 'Check your hotbar items', 'keyboard', 'TAB')

function vRPin.openInventory(type)
    vRPin.loadPlayerInventory()
    isInInventory = true
    SendNUIMessage({
        action = "display",
        type = type 
    })
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(0)
end

function closeInventory(type)
    isInInventory = false
    SendNUIMessage({
        action = "hide"
    })
    SetNuiFocus(false, false)
    INserver.closeInventory({type})
    TriggerScreenblurFadeOut(0)
end

RegisterNUICallback("NUIFocusOff", function(data, cb)
    closeInventory(data.type)
    cb("ok")
end)

RegisterNUICallback("UseItem", function(data, cb)
    INserver.requestItemUse({data.item.name})
    cb("ok")
end)

RegisterNUICallback("DropItem", function(data, cb)
    if IsPedSittingInAnyVehicle(PlayerPedId()) then return end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        INserver.requestItemDrop({data.item.name, tonumber(data.number)})

        if currentWeapon == data.item.name then
            currentWeapon = nil
            RemoveAllPedWeapons(PlayerPedId(), true)
        end
    end
    cb("ok")
end)

RegisterNUICallback("GiveItem", function(data, cb)
    INserver.requestItemGive({data.item.name, tonumber(data.number)})
    cb("ok")
end)

RegisterNUICallback("PutIntoHotbar", function(data, cb)
    INserver.requestPutHotbar({data.item.name, tonumber(data.number), tonumber(data.slot), data.from})
    cb("ok")
end)

RegisterNUICallback("TakeFromHotbar", function(data, cb)
    INserver.requestRemoveHotbar({tonumber(data.slot)})
    cb("ok")
end)

function vRPin.loadPlayerInventory()
    local playerId = PlayerId()
    local playerSource = GetPlayerServerId(playerId)
    INserver.getInventoryItems({playerSource}, function(items, hotbarItems, weight, maxWeight)
        SendNUIMessage({
            action = "setItems",
            itemList = items,
            hotbarItems = hotbarItems,
            weight = weight,
            maxWeight = maxWeight
        })
    end)
end

function vRPin.setSecondInventoryItems(items, weight, maxWeight)
    SendNUIMessage({
        action = "setSecondInventoryItems",
        itemList = items,
        weight = weight,
        maxWeight = maxWeight
    })
end

Citizen.CreateThread(function()
    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
	SetPedConfigFlag(ped, 48, 1)
	SetPedCanSwitchWeapon(ped, 0)
	SetWeaponsNoAutoreload(1)
	SetWeaponsNoAutoswap(1)
    while true do
        Citizen.Wait(1)
        DisableControlAction(0, 37, true) -- TAB
        DisableControlAction(0, 45, true) -- R
        DisableControlAction(0, 140, true) -- Melee attack
        RemoveAllPickupsOfType(14) -- delete weapon drops
        if isInInventory then
            DisableAllControlActions(0)
        end
    end
end)