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
- COMING SOON Trunk support 
- COMING SOON Shop support
- COMING SOON Drops support

# Preview
![Preview](https://i.imgur.com/UHTKplj.png)
