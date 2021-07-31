local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPin = {}
Tunnel.bindInterface("vrp_inventoryhud",vRPin)
Proxy.addInterface("vrp_inventoryhud",vRPin)
INclient = Tunnel.getInterface("vrp_inventoryhud","vrp_inventoryhud")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_inventoryhud")

openInventories = {}
Hotbars = {}

PerformHttpRequest("https://raw.githubusercontent.com/marinogabri/vrp_inventoryhud/master/version",function(err,newVersion,headers)
	if err == 200 then
		local curVersion = LoadResourceFile(GetCurrentResourceName(), "version")
		if curVersion ~= newVersion then
			print("^3[vRP Inventory Hud]^7 An update is avaible: https://github.com/marinogabri/vrp_inventoryhud")
		end
	end
end, "GET")

function vRPin.requestItemGive(idname, amount)
	local _source = source
	local user_id = vRP.getUserId({_source})
	local player = vRP.getUserSource({user_id})
	if user_id ~= nil then
	  	-- get nearest player
	  	vRPclient.getNearestPlayer(player,{10},function(nplayer)
			local nuser_id = vRP.getUserId({nplayer})
			if nuser_id ~= nil then
				-- weight check
				local new_weight = vRP.getInventoryWeight({nuser_id})+vRP.getItemWeight({idname})*amount
				if new_weight <= vRP.getInventoryMaxWeight({nuser_id}) then
					if vRP.tryGetInventoryItem({user_id,idname,amount,true}) then
						vRP.giveInventoryItem({nuser_id,idname,amount,true})
		
						vRPclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
						vRPclient.playAnim(nplayer,{true,{{"mp_common","givetake2_a",1}},false})
					end
				else
					vRPclient.notify(player,{"~r~Inventory is full."})
				end
			else
				vRPclient.notify(player,{"~r~No players near you."})
			end
	  	end)
	end
  
	INclient.loadPlayerInventory(player)
end

function vRPin.requestItemUse(idname)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	local choice = vRP.getItemChoices({idname})
	for key, value in pairs(choice) do 
		if key ~= "Give" and key ~= "Trash" then
			local cb = value[1]
			cb(player,key)
			INclient.loadPlayerInventory(player)
		end
	end
end

function vRPin.requestReload(player, ammo)
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		local maxAmmo = vRP.getInventoryItemAmount({user_id, "ammo"})
		if ammo > maxAmmo then 
			ammo = maxAmmo
		end

		if vRP.tryGetInventoryItem({user_id, "ammo", ammo, true}) then
			return ammo
		end
	end
end

function vRPin.requestItemDrop(idname, amount)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.tryGetInventoryItem({user_id,idname,amount,true}) then
		INclient.loadPlayerInventory(player)
	end
end

function vRPin.requestPutHotbar(idname, amount, slot, from)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if user_id ~= nil then
		if from ~= nil then
			Hotbars[user_id][from] = nil
		end

		Hotbars[user_id][slot] = idname

		INclient.loadPlayerInventory(player)
	end
end

function vRPin.requestRemoveHotbar(slot)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if user_id ~= nil then
		Hotbars[user_id][slot] = nil
		INclient.loadPlayerInventory(player)
	end
end

function vRPin.useHotbarItem(slot)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if user_id ~= nil and Hotbars[user_id] ~= nil then
		local idname = Hotbars[user_id][slot]
		if idname ~= nil then
			vRPin.requestItemUse(idname)
			local amount = vRP.getInventoryItemAmount({user_id,idname})
			if amount < 1 then
				Hotbars[user_id][slot] = nil
			end
		end
	end
end

function vRPin.getHotbarItems(player)
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		local hotbarItems = {}
		if Hotbars[user_id] ~= nil then
			for slot, idname in pairs(Hotbars[user_id]) do
				local item_name, description = vRP.getItemDefinition({idname})
				local amount = vRP.getInventoryItemAmount({user_id,idname})
				if amount > 0 then
					table.insert(hotbarItems, {
						label = item_name,
						count = amount,
						description = description,
						name = idname,
						slot = slot
					})
				end
			end
		end

		return hotbarItems
	end
end

function vRPin.closeInventory(type)
	local user_id = vRP.getUserId({source})

	-- if type == 'trunk' then
	-- 	print(type)
	-- 	local strings = splitString(openInventories[user_id], ":")
	-- 	local owner_id = splitString(strings[2], "-")[2]

	-- 	print(owner_id)
	-- 	local ownerSource = vRP.getUserSource({owner_id})
	-- 	vRPclient.vc_closeDoor(nplayer, {vtype,5})

	-- end
	
	vRPclient.stopAnim(source, {false})
	openInventories[user_id] = nil
end

function log(...)
	print(...)
end

function vRPin.inventoryOpened(player)
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		vRPclient.getNearestOwnedVehicle(player,{2},function(ok,vtype,name)
			if ok then
				openTrunk(user_id, player, user_id, name, vtype)
				return
			end
		end)

		vRPclient.getNearestPlayer(player,{2},function(nplayer)
			local nuser_id = vRP.getUserId({nplayer})
			if nuser_id ~= nil then
				vRPclient.isInComa(nplayer,{}, function(inComa)
					vRPclient.isHandcuffed(nplayer,{}, function(isHandcuffed)
						if inComa or isHandcuffed then
							INclient.openInventory(player, {'player'})
							vRPclient.playAnim(player,{true,{{"mini@repair","fixing_a_player",1}},true})
							loadTargetInventory(player, user_id, nplayer)
							return
						end
					end)
				end)
			end
		end)

		INclient.openInventory(player, {'normal'})
	end
end

function vRPin.getInventoryItems(player)
	local user_id = vRP.getUserId({player})
	local data = vRP.getUserDataTable({user_id})
	local weight = vRP.getInventoryWeight({user_id})
	local max_weight = vRP.getInventoryMaxWeight({user_id})
	local items = {}
	local hotbarItems = {}

	if Hotbars[user_id] == nil then
		Hotbars[user_id] = {}
	end

	for k,v in pairs(data.inventory) do 
		local item_name, description, weight = vRP.getItemDefinition({k})
		local found = false

		if item_name ~= nil then
			for slot, idname in pairs(Hotbars[user_id]) do
				if idname == k then
					found = true
					table.insert(hotbarItems, {
						label = item_name,
						count = v.amount,
						description = description,
						name = idname,
						weight = weight,
						slot = slot
					})
				end
			end

			if not found then
				table.insert(items, {
					label = item_name,
					count = v.amount,
					description = description,
					weight = weight,
					name = k
				})
			end
        end
    end

	return items, hotbarItems, weight, max_weight
end

-- Define items
for k,v in pairs(Config.Items) do
	vRP.defInventoryItem({k,v[1],v[2],v[3],v[4]})
end