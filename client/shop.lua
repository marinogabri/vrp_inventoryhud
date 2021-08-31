RegisterNUICallback("BuyItem", function(data, cb)		
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        INserver.buyItem({data.item.name,data.number})
        cb("ok")
    end
end)

Citizen.CreateThread(function ()
    -- Blips
    for name, shop in pairs(Config.Shops) do
        for _, position in pairs(shop.positions) do
            vRP.addBlip({position.x,position.y,position.z,shop.blipId,shop.blipColor,name})
        end
    end

    while true do
        local wait = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for name, shop in pairs(Config.Shops) do
            for _, pos in pairs(shop.positions) do
                if #(pedCoords - pos) < 5.0 then
                    wait = 1
                    DrawMarker(shop.markerId,pos.x,pos.y,pos.z-0.95,0,0,0,0,0,0,1.0,1.0,1.0,shop.markerColor[1],shop.markerColor[2],shop.markerColor[3],255,false, false, false, true, false, false, false)
                    if #(pedCoords - pos) <= 1.0 then
                        Draw3DText(pos, "Press ~g~[E]~w~ to open " .. name)
                        if IsControlJustPressed(0, 51) then
                            INserver.openShop({name, pos})
                        end
                    end
                end
            end
        end

        Citizen.Wait(wait)
    end
end)