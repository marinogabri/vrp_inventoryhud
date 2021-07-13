local Drops = {}
currentDropId = nil
local prova = {}

function vRPin.setDrops(newDrops)
    Drops = newDrops
    currentDropId = nil
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local pos = GetEntityCoords(PlayerPedId(), true)
        for dropid, drop in pairs(Drops) do
            -- local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
            local dist = #(pos - drop.pos)
            if dist < 7 then
                currentDropId = dropid
            else
                currentDropId = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if currentDropId ~= nil then
            DrawMarker(2,Drops[currentDropId].pos[1],Drops[currentDropId].pos[2],Drops[currentDropId].pos[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 120, 10, 20, 155, false, false, false, 1, false, false, false)
            -- if IsControlJustPressed(0, 38) then
            --     INserver.takeFromDrop({currentDropId, 1})
            -- end
            prova = {
                {
					label = Drops[currentDropId].idname,
					count = Drops[currentDropId].amount,
					type = 'item_standard',
					name = Drops[currentDropId].idname,
					usable = true,
					rare = false,
					canRemove = true,
					usetxt = ch_text
				}
            }

            
            vRPin.setSecondInventoryItems(prova)
        else
            Citizen.Wait(250)
        end
    end
end)