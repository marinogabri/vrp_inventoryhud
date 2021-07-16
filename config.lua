Config = {}

Config.DefaultChestMaxWeight = 100
Config.ChestSaveTime = 5 -- in minutes

Config.Chests = {
    ["lspd"] = { 
        position ={ 
            x=144.45332336426,
            y=-948.57434082031,
            z=29.75318145752,
        }, 
        permission = "police.vehicle",
        maxWeight = 50 
    },
}

Config.Trunks = {
    ["sultanrs"] = 30
}

-- Shops
-- [shopType] => positions can be more than one 
-- permission if you want to restrict the shop
-- items => item = price
Config.Shops = {
    ["food"] = {
        positions = {
            {
                x = 175.66384887695,
                y = -920.71490478516,
                z = 30.686779022217 
            },
        },
        blipId = 52,
        blipColor = 2,
        items = {
            ["kebab"] = 10,
            ["water"] = 10
        }
    },
    ["weapon"] = {
        positions = {
            {
                x = 177.97305297852,
                y = -916.49786376953,
                z = 30.686786651611 
            },
        },
        blipId = 110,
        blipColor = 1,
        permission = "police.vehicle",
        items = {
            ["wbody|WEAPON_PISTOL"] = 1000,
            ["wammo|WEAPON_PISTOL"] = 100
        }
    },
}