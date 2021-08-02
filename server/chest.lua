local Chests = {}

local function getChestMaxWeight(id)
    local s = splitString(id, ":")
    local type = s[1]
    if type == "trunk" then
        local vehicle = s[3]
        local maxWeight = Config.Trunks[vehicle]
        if maxWeight ~= nil then
            return maxWeight
        else
            return Config.DefaultTrunkWeight
        end
    elseif type == "glovebox" then
        local vehicle = s[3]
        local maxWeight = Config.Gloveboxes[vehicle]
        if maxWeight ~= nil then
            return maxWeight
        else
            return Config.DefaultGloveboxWeight
        end
    elseif type == "chest" then
        local chestId = s[2]
        local maxWeight = Config.Chests[chestId].maxWeight
        if maxWeight ~= nil then
            return maxWeight
        else
            return Config.DefaultChestMaxWeight
        end
    end
end

function vRPin.putIntoChest(idname, amount)
    local user_id = vRP.getUserId({source})
    local chestname = openInventories[user_id]
    local player = vRP.getUserSource({user_id})
    if chestname ~= nil then
        local items = Chests[chestname] or {}
        local new_weight = vRP.computeItemsWeight({items})+vRP.getItemWeight({idname})*amount
        if new_weight <= getChestMaxWeight(chestname) then
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
        local max_weight = getChestMaxWeight(chestname)
        local items = {}
        for k,v in pairs(Chests[chestname]) do
            local item_name,description,weight = vRP.getItemDefinition({k})
			table.insert(items, {
				label = item_name,
				count = v.amount,
				description = description,
				name = k,
                weight = weight
			})
        end
        INclient.setSecondInventoryItems(player, {items, weight, max_weight})
    else
        vRP.getSData({chestname, function(cdata)
            local rawItems = json.decode(cdata) or {}
            local items = {}
            local weight = vRP.computeItemsWeight({rawItems})
            local max_weight = getChestMaxWeight(chestname)
            for k,v in pairs(rawItems) do
                local item_name,description,weight = vRP.getItemDefinition({k})
                table.insert(items, {
                    label = item_name,
                    count = v.amount,
                    description = description,
                    name = k,
                    weight = weight
                })
            end

            INclient.setSecondInventoryItems(player, {items, weight, max_weight})
            Chests[chestname] = rawItems
        end})
    end
end

function openTrunk(player, user_id, owner_id, vname, vtype)    
    local id = "trunk:user-" .. owner_id .. ":" .. string.lower(vname)
    if isChestFree(id) then
        openInventories[user_id] = id
        INclient.openInventory(player, {"trunk"})
        vRPin.getChestItems(id, player)

        local ownerSource = vRP.getUserSource({owner_id})
        vRPclient.vc_openDoor(ownerSource, {vtype,5})
        vTypes[user_id] = {ownerSource,vtype}
        vRPclient.playAnim(player,{true,{{"mini@repair","fixing_a_player",1}},true})
    else
        vRPclient.notify(player,{"~r~Trunk is busy."})
    end
end

function openGlovebox(player, user_id, owner_id, vname)    
    local id = "glovebox:user-" .. owner_id .. ":" .. string.lower(vname)
    if isChestFree(id) then
        openInventories[user_id] = id
        INclient.openInventory(player, {"glovebox"})
        vRPin.getChestItems(id, player)
        vRPclient.playAnim(player,{true,{{"mini@repair","fixing_a_player",1}},true})
    else
        vRPclient.notify(player,{"~r~Glovebox is busy."})
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

function openChest(user_id, player, id)
    if isChestFree(id) then
        openInventories[user_id] = id
        INclient.openInventory(player, {"chest"})
        vRPin.getChestItems(id, player)
    else
        vRPclient.notify(player,{"~r~Chest is busy."})
    end
end
exports("openChest", openChest)

local function create_chest(user_id,player,name,position,permission)	
    local id = "chest:"..name

	local chest_enter = function(player, area)
		local user_id = vRP.getUserId({player})
		if user_id ~= nil then
			if vRP.hasPermission({user_id, permission}) then
                openChest(user_id, player, id)
			end
		end
	end

	local chest_leave = function(player,area)
		openInventories[user_id] = nil
	end
	
	vRPclient.addMarker(player,{position.x,position.y,position.z-1,0.7,0.7,0.5,0,255,125,125,150})
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

vRP.registerMenuBuilder({"main", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        -- add vehicle entry
        local choices = {}
        choices["[Inv] Ask open trunk"] = {function(player, choice)
            vRPclient.getNearestPlayer(player,{10},function(nplayer)
                local nuser_id = vRP.getUserId({nplayer})
                if nuser_id ~= nil then
                    vRP.request({nplayer,"A player wants to open your trunk",15,function(nplayer,ok)
                        if ok then -- request accepted, open trunk
                            vRPclient.getNearestOwnedVehicle(nplayer,{7},function(ok,vtype,name)
                                if ok then
                                    -- local chestname = "trunk:user-" .. nuser_id .. ":" .. string.lower(name)
                                    -- openChest(user_id, player, chestname)
                                    openTrunk(player, user_id, nuser_id, name, vtype)
                                else
                                    vRPclient.notify(player,{"~r~No vehicles near you"})
                                    vRPclient.notify(nplayer,{"~r~No vehicles near you"})
                                end
                            end)
                        else
                            vRPclient.notify(player,{"~r~Player refused"})
                        end
                    end})
                else
                    vRPclient.notify(player,{"~r~No players near you."})
                end
            end)
        end}

        add(choices)
    end
end})