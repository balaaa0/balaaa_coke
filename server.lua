----------------------------------------------------------------------
               -- Discord : https://discord.gg/Nf6bpx2jMJ
                           -- Insert#1224
----------------------------------------------------------------------

ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback("esx_bala_meta:checkItem", function(source, cb, itemname, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname)["count"]
    if item >= count then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("esx_bala_meta:removeItem")
AddEventHandler("esx_bala_meta:removeItem", function(itemname, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(itemname, count)
end)

RegisterServerEvent("esx_bala_meta:giveItem")
AddEventHandler("esx_bala_meta:giveItem", function(itemname, count)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.canCarryItem(itemname, count) then
            xPlayer.addInventoryItem(itemname, count)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'No hay vacantes en su inventario!', style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })           
    end
end)

