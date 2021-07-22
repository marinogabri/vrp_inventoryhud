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

local ammo_choices = {}
ammo_choices["Load"] = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        local currentAmmo = vRP.getInventoryItemAmount({user_id, "ammo"})
        if vRP.tryGetInventoryItem({user_id,"ammo",currentAmmo}) then
            INclient.setAmmo(player, {currentAmmo})
        end
    end
end}

Config.Items = {
    ["ammo"] = {"Ammo", "Ammo for your gun", function(args) return ammo_choices end,1},
    ["WEAPON_KNIFE"] = {"Knife", "A simple knife", nil, 1},
    ["WEAPON_FLASHLIGHT"] = {"Flashlight", "A simple flashlight", nil, 1},
    ["WEAPON_NIGHTSTICK"] = {"Nightstick", "A simple nightstick", nil, 1}, 
    ["WEAPON_HAMMER"] = {"Hammer", "A simple hammer", nil, 1},
    ["WEAPON_BAT"] = {"Bat", "A simple bat", nil, 1},
    ["WEAPON_GOLFCLUB"] = {"Golfclub bat", "A simple golf bat", nil, 1},
    ["WEAPON_CROWBAR"] = {"Crowbar", "A simple crowbar", nil, 1},
    ["WEAPON_PISTOL"] = {"Pistol", "A simple pistol", nil, 1},
    ["WEAPON_COMBATPISTOL"] = {"Combat pistol", "A combat pistol", nil, 1},
    ["WEAPON_APPISTOL"] = {"AP Pistol", "A AP Pistol", nil, 1},
    ["WEAPON_PISTOL50"] = {"Pistol .50", "A .50 pistol", nil, 1},
    ["WEAPON_MICROSMG"] = {"Micro SMG", "A micro smg", nil, 1},
    ["WEAPON_SMG"] = {"SMG", "A SMG", nil, 1},
    ["WEAPON_COMBATMG"] = {"Combat SMG", "A combat SMG", nil, 1},
    ["WEAPON_ASSAULTSMG"] = {"Assault SMG", "An assault SMG", nil, 1},
    ["WEAPON_ASSAULTRIFLE"] = {"Assault rifle", "An assault rifle", nil, 1},
    ["WEAPON_CARBINERIFLE"] = {"Caribine rifle", "A simple caribine", nil, 1},
    ["WEAPON_ADVANCEDRIFLE"] = {"Advanced rifle", "An advanced rifle", nil, 1},
    ["WEAPON_MG"] = {"MG", "A simple MG", nil, 1},
    ["WEAPON_PUMPSHOTGUN"] = {"Pump shotgun", "A pump shotgun", nil, 1},
    ["WEAPON_SAWNOFFSHOTGUN"] = {"Sawnoff shotgun", "A sawnoff shotgun", nil, 1},
    ["WEAPON_ASSAULTSHOTGUN"] = {"Assault shotgun", "An assault shotgun", nil, 1},
    ["WEAPON_BULLPUPSHOTGUN"] = {"Bullpup shotgun", "A bullpup shotgun", nil, 1},
    ["WEAPON_STUNGUN"] = {"Stungun", "A simple stungun", nil, 1},
    ["WEAPON_SNIPERRIFLE"] = {"Sniper rifle", "A sniper rifle", nil, 1},
    ["WEAPON_HEAVYSNIPER"] = {"Heavy sniper", "A heavy sniper", nil, 1},
    ["WEAPON_REMOTESNIPER"] = {"Remote sniper", "A remote sniper", nil, 1},
    ["WEAPON_GRENADELAUNCHER"] = {"Grenade launcher", "A grenade launcher", nil, 1},
    ["WEAPON_GRENADELAUNCHER_SMOKE"] = {"Grenade launcher smoke", "A simple smoke", nil, 1},
    ["WEAPON_RPG"] = {"RPG", "A big RPG", nil, 1},
    ["WEAPON_PASSENGER_ROCKET"] = {"Passenger rocket", "A simple passenger rocket", nil, 1},
    ["WEAPON_AIRSTRIKE_ROCKET"] = {"Airstrike rocket", "A simple airstrike rocket", nil, 1},
    ["WEAPON_STINGER"] = {"Stinger", "A simple stinger", nil, 1},
    ["WEAPON_MINIGUN"] = {"Minigun", "A simple minigun", nil, 1},
    ["WEAPON_GRENADE"] = {"Grenade", "A simple grenade", nil, 1},
    ["WEAPON_STICKYBOMB"] = {"Stickybomb", "A simple stickybomb", nil, 1},
    ["WEAPON_SMOKEGRENADE"] = {"Smokegrenade", "A simple smoke grenade", nil, 1},
    ["WEAPON_BZGAS"] = {"BZGAS", "A simple bzgas", nil, 1},
    ["WEAPON_MOLOTOV"] = {"Molotov", "A simple molotov", nil, 1},
    ["WEAPON_FIREEXTINGUISHER"] = {"Fire extinguisher", "A simple fire extinguisher", nil, 1},
    ["WEAPON_PETROLCAN"] = {"Petrol can", "A simple petrolcan", nil, 1},
    ["WEAPON_DIGISCANNER"] = {"Digiscanner", "A simple digiscanner", nil, 1},
    ["WEAPON_BRIEFCASE"] = {"Briefcase", "A simple briefcase", nil, 1},
    ["WEAPON_BRIEFCASE_02"] = {"Briefcase 2", "A simple briefcase 2", nil, 1},
    ["WEAPON_BALL"] = {"Ball", "A simple ball", nil, 1},
    ["WEAPON_FLARE"] = {"Flare", "A simple flare", nil, 1}
}