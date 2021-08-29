currentWeapon = nil

function vRPin.equipWeapon(weapon)
    local ped = PlayerPedId()
    local selectedWeapon = GetSelectedPedWeapon(ped)
    if currentWeapon == weapon and not (selectedWeapon == GetHashKey('WEAPON_UNARMED')) then
        vRP.playAnim({true,{{"reaction@intimidation@1h","outro",1}},false})
        Citizen.Wait(1600)
        ClearPedTasks(ped)
        local currentAmmo = GetAmmoInPedWeapon(ped, GetHashKey(currentWeapon))
        RemoveWeaponFromPed(ped, GetHashKey(weapon))
        if currentAmmo > 0 then
            INserver.holstered({currentWeapon, currentAmmo})
        end
        currentWeapon = nil
        vRPin.notify({name = weapon, count = 1, label = Config.Items[weapon][1]}, "Holstered")
    else
        RemoveAllPedWeapons(ped, true)
        currentWeapon = weapon
        vRP.playAnim({true,{{"reaction@intimidation@1h","intro",1}},false})
        Citizen.Wait(1600)
        ClearPedTasks(ped)
        GiveWeaponToPed(ped, GetHashKey(weapon), 0, false, true)
        vRPin.notify({name = weapon, count = 1, label = Config.Items[weapon][1]}, "Unholstered")
    end
end

RegisterCommand('reload',function()
    if currentWeapon ~= nil then
        local ped = PlayerPedId()
        local magazineSize = GetMaxAmmoInClip(ped, GetHashKey(currentWeapon))
        local currentAmmo = GetAmmoInPedWeapon(ped, GetHashKey(currentWeapon))
        local toReload = magazineSize

        if currentAmmo > 0 then
            toReload = magazineSize - currentAmmo
        end

        INserver.requestReload({currentWeapon, toReload}, function(ok)
            if ok then
                SetPedAmmo(ped, currentWeapon, magazineSize)
                MakePedReload(ped)
            end
        end)
    end
end)
RegisterKeyMapping('reload', 'Reload your weapon', 'keyboard', 'R')

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if currentWeapon ~= nil then
            local ped = PlayerPedId()
            local currentAmmo = GetAmmoInPedWeapon(ped, GetHashKey(currentWeapon))
            if currentAmmo < 1 then
                GiveWeaponToPed(ped, GetHashKey(currentWeapon), 0, false, true)
            end

            if vRP.isInComa({}) or vRP.isHandcuffed{} or vRP.isJailed({}) then
                currentWeapon = nil
                RemoveAllPedWeapons(PlayerPedId(), true)
            end
        else
            Citizen.Wait(1600)
        end
    end
end)