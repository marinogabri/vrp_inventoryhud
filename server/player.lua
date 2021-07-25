local function getTarget(user_id)
    local id = openInventories[user_id]
    local split = splitString(id, ":")
    if split[1] == 'u' then
        local target = split[2]
        return target
    end

    return nil
end

function loadTargetInventory(player, user_id, target)
    -- local target_id = vRP.getUserId({target})
    local items, hotbarItems, weight, maxWeight = vRPin.getInventoryItems(target)
    -- INclient.openInventory(player, {"player"})
    INclient.setSecondInventoryItems(player, {items, weight, maxWeight})
    openInventories[user_id] = "u:" .. target
end

function vRPin.putIntoPlayer(idname, amount)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    local target = getTarget(user_id)
    local target_id = vRP.getUserId({target})
    if target_id ~= nil then
        local new_weight = vRP.getInventoryWeight({target_id})+vRP.getItemWeight({idname})*amount
        if new_weight <= vRP.getInventoryMaxWeight({target_id}) then
            if vRP.tryGetInventoryItem({user_id,idname,amount,true}) then
                vRP.giveInventoryItem({target_id,idname,amount,true})

                vRPclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
                vRPclient.playAnim(target,{true,{{"mp_common","givetake2_a",1}},false})
            end
        else
            vRPclient.notify(player,{"~r~Target inventory is full."})
        end

        loadTargetInventory(player, user_id, target)
        INclient.loadPlayerInventory(player)
    end
end

function vRPin.takeFromPlayer(idname, amount)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    local target = getTarget(user_id)
    local target_id = vRP.getUserId({target})
    if target_id ~= nil then
        local new_weight = vRP.getInventoryWeight({user_id})+vRP.getItemWeight({idname})*amount
        if new_weight <= vRP.getInventoryMaxWeight({user_id}) then
            if vRP.tryGetInventoryItem({target_id,idname,amount,true}) then
                vRP.giveInventoryItem({user_id,idname,amount,true})

                vRPclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
                vRPclient.playAnim(target,{true,{{"mp_common","givetake2_a",1}},false})
            end
        else
            vRPclient.notify(player,{"~r~Inventory is full."})
        end

        loadTargetInventory(player, user_id, target)
        INclient.loadPlayerInventory(player)
    end
end