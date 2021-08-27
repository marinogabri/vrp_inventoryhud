# vrp_inventoryhud
Drag and drop inventory hud for vRP 1

You can support me on buy me a coffee.<br>
[<img src="https://i.imgur.com/GfsNHfa.png" width="200" />](https://www.buymeacoffee.com/marinogabri)

# Installation

### Requirements:

- [Dunko vRP](https://github.com/DunkoUK/dunko_vrp)

### How to Install:
* Download the resource,place it your `/resource` folder.
* Start the resource in your `server.cfg`.
* Replace `vrp/modules/inventory.lua` with the following one:

<details>
<summary>inventory.lua</summary>
<br>

```lua
    local lang = vRP.lang
    local cfg = module("cfg/inventory")

    -- this module define the player inventory (lost after respawn, as wallet)

    vRP.items = {}

    -- define an inventory item (call this at server start) (parametric or plain text data)
    -- idname: unique item name
    -- name: display name or genfunction
    -- description: item description (html) or genfunction
    -- choices: menudata choices (see gui api) only as genfunction or nil
    -- weight: weight or genfunction
    --
    -- genfunction are functions returning a correct value as: function(args) return value end
    -- where args is a list of {base_idname,arg,arg,arg,...}
    function vRP.defInventoryItem(idname,name,description,choices,weight)
        if weight == nil then
            weight = 0
        end

        local item = {name=name,description=description,choices=choices,weight=weight}
        vRP.items[idname] = item
    end

    function vRP.computeItemName(item,args)
        if type(item.name) == "string" then return item.name
        else return item.name(args) end
    end

    function vRP.computeItemDescription(item,args)
        if type(item.description) == "string" then return item.description
        else return item.description(args) end
    end

    function vRP.computeItemChoices(item,args)
        if item.choices ~= nil then
            return item.choices(args)
        else
            return {}
        end
    end

    function vRP.computeItemWeight(item,args)
        if type(item.weight) == "number" then return item.weight
        else return item.weight(args) end
    end

    function vRP.parseItem(idname)
        return splitString(idname,"|")
    end

    -- return name, description, weight
    function vRP.getItemDefinition(idname)
        local args = vRP.parseItem(idname)
        local item = vRP.items[args[1]]
        if item ~= nil then
            return vRP.computeItemName(item,args), vRP.computeItemDescription(item,args), vRP.computeItemWeight(item,args)
        end

        return nil,nil,nil
    end

    function vRP.getItemName(idname)
        local args = vRP.parseItem(idname)
        local item = vRP.items[args[1]]
        if item ~= nil then return vRP.computeItemName(item,args) end
        return args[1]
    end

    function vRP.getItemDescription(idname)
        local args = vRP.parseItem(idname)
        local item = vRP.items[args[1]]
        if item ~= nil then return vRP.computeItemDescription(item,args) end
        return ""
    end

    function vRP.getItemChoices(idname)
        local args = vRP.parseItem(idname)
        local item = vRP.items[args[1]]
        local choices = {}
        if item ~= nil then
            -- compute choices
            local cchoices = vRP.computeItemChoices(item,args)
            if cchoices then -- copy computed choices
            for k,v in pairs(cchoices) do
                choices[k] = v
            end
        end
    end

        return choices
    end

    function vRP.getItemWeight(idname)
        local args = vRP.parseItem(idname)
        local item = vRP.items[args[1]]
        if item ~= nil then return vRP.computeItemWeight(item,args) end
        return 0
    end

    -- compute weight of a list of items (in inventory/chest format)
    function vRP.computeItemsWeight(items)
        local weight = 0

        for k,v in pairs(items) do
            local iweight = vRP.getItemWeight(k)
            weight = weight+iweight*v.amount
        end

        return weight
    end

    -- add item to a connected user inventory
    function vRP.giveInventoryItem(user_id,idname,amount,notify)
        if notify == nil then notify = true end -- notify by default

        local data = vRP.getUserDataTable(user_id)
        if data and amount > 0 then
            local entry = data.inventory[idname]
            if entry then -- add to entry
            entry.amount = entry.amount+amount
            else -- new entry
            data.inventory[idname] = {amount=amount}
            end

            -- notify
            if notify then
                local player = vRP.getUserSource(user_id)
                if player ~= nil then
                    TriggerClientEvent("vrp_inventoryhud:notify", player, {name = idname, label = vRP.getItemName(idname), count = amount }, "Added")
                end
            end
        end
    end

    -- try to get item from a connected user inventory
    function vRP.tryGetInventoryItem(user_id,idname,amount,notify)
        if notify == nil then notify = true end -- notify by default

        local data = vRP.getUserDataTable(user_id)
        if data and amount > 0 then
            local entry = data.inventory[idname]
            if entry and entry.amount >= amount then -- add to entry
                entry.amount = entry.amount-amount

                -- remove entry if <= 0
                if entry.amount <= 0 then
                    data.inventory[idname] = nil 
                end

                -- notify
                if notify then
                    local player = vRP.getUserSource(user_id)
                    if player ~= nil then
                    TriggerClientEvent("vrp_inventoryhud:notify", player, {name = idname, label = vRP.getItemName(idname), count = amount }, "Given")
                    end
                end

                return true
            else
                -- notify
                if notify then
                    local player = vRP.getUserSource(user_id)
                    if player ~= nil then
                        local entry_amount = 0
                        if entry then entry_amount = entry.amount end
                            TriggerClientEvent("vrp_inventoryhud:notify", player, {name = idname, label = vRP.getItemName(idname), count = amount-entry_amount }, "Missing")
                    end
                end
            end
        end

        return false
    end

    -- get user inventory amount of item
    function vRP.getInventoryItemAmount(user_id,idname)
        local data = vRP.getUserDataTable(user_id)
        if data and data.inventory then
            local entry = data.inventory[idname]
            if entry then
                return entry.amount
            end
        end

        return 0
    end

    -- return user inventory total weight
    function vRP.getInventoryWeight(user_id)
        local data = vRP.getUserDataTable(user_id)
        if data and data.inventory then
            return vRP.computeItemsWeight(data.inventory)
        end

        return 0
    end

    -- return maximum weight of the user inventory
    function vRP.getInventoryMaxWeight(user_id)
        return math.floor(vRP.expToLevel(vRP.getExp(user_id, "physical", "strength")))*cfg.inventory_weight_per_strength
    end

    -- clear connected user inventory
    function vRP.clearInventory(user_id)
        local data = vRP.getUserDataTable(user_id)
        if data then
            data.inventory = {}
        end
    end

    -- init inventory
    AddEventHandler("vRP:playerJoin", function(user_id,source,name,last_login)
        local data = vRP.getUserDataTable(user_id)
        if data.inventory == nil then
            data.inventory = {}
        end
    end)

    -- open a chest by name
    -- cb_close(): called when the chest is closed (optional)
    -- cb_in(idname, amount): called when an item is added (optional)
    -- cb_out(idname, amount): called when an item is taken (optional)
    function vRP.openChest(source, name, max_weight, cb_close, cb_in, cb_out)
        local user_id = vRP.getUserId(source)
        if user_id ~= nil then
            exports["vrp_inventoryhud"]:openChest(user_id, source, name)
        end
    end

```

</details>


# Features
- Hotbar
- Glovebox
- Drops
- Drag and drop
- Well coded
- Secure
- Chest support
- Trunks: Press F1 near your personal vehicle and the trunk will open. You can also ask to open the trunk to the nearest player!
- Shops
- You can now search items. Only avaible in the secondary inventory 
- Now you can loot in coma players by pressing F1!

# Preview
- Inventory
![Inventory](https://i.imgur.com/442Prp7.png)

- Hotbar
![Hotbar](https://i.imgur.com/cLVHPOi.png)

- Chest
![Chest](https://i.imgur.com/EGC3Wpc.png)

- Trunk
![Trunk](https://i.imgur.com/F32J52H.png)

- Shop
![Shop](https://i.imgur.com/y2y5tSi.png)

# Credits
Based on [Trsak's inventory](https://github.com/Trsak/esx_inventoryhud)