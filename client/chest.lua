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