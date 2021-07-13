function vRPin.openChestInventory()
    openInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "chest"
        }
    )

    SetNuiFocus(true, true)
end

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