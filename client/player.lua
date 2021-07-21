RegisterNUICallback("PutIntoPlayer", function(data, cb)		
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        INserver.putIntoPlayer({data.item.name,data.number})
        cb("ok")
    end
end)

RegisterNUICallback("TakeFromPlayer", function(data, cb)
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        INserver.takeFromPlayer({data.item.name,data.number})
        cb("ok")
    end
end)