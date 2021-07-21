# vrp_inventoryhud
Drag and drop inventory hud for vRP 1

# Installation

### Requirements:

- [Dunko vRP](https://github.com/DunkoUK/dunko_vrp)

### How to Install:
* Download the resource,place it your `/resource` folder.
* Start the resource in your `server.cfg`.
* Go to `vrp/modules/inventory.lua` and replace from line 246 to line 250 with this code:

```lua
    local player = vRP.getUserSource(user_id)
    if vRP.computeItemsWeight(data.inventory) > 15 then
        TriggerClientEvent("equipBackpack", player)
    else
        TriggerClientEvent("removeBackpack", player)
    end
```
* Go to `vrp/modules/inventory.lua` and delete lines 168-169:

```lua
    choices[lang.inventory.give.title()] = {function(player,choice) ch_give(idname, player, choice) end, lang.inventory.give.description()}
    choices[lang.inventory.trash.title()] = {function(player, choice) ch_trash(idname, player, choice) end, lang.inventory.trash.description()}
```

# Features
- Drag and drop
- Well coded
- Secure
- Chest support
- Trunks are now avaible! Press F1 near your personal vehicle and the trunk will open. You can also ask to open the trunk to the nearest player!
- Shops are now avaible!
- You can now search items. Only avaible in the secondary inventory 
- Now you can loot in coma players by pressing F1!
- COMING SOON: Hotbar

# Preview
- Inventory
![Inventory](https://i.imgur.com/dxgtVWK.png)

- Chest
![Chest](https://i.imgur.com/JR8KOv5.png)

- Trunk
![Trunk](https://i.imgur.com/qV0ZNao.png)

- Shop
![Shop](https://i.imgur.com/dibpc81.png)

# Credits
Based on [Trsak's inventory](https://github.com/Trsak/esx_inventoryhud)