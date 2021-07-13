local Drops = {}

function vRPin.createDrop(idname, amount)
    local _source = source
    local user_id = vRP.getUserId({_source})
    if user_id ~= nil then
        vRPclient.getPosition(_source, {}, function(x,y,z)
            if vRP.tryGetInventoryItem({user_id,idname,amount,true}) then
                local id = math.random(10000, 99999)
                local dropid = id
                while Drops[dropid] ~= nil do
                    id = math.random(10000, 99999)
                    dropid = id
                end
                Drops[dropid] = {
                    idname = idname,
                    amount = amount,
                    pos = vector3(x,y,z)
                }
                -- ora settare drop lato client
                INclient.loadPlayerInventory(_source)
                INclient.setDrops(-1, {Drops})
            end
        end)
    end
end

function vRPin.deleteDrop(dropid)
    Drops[dropid] = nil
    -- ora settare drop lato client
    INclient.setDrops(-1, {Drops})
end

function vRPin.takeFromDrop(dropid, amount)
    local _source = source
    local user_id = vRP.getUserId({_source})
    if user_id ~= nil then
        if Drops[dropid] ~= nil then
            if amount > Drops[dropid].amount then
                amount = Drops[dropid].amount
            end
            vRP.giveInventoryItem({user_id,Drops[dropid].idname,amount,true})
            Drops[dropid].amount = Drops[dropid].amount - amount
            if Drops[dropid].amount <= 0 then
                vRPin.deleteDrop(dropid)
            end
        end
    end
end