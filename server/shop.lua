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

    INclient.setSecondInventoryItems(player, {items, 0, 0, shop})
end

function vRPin.openShop(name, pos)
    local user_id = vRP.getUserId({source})
    if user_id then
        if Config.Shops[name].permission and vRP.hasPermission({user_id, Config.Shops[name].permission}) or Config.Shops[name].permission == nil then
            local id = "shops:".. name .. tostring(pos.x)
            openShop(user_id, source, name)
        end
    end
end