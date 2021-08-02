Config = {}

Config.DefaultChestMaxWeight = 100
Config.ChestSaveTime = 5 -- in minutes

Config.Chests = {
    ["lspd"] = { 
        position = { 
            x = 144.45332336426,
            y = -948.57434082031,
            z = 29.75318145752,
        }, 
        permission = "police.vehicle",
        maxWeight = 50 
    },
}

Config.DefaultTrunkWeight = 30
Config.Trunks = {
    ["sultanrs"] = 30
}

Config.DefaultGloveboxWeight = 5
Config.Gloveboxes = {
    ["sultanrs"] = 8
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
            ["WEAPON_PISTOL"] = 1000,
            ["ammo"] = 100
        }
    },
}

local function equip(weapon)
    local fequp = function(args)
        local choices = {}
        choices["Equip"] = {function(player,choice)
            local user_id = vRP.getUserId({player})
            if user_id ~= nil then
                INclient.equipWeapon(player, {weapon})
            end
        end}
  
        return choices
    end
  
    return fequp
end

Config.Items = {
    ["ammo"] = {"Ammo", "Ammo for your gun", nil,1},
    ["WEAPON_KNIFE"] = {"Knife", "A simple knife", equip('WEAPON_KNIFE'), 1},
    ["WEAPON_FLASHLIGHT"] = {"Flashlight", "A simple flashlight", equip('WEAPON_FLASHLIGHT'), 1},
    ["WEAPON_NIGHTSTICK"] = {"Nightstick", "A simple nightstick", equip('WEAPON_NIGHTSTICK'), 1}, 
    ["WEAPON_HAMMER"] = {"Hammer", "A simple hammer", equip('WEAPON_HAMMER'), 1},
    ["WEAPON_BAT"] = {"Bat", "A simple bat", equip('WEAPON_BAT'), 1},
    ["WEAPON_GOLFCLUB"] = {"Golfclub bat", "A simple golf bat", equip('WEAPON_GOLFCLUB'), 1},
    ["WEAPON_CROWBAR"] = {"Crowbar", "A simple crowbar", equip('WEAPON_CROWBAR'), 1},
    ["WEAPON_PISTOL"] = {"Pistol", "A simple pistol", equip('WEAPON_PISTOL'), 1},
    ["WEAPON_COMBATPISTOL"] = {"Combat pistol", "A combat pistol", equip('WEAPON_COMBATPISTOL'), 1},
    ["WEAPON_APPISTOL"] = {"AP Pistol", "A AP Pistol", equip('WEAPON_APPISTOL'), 1},
    ["WEAPON_PISTOL50"] = {"Pistol .50", "A .50 pistol", equip('WEAPON_PISTOL50'), 1},
    ["WEAPON_MICROSMG"] = {"Micro SMG", "A micro smg", equip('WEAPON_MICROSMG'), 1},
    ["WEAPON_SMG"] = {"SMG", "A SMG", equip('WEAPON_SMG'), 1},
    ["WEAPON_COMBATMG"] = {"Combat SMG", "A combat SMG", equip('WEAPON_COMBATMG'), 1},
    ["WEAPON_ASSAULTSMG"] = {"Assault SMG", "An assault SMG", equip('WEAPON_ASSAULTSMG'), 1},
    ["WEAPON_ASSAULTRIFLE"] = {"Assault rifle", "An assault rifle", equip('WEAPON_ASSAULTRIFLE'), 1},
    ["WEAPON_CARBINERIFLE"] = {"Caribine rifle", "A simple caribine", equip('WEAPON_CARBINERIFLE'), 1},
    ["WEAPON_ADVANCEDRIFLE"] = {"Advanced rifle", "An advanced rifle", equip('WEAPON_ADVANCEDRIFLE'), 1},
    ["WEAPON_MG"] = {"MG", "A simple MG", equip('WEAPON_MG'), 1},
    ["WEAPON_PUMPSHOTGUN"] = {"Pump shotgun", "A pump shotgun", equip('WEAPON_PUMPSHOTGUN'), 1},
    ["WEAPON_SAWNOFFSHOTGUN"] = {"Sawnoff shotgun", "A sawnoff shotgun", equip('WEAPON_SAWNOFFSHOTGUN'), 1},
    ["WEAPON_ASSAULTSHOTGUN"] = {"Assault shotgun", "An assault shotgun", equip('WEAPON_ASSAULTSHOTGUN'), 1},
    ["WEAPON_BULLPUPSHOTGUN"] = {"Bullpup shotgun", "A bullpup shotgun", equip('WEAPON_BULLPUPSHOTGUN'), 1},
    ["WEAPON_STUNGUN"] = {"Stungun", "A simple stungun", equip('WEAPON_STUNGUN'), 1},
    ["WEAPON_SNIPERRIFLE"] = {"Sniper rifle", "A sniper rifle", equip('WEAPON_SNIPERRIFLE'), 1},
    ["WEAPON_HEAVYSNIPER"] = {"Heavy sniper", "A heavy sniper", equip('WEAPON_HEAVYSNIPER'), 1},
    ["WEAPON_REMOTESNIPER"] = {"Remote sniper", "A remote sniper", equip('WEAPON_REMOTESNIPER'), 1},
    ["WEAPON_GRENADELAUNCHER"] = {"Grenade launcher", "A grenade launcher", equip('WEAPON_GRENADELAUNCHER'), 1},
    ["WEAPON_GRENADELAUNCHER_SMOKE"] = {"Grenade launcher smoke", "A simple smoke", equip('WEAPON_GRENADELAUNCHER_SMOKE'), 1},
    ["WEAPON_RPG"] = {"RPG", "A big RPG", equip('WEAPON_RPG'), 1},
    ["WEAPON_PASSENGER_ROCKET"] = {"Passenger rocket", "A simple passenger rocket", equip('WEAPON_PASSENGER_ROCKET'), 1},
    ["WEAPON_AIRSTRIKE_ROCKET"] = {"Airstrike rocket", "A simple airstrike rocket", equip('WEAPON_AIRSTRIKE_ROCKET'), 1},
    ["WEAPON_STINGER"] = {"Stinger", "A simple stinger", equip('WEAPON_STINGER'), 1},
    ["WEAPON_MINIGUN"] = {"Minigun", "A simple minigun", equip('WEAPON_MINIGUN'), 1},
    ["WEAPON_GRENADE"] = {"Grenade", "A simple grenade", equip('WEAPON_GRENADE'), 1},
    ["WEAPON_STICKYBOMB"] = {"Stickybomb", "A simple stickybomb", equip('WEAPON_STICKYBOMB'), 1},
    ["WEAPON_SMOKEGRENADE"] = {"Smokegrenade", "A simple smoke grenade", equip('WEAPON_SMOKEGRENADE'), 1},
    ["WEAPON_BZGAS"] = {"BZGAS", "A simple bzgas", equip('WEAPON_BZGAS'), 1},
    ["WEAPON_MOLOTOV"] = {"Molotov", "A simple molotov", equip('WEAPON_MOLOTOV'), 1},
    ["WEAPON_FIREEXTINGUISHER"] = {"Fire extinguisher", "A simple fire extinguisher", equip('WEAPON_FIREEXTINGUISHER'), 1},
    ["WEAPON_PETROLCAN"] = {"Petrol can", "A simple petrolcan", equip('WEAPON_PETROLCAN'), 1},
    ["WEAPON_DIGISCANNER"] = {"Digiscanner", "A simple digiscanner", equip('WEAPON_DIGISCANNER'), 1},
    ["WEAPON_BRIEFCASE"] = {"Briefcase", "A simple briefcase", equip('WEAPON_BRIEFCASE'), 1},
    ["WEAPON_BRIEFCASE_02"] = {"Briefcase 2", "A simple briefcase 2", equip('WEAPON_BRIEFCASE_02'), 1},
    ["WEAPON_BALL"] = {"Ball", "A simple ball", equip('WEAPON_BALL'), 1},
    ["WEAPON_FLARE"] = {"Flare", "A simple flare", equip('WEAPON_FLARE'), 1}
}