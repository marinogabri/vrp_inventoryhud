function vRPin.buyItem(idname, amount)
    local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
    if user_id ~= nil then
        local shop = openInventories[user_id]
        if shop ~= nil then
            local price = Config.Shops[shop].items[idname]
            local itemWeight = vRP.getItemWeight({idname})
            local new_weight = vRP.getInventoryWeight({user_id})+itemWeight*amount
            if new_weight <= vRP.getInventoryMaxWeight({user_id}) then
                if vRP.tryPayment({user_id,amount*price}) then
                    vRP.giveInventoryItem({user_id,idname,amount,true})
                    INclient.loadPlayerInventory(player)
                else
                    vRPclient.notify(player,{"~r~Not enough money"})
                end
            else
                vRPclient.notify(player,{"~r~Inventory is full"})
            end
        else
            vRPclient.notify(player,{"~r~Error. Close and open the shop again."})
        end
    end
end

function openShop(user_id, player, shop)
    INclient.openInventory(player, {"shop"})
    openInventories[user_id] = shop
    local items = {}

    for item, price in pairs(Config.Shops[shop].items) do
        local item_name,description,weight = vRP.getItemDefinition({item})
        if item_name ~= nil then
			table.insert(items, {
				label = item_name,
				price = price,
				description = description,
				name = item,
                weight = weight,
                count = 1
			})
        end
    end

    INclient.setSecondInventoryItems(player, {items, 0, 0})
end

local function create_shop(user_id,player,name,position,permission,blipId,blipColor)	
    local id = "shops:".. name .. tostring(position.x)

	local shop_enter = function(player, area)
		local user_id = vRP.getUserId({player})
		if user_id ~= nil then
            if permission ~= nil then
                if vRP.hasPermission({user_id, permission}) then
                    openShop(user_id, player, name)
                end
            else
                openShop(user_id, player, name)
            end
		end
	end

	local shop_leave = function(player,area)
		openInventories[user_id] = nil
	end
	
    vRPclient.addMarker(player,{position.x,position.y,position.z-1,0.7,0.7,0.5,0,255,125,125,150})
    vRPclient.addBlip(player,{position.x,position.y,position.z,blipId,blipColor,name})
	vRP.setArea({player,id,position.x,position.y,position.z,1,1,shop_enter,shop_leave})
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    if first_spawn then
        for k, v in pairs(Config.Shops) do
            for _, pos in pairs(v.positions) do
                create_shop(user_id,source,k,pos,v.permission,v.blipId,v.blipColor)
            end
        end
    end
end)