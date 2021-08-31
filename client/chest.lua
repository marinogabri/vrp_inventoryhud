RegisterNUICallback("PutIntoChest", function(data, cb)		
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        INserver.putIntoChest({data.item.name,data.number})
        cb("ok")
    end
end)

RegisterNUICallback("TakeFromChest", function(data, cb)
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        INserver.takeFromChest({data.item.name,data.number})
        cb("ok")
    end
end)

function vRPin.isIsideACar()
    return IsPedSittingInAnyVehicle(PlayerPedId()) or (GetVehiclePedIsEntering(PlayerPedId()) ~= 0)
end

Citizen.CreateThread(function ()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for name, chest in pairs(Config.Chests) do
            if #(pedCoords - chest.position) < 5.0 then
                wait = 1
                DrawMarker(chest.markerId,chest.position.x,chest.position.y,chest.position.z-0.95,0,0,0,0,0,0,1.0,1.0,1.0,chest.markerColor[1],chest.markerColor[2],chest.markerColor[3],255,false, false, false, true, false, false, false)
                if #(pedCoords - chest.position) <= 1.0 then
                    if chest.label == nil then chest.label = name end
                    Draw3DText(chest.position, "Press ~g~[E]~w~ to open " .. chest.label)
                    if IsControlJustPressed(0, 51) then
                        INserver.openChest({name, chest.position})
                    end
                end
            end
        end

        Citizen.Wait(wait)
    end
end)