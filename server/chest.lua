local Chests = {}

function vRPin.putIntoChest(idname, amount)
    local user_id = vRP.getUserId({source})
    local chestname = openInventories[user_id]
    local player = vRP.getUserSource({user_id})
    if chestname ~= nil then
        local items = Chests[chestname] or {}
        local new_weight = vRP.computeItemsWeight({items})+vRP.getItemWeight({idname})*amount
        if new_weight <= Config.ChestMaxWeight then
            if amount >= 0 and vRP.tryGetInventoryItem({user_id, idname, amount, true}) then
                local citem = items[idname]

                if citem ~= nil then
                    citem.amount = citem.amount+amount
                else
                    items[idname] = {amount=amount}
                end

                Chests[chestname] = items
            end
        else
            vRPclient.notify(player,{"~r~Chest is full"})
        end

        Wait(20)
        vRPin.getChestItems(chestname, player)
        INclient.loadPlayerInventory(player)
    end
end

function vRPin.takeFromChest(idname, amount)
    local user_id = vRP.getUserId({source})
    local chestname = openInventories[user_id]
    local player = vRP.getUserSource({user_id})
    if chestname ~= nil then
        local items = Chests[chestname] or {}
        local citem = items[idname]
        if amount >= 0 and amount <= citem.amount then
            local new_weight = vRP.getInventoryWeight({user_id})+vRP.getItemWeight({idname})*amount
            if new_weight <= vRP.getInventoryMaxWeight({user_id}) then
                vRP.giveInventoryItem({user_id, idname, amount, true})
                citem.amount = citem.amount-amount

                if citem.amount <= 0 then
                    items[idname] = nil -- remove item entry
                end

                Chests[chestname] = items
            else
                vRPclient.notify(player,{"~r~Inventory is full"})
            end
        end

        Wait(20)
        vRPin.getChestItems(chestname, player)
        INclient.loadPlayerInventory(player)
    end
end

function vRPin.getChestItems(chestname, player)
    if Chests[chestname] then
        local weight = vRP.computeItemsWeight({Chests[chestname]})
        local max_weight = Config.ChestMaxWeight
        local items = {}
        for k,v in pairs(Chests[chestname]) do
            local item_name,description = vRP.getItemDefinition({k})
			table.insert(items, {
				label = item_name,
				count = v.amount,
				description = description,
				name = k
			})
        end
        INclient.setSecondInventoryItems(player, {items, weight, max_weight})
    else
        vRP.getSData({chestname, function(cdata)
            local rawItems = json.decode(cdata) or {}
            local items = {}
            local weight = vRP.computeItemsWeight({rawItems})
            local max_weight = Config.ChestMaxWeight
            for k,v in pairs(rawItems) do
                local item_name,description = vRP.getItemDefinition({k})
                table.insert(items, {
                    label = item_name,
                    count = v.amount,
                    description = description,
                    name = k
                })
            end

            INclient.setSecondInventoryItems(player, {items, weight, max_weight})
            Chests[chestname] = rawItems
        end})
    end
end


function isChestFree(id)
    for user_id, chestId in pairs(openInventories) do
        if chestId == id then
            return false
        end
    end

    return true
end

local function create_chest(user_id,player,name,position,permission)	
    local id = "chest:"..name

	local chest_enter = function(player, area)
		local user_id = vRP.getUserId({player})
		if user_id ~= nil then
			if vRP.hasPermission({user_id, permission}) then
				if isChestFree(id) then
                    INclient.openChestInventory(player, {})
                    openInventories[user_id] = id
                    vRPin.getChestItems(id, player)
                else
                    vRPclient.notify(player,{"~r~Chest is busy."})
                end
			end
		end
	end

	local chest_leave = function(player,area)
		openInventories[user_id] = nil
	end
	
	vRPclient.setNamedMarker(player,{id,position.x,position.y,position.z-1,0.7,0.7,0.5,0,148,255,125,150})
	vRP.setArea({player,id,position.x,position.y,position.z,1,1.5,chest_enter,chest_leave})
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    if first_spawn then
        for k, v in pairs(Config.Chests) do
            create_chest(user_id,source,k,v.position,v.permission)
        end
    end
end)

-- tasks
function task_save_chests()
    
    for k,v in pairs(Chests) do
        vRP.setSData({k,json.encode(v)})
    end
    
    print("[vRP INVENTORY HUD] Chests saved.")
    SetTimeout(Config.ChestSaveTime*60*1000, task_save_chests)
end
task_save_chests()