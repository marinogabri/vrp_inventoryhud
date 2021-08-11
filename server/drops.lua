local Drops = {}
local lastId = 1

function getDropId(user_id)
    local id = openInventories[user_id]
    local split = splitString(id, ":")
    if split[1] == 'drop' then
        if Drops[tonumber(split[2])] ~= nil then
            return tonumber(split[2])
        end
    end

    return nil
end

function getNearestDrop(pos)
    local nearestId = nil

    for id, drop in pairs(Drops) do
        if #(pos - drop.position) < 5 then
            nearestId = id
        end
    end

    if nearestId == nil then
        nearestId = createNewDrop(pos)
    end

    return nearestId
end

function createNewDrop(pos)
    local id = lastId

    while Drops[id] ~= nil do
        id = id + 1
    end

    lastId = id

    Drops[id] = {
        position = pos,
        items = {},
        markerId = nil
    }

    return id
end

function loadDropItems(player, dropId)
    local items = {}
    for k,v in pairs(Drops[dropId].items) do
        local item_name,description,weight = vRP.getItemDefinition({k})
        table.insert(items, {
            label = item_name,
            count = v.amount,
            description = description,
            name = k,
            weight = weight
        })
    end
    INclient.setSecondInventoryItems(player, {items, 0, 0})
end

function refreshDropItems(dropId)
    for user_id, inv in pairs(openInventories) do
        if string.find(inv, "drop") then
            local actualDropId = getDropId(user_id)
            if actualDropId == dropId then
                local player = vRP.getUserSource({user_id})
                loadDropItems(player, dropId)
            end
        end
    end
    
    if next(Drops[dropId].items) == nil then
        Drops[dropId] = nil
    end

    INclient.setDrops(-1, {Drops})
end

function vRPin.openDrop(player, user_id)
    local pos = GetEntityCoords(GetPlayerPed(player))
    local dropId = getNearestDrop(pos)
    if dropId ~= nil then
        openInventories[user_id] = "drop:" .. dropId

        INclient.openInventory(player, {"drop"})
        loadDropItems(player, dropId)
    end
end

function vRPin.putIntoDrop(idname, amount)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    local dropId = getDropId(user_id)
    if dropId ~= nil then
        local items = Drops[dropId].items or {}

        if amount >= 0 and vRP.tryGetInventoryItem({user_id, idname, amount, true}) then
            local citem = items[idname]

            if citem ~= nil then
                citem.amount = citem.amount+amount
            else
                items[idname] = {amount=amount}
            end

            Drops[dropId].items = items
        end

        refreshDropItems(dropId)
        INclient.loadPlayerInventory(player)
    end
end

function vRPin.takeFromDrop(idname, amount)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    local dropId = getDropId(user_id)
    if dropId ~= nil then
        local items = Drops[dropId].items or {}
        local citem = items[idname]
        if amount >= 0 and amount <= citem.amount then
            vRP.giveInventoryItem({user_id, idname, amount, true})
            citem.amount = citem.amount-amount

            if citem.amount <= 0 then
                items[idname] = nil -- remove item entry
            end

            Drops[dropId].items = items
        end

        refreshDropItems(dropId)
        INclient.loadPlayerInventory(player)
    end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    if first_spawn then
        INclient.setDrops(source, {Drops})
    end
end)