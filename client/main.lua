vRPin = {}
Tunnel.bindInterface("vrp_inventoryhud",vRPin)
vRPserver = Tunnel.getInterface("vRP","vrp_inventoryhud")
INserver = Tunnel.getInterface("vrp_inventoryhud","vrp_inventoryhud")
vRP = Proxy.getInterface("vRP")

local isInInventory = false

RegisterCommand('inventory',function()
    if not vRP.isInComa() and not vRP.isHandcuffed() then
        openInventory()
    end
end)
RegisterKeyMapping('inventory', 'Open Inventory', 'keyboard', 'F1')

function openInventory(skip)
    vRPin.loadPlayerInventory()
    isInInventory = true
    SendNUIMessage({
        action = "display",
        type = "normal" 
    })
    SetNuiFocus(true, true)

    if not skip then
        -- check if there is a trunk to open
        local ok, vtype, name = vRP.getNearestOwnedVehicle({5})
        if ok then
            INserver.openTrunk({name})
        end
    end
end

function closeInventory()
    isInInventory = false
    SendNUIMessage({
        action = "hide"
    })
    SetNuiFocus(false, false)
    INserver.closeInventory()
end

RegisterNUICallback("NUIFocusOff", function(data, cb)
    closeInventory()
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
    end
    cb("ok")
end)

RegisterNUICallback("GiveItem", function(data, cb)
    INserver.requestItemGive({data.item.name, tonumber(data.number)})
    cb("ok")
end)

function vRPin.loadPlayerInventory()
    INserver.getInventoryItems({}, function(items, weight, maxWeight)
        SendNUIMessage({
            action = "setItems",
            itemList = items,
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

function vRPin.openSecondInventory(type)
    openInventory(true)
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = type
        }
    )

    SetNuiFocus(true, true)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isInInventory then
            DisableAllControlActions(0)
        end
    end
end)