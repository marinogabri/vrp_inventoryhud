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

# Features
- Drag and drop
- Well coded
- Secure
- Chest support
- Trunks are now avaible! Press F1 near your personal vehicle and the trunk will open.
- COMING SOON Shop support
- COMING SOON Drops support

# Preview
- Inventory
![Inventory](https://i.imgur.com/dxgtVWK.png)

- Chest
![Chest](https://i.imgur.com/JR8KOv5.png)

- Trunk
![Trunk](https://i.imgur.com/qV0ZNao.png)

# Credits
Based on [Trsak's inventory](https://github.com/Trsak/esx_inventoryhud)