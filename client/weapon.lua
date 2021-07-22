local currentWeapon = nil

function vRPin.equipWeapon(weapon, ammo)
    local ped = PlayerPedId()
    if currentWeapon == weapon then
        vRP.playAnim({true,{{"reaction@intimidation@1h","outro",1}},false})
        Citizen.Wait(1600)
        ClearPedTasks(ped)
        RemoveWeaponFromPed(ped, GetHashKey(weapon))
        currentWeapon = nil
    else
        currentWeapon = weapon
        vRP.playAnim({true,{{"reaction@intimidation@1h","intro",1}},false})
        Citizen.Wait(1600)
        ClearPedTasks(ped)
        GiveWeaponToPed(ped, GetHashKey(weapon), 0, false, true)
        -- SetPedAmmo(ped, GetHashKey(weapon), ammo)
    end
end

function vRPin.setAmmo(ammo)
    local ped = PlayerPedId()
    -- local currentAmmo = GetAmmoInPedWeapon(ped, GetHashKey(currentWeapon))
    -- local newAmmo = currentAmmo + ammo
    SetPedAmmo(ped, GetHashKey(currentWeapon), ammo)
end

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(100)
--         if currentWeapon.weapon ~= nil then
--             -- print("yes ")
--             local ammo = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(currentWeapon.weapon))
--             if ammo ~= currentWeapon.ammo then
--                 print(ammo, currentWeapon.ammo)
--                 local playerId = PlayerId()
--                 local playerSource = GetPlayerServerId(playerId)
--                 INserver.updateAmmo({playerSource, ammo})
--                 currentWeapon.ammo = ammo
--             end
--         else
--             Citizen.Wait(500)
--         end
--     end
-- end)