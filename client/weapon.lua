currentWeapon = nil

function vRPin.equipWeapon(weapon)
    local ped = PlayerPedId()
    local selectedWeapon = GetSelectedPedWeapon(ped)
    if currentWeapon == weapon and not (selectedWeapon == GetHashKey('WEAPON_UNARMED')) then
        vRP.playAnim({true,{{"reaction@intimidation@1h","outro",1}},false})
        Citizen.Wait(1600)
        ClearPedTasks(ped)
        RemoveWeaponFromPed(ped, GetHashKey(weapon))
        currentWeapon = nil
    else
        RemoveAllPedWeapons(ped, true)
        currentWeapon = weapon
        vRP.playAnim({true,{{"reaction@intimidation@1h","intro",1}},false})
        Citizen.Wait(1600)
        ClearPedTasks(ped)
        GiveWeaponToPed(ped, GetHashKey(weapon), 0, false, true)
    end
end

RegisterCommand('reload',function()
    if currentWeapon ~= nil then
        local playerId = PlayerId()
        local playerSource = GetPlayerServerId(playerId)
        local ped = PlayerPedId()
        local magazineSize = GetMaxAmmoInClip(ped, GetHashKey(currentWeapon))
        local currentAmmo = GetAmmoInPedWeapon(ped, GetHashKey(currentWeapon))

        if currentAmmo == 0 then
            INserver.requestReload({playerSource, magazineSize}, function(ammo)
                if ammo ~= nil then
                    SetPedAmmo(ped, currentWeapon, ammo)
                    MakePedReload(ped)
                end
            end)
        end
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
        else
            Citizen.Wait(1600)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if vRP.isInComa({}) or vRP.isHandcuffed{} or vRP.isJailed({}) then
            if currentWeapon ~= nil then
                currentWeapon = nil
                RemoveAllPedWeapons(PlayerPedId(), true)
                Citizen.Wait(5000)
            end
        end
    end
end)