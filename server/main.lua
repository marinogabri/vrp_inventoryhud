local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPin = {}
Tunnel.bindInterface("vrp_inventoryhud",vRPin)
Proxy.addInterface("vrp_inventoryhud",vRPin)
INclient = Tunnel.getInterface("vrp_inventoryhud","vrp_inventoryhud")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_inventoryhud")

openInventories = {}
local cfg_inventory = module("vrp","cfg/inventory")

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

function vRPin.requestItemDrop(idname, amount)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.tryGetInventoryItem({user_id,idname,amount,true}) then
		-- vRPclient.getPosition(player, {}, function(x,y,z)
		-- 	local dropId = getDropInArea(vector3(x,y,z))
		-- 	if dropId ~= nil then
		-- 		vRPin.putIntoDrop(idname, amount, x, y, z)
		-- 	else
		-- 		vRPin.createDrop(idname, amount, x, y, z)
		-- 	end
		-- end)
		INclient.loadPlayerInventory(player)
	end
end

function vRPin.closeInventory()
	openInventories[vRP.getUserId({source})] = nil
end

function vRPin.getInventoryItems()
	local user_id = vRP.getUserId({source})
	local data = vRP.getUserDataTable({user_id})
	local weight = vRP.getInventoryWeight({user_id})
	local max_weight = vRP.getInventoryMaxWeight({user_id})
	local items = {}
	for k,v in pairs(data.inventory) do 
		local item_name,description = vRP.getItemDefinition({k})
        if item_name ~= nil then
			table.insert(items, {
				label = item_name,
				count = v.amount,
				description = description,
				name = k
			})
        end
    end
	return items, weight, max_weight
end