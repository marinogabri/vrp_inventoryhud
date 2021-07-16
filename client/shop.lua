RegisterNUICallback("BuyItem", function(data, cb)		
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        INserver.buyItem({data.item.name,data.number})
        cb("ok")
    end
end)