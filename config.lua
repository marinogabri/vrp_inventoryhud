Config = {}

Config.EnableBlur = true -- enable blur screen while inventory is open
Config.OpenInventoryKey = 'F1'
Config.OpenHotbarKey = 'TAB'

Config.ChestSaveTime = 30 -- in minutes

Config.DefaultChestMaxWeight = 100
Config.Chests = {
    ["lspd"] = { 
        label = "LSPD Warehouse",
        position = { 
            x = 451.14639282227,
            y = -982.4599609375,
            z = 30.689580917358,
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
    ["Market"] = {
        positions = {
            {
                x = -47.522762298584,
                y = -1756.85717773438,
                z = 29.4210109710693    
            },
            {
                x = 25.7454013824463,
                y= -1345.26232910156,
                z = 29.4970207214355
            }, 
            {
                x = 1135.57678222656,
                y= -981.78125,
                z = 46.4157981872559
            }, 
            {
                x = 1163.53820800781,
                y= -323.541320800781,
                z = 69.2050552368164
            }, 
            {
                x = 374.190032958984,
                y= 327.506713867188,
                z = 103.566368103027
            }, 
            {
                x = 2555.35766601563,
                y = 382.16845703125,
                z = 108.622947692871
            }, 
            {
                x = 2676.76733398438,
                y= 3281.57788085938,
                z = 55.2411231994629
            }, 
            {
                x = 1960.50793457031,
                y = 3741.84008789063,
                z = 32.3437385559082
            },
            {
                x = 1393.23828125,
                y = 3605.171875,
                z = 34.9809303283691
            }, 
            {
                x = 1166.18151855469,
                y= 2709.35327148438,
                z = 38.15771484375
            }, 
            {
                x = 547.987609863281,
                y = 2669.7568359375,
                z = 42.1565132141113
            }, 
            {
                x = 1698.30737304688,
                y = 4924.37939453125,
                z = 42.0636749267578
            }, 
            {
                x = 1729.54443359375,
                y = 6415.76513671875,
                z = 35.0372200012207
            }, 
            {
                x = -3243.9013671875,
                y = 1001.40405273438,
                z = 12.8307056427002
            }, 
            {
                x = -2967.8818359375,
                y = 390.78662109375,
                z = 15.0433149337769
            }, 
            {
                x = -3041.17456054688,
                y= 585.166198730469,
                z = 7.90893363952637
            }, 
            {
                x = -1820.55725097656,
                y = 792.770568847656,
                z =138.113250732422
            }, 
            {
                x = -1486.76574707031,
                y= -379.553985595703,
                z = 40.163387298584
            }, 
            {
                x = -1223.18127441406,
                y = -907.385681152344,
                z = 12.3263463973999
            }, 
            {
                x = -707.408996582031,
                y = -913.681701660156,
                z = 19.2155857086182
            },
        },
        blipId = 52,
        blipColor = 2,
        items = {
            -- Drinks
            ["milk"] = 20,
            ["water"] = 20,
            ["coffee"] = 40,
            ["tea"] = 40,
            ["icetea"] = 80,
            ["orangejuice"] = 80,
            ["cocacola"] = 120,
            ["redbull"] = 120,
            ["lemonade"] = 140,
            ["vodka"] = 300,
        
            --Food
            ["bread"] = 20,
            ["donut"] = 20,
            ["tacos"] = 80,
            ["sandwich"] = 200,
            ["kebab"] = 200,
            ["pdonut"] = 650,
        }
    },
    ["Ammu-Nation"] = {
        positions = {
            {
                x = -662.180,
                y = -934.961,
                z = 21.829
            },
            {
                x = 810.25,
                y = -2157.60,
                z = 29.62
            },
            {
                x = 1693.44,
                y = 3760.16,
                z = 34.71
            },
            {
                x = -330.24,
                y = 6083.88,
                z = 31.45
            },
            {
                x = 252.63,
                y = -50.00,
                z = 69.94
            },
            {
                x = 22.56,
                y = -1109.89,
                z = 29.80
            },
            {
                x = 2567.69,
                y = 294.38,
                z = 108.73
            },
            {
                x = -1117.58,
                y = 2698.61,
                z = 18.55
            },
            {
                x = 842.44,
                y = -1033.42,
                z = 28.19
            },
        },
        blipId = 110,
        blipColor = 1,
        items = {
            ["WEAPON_PISTOL"] = 1000,
            ["WEAPON_SMG"] = 5000,
            ["WEAPON_CROWBAR"] = 100,
            ["WEAPON_KNIFE"] = 100,
            ["WEAPON_HATCHET"] = 50,
            ["WEAPON_BOTTLE"] = 30,
            ["ammo"] = 100,
        }
    },
    ["Police Weapons"] = {
        positions = {
            {
                x = 451.59027099609,
                y = -980.11553955078,
                z = 30.689596176147 
            },
        },
        blipId = 110,
        blipColor = 1,
        permission = "police.vehicle",
        items = {
            ["WEAPON_COMBATPISTOL"] = 0,
            ["WEAPON_NIGHTSTICK"] = 0,
            ["WEAPON_FLASHLIGHT"] = 0,
            ["ammo"] = 0
        }
    },
}

Config.Items = {
    -- AMMO
    ["ammo-pistol"] = {"Pistol ammo", "Ammo for your pistols", nil,1},
    ["ammo-rifle"] = {"Rifle ammo", "Ammo for your rifles", nil,1},
    ["ammo-shotgun"] = {"Shotgun ammo", "Ammo for your shotguns", nil,1},

    -- WEAPONS
    ["WEAPON_KNIFE"] = {"Knife", "A simple knife", nil, 1},
    ["WEAPON_DAGGER"] = {"Dagger", "A simple dagger", nil, 1},
    ["WEAPON_BOTTLE"] = {"Broken bottle", "A broken bottle", nil, 1},
    ["WEAPON_HATCHET"] = {"Hatchet", "A simple hatchet", nil, 1},
    ["WEAPON_STONE_HATCHET"] = {"Stone hatchet", "A stone hatchet", nil, 1},
    ["WEAPON_KNUCKLE"] = {"Knuckle", "A simple knuckle", nil, 1},
    ["WEAPON_MACHETE"] = {"Machete", "A simple machete", nil, 1},
    ["WEAPON_SWITCHBLADE"] = {"Switchblade knife", "A switchblade knife", nil, 1},
    ["WEAPON_WRENCH"] = {"Wrench", "A simple wrench", nil, 1},
    ["WEAPON_BATTLEAXE"] = {"Battle Axe", "A battle axe", nil, 1},
    ["WEAPON_FLASHLIGHT"] = {"Flashlight", "A simple flashlight", nil, 1},
    ["WEAPON_NIGHTSTICK"] = {"Nightstick", "A simple nightstick", nil, 1}, 
    ["WEAPON_HAMMER"] = {"Hammer", "A simple hammer", nil, 1},
    ["WEAPON_BAT"] = {"Bat", "A simple bat", nil, 1},
    ["WEAPON_GOLFCLUB"] = {"Golfclub bat", "A simple golf bat", nil, 1},
    ["WEAPON_CROWBAR"] = {"Crowbar", "A simple crowbar", nil, 1},
    ["WEAPON_PISTOL"] = {"Pistol", "A simple pistol", nil, 1, "ammo-pistol"},
    ["WEAPON_COMBATPISTOL"] = {"Combat pistol", "A combat pistol", nil, 1, "ammo-pistol"},
    ["WEAPON_APPISTOL"] = {"AP Pistol", "A AP Pistol", nil, 1, "ammo-pistol"},
    ["WEAPON_PISTOL50"] = {"Pistol .50", "A .50 pistol", nil, 1, "ammo-pistol"},
    ["WEAPON_MICROSMG"] = {"Micro SMG", "A micro smg", nil, 1, "ammo-rifle"},
    ["WEAPON_SMG"] = {"SMG", "A SMG", nil, 1, "ammo-rifle"},
    ["WEAPON_COMBATMG"] = {"Combat SMG", "A combat SMG", nil, 1, "ammo-rifle"},
    ["WEAPON_ASSAULTSMG"] = {"Assault SMG", "An assault SMG", nil, 1, "ammo-rifle"},
    ["WEAPON_ASSAULTRIFLE"] = {"Assault rifle", "An assault rifle", nil, 1, "ammo-rifle"},
    ["WEAPON_CARBINERIFLE"] = {"Caribine rifle", "A simple caribine", nil, 1, "ammo-rifle"},
    ["WEAPON_ADVANCEDRIFLE"] = {"Advanced rifle", "An advanced rifle", nil, 1, "ammo-rifle"},
    ["WEAPON_MG"] = {"MG", "A simple MG", nil, 1, "ammo-rifle"},
    ["WEAPON_PUMPSHOTGUN"] = {"Pump shotgun", "A pump shotgun", nil, 1, "ammo-shotgun"},
    ["WEAPON_SAWNOFFSHOTGUN"] = {"Sawnoff shotgun", "A sawnoff shotgun", nil, 1, "ammo-shotgun"},
    ["WEAPON_ASSAULTSHOTGUN"] = {"Assault shotgun", "An assault shotgun", nil, 1, "ammo-shotgun"},
    ["WEAPON_BULLPUPSHOTGUN"] = {"Bullpup shotgun", "A bullpup shotgun", nil, 1, "ammo-shotgun"},
    ["WEAPON_STUNGUN"] = {"Stungun", "A simple stungun", nil, 1},
    ["WEAPON_SNIPERRIFLE"] = {"Sniper rifle", "A sniper rifle", nil, 1, "ammo-rifle"},
    ["WEAPON_HEAVYSNIPER"] = {"Heavy sniper", "A heavy sniper", nil, 1, "ammo-rifle"},
    ["WEAPON_REMOTESNIPER"] = {"Remote sniper", "A remote sniper", nil, 1, "ammo-rifle"},
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