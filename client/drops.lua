local Drops = {}

function vRPin.setDrops(drops)
    Drops = drops
end

RegisterNUICallback("PutIntoDrop", function(data, cb)		
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        INserver.putIntoDrop({data.item.name,data.number})

        if currentWeapon == data.item.name then
            currentWeapon = nil
            RemoveAllPedWeapons(PlayerPedId(), true)
        end
        cb("ok")
    end
end)

RegisterNUICallback("TakeFromDrop", function(data, cb)
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        INserver.takeFromDrop({data.item.name,data.number})
        cb("ok")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for dropId, drop in pairs(Drops) do
            if #(drop.position - pedCoords) < 5 then
                DrawMarker(2,drop.position.x,drop.position.y,drop.position.z-0.5,0,0,0,0,0,0,0.3,0.3,0.3,255,0,0,255,false, false, false, true, false, false, false)
            end    
        end
    end
end)