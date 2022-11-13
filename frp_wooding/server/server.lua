

ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('frp_wooding:checkPick', function(source, cb, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname).count
    if item >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("frp_wooding:WoodCut")
AddEventHandler("frp_wooding:WoodCut", function(distance)
    if distance ~= nil then
        if distance <= 3 then
            local awardItem = Config.Wood[math.random(#Config.Wood)]
            local xPlayer = ESX.GetPlayerFromId(source)
            local awardItemLabel = ESX.GetItemLabel(awardItem)
            if Config.OldESX then
                local limitItem = xPlayer.getInventoryItem(awardItem)
                if limitItem.limit == -1 or (limitItem.count + 1) <= limitItem.limit then
                    xPlayer.addInventoryItem(awardItem, 1)
                    if Config.DiscordWoodLogs then
                        sendToDiscord("Favágás","**"..GetPlayerName(source).."** Fát vágott!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 3066993)
                    end
                else
                    TriggerClientEvent('okokNotify:Alert', source, "Információ", "Nem tudsz többet cipelni"..' '..awardItemLabel, 5000, 'success') 
                end
            else
                if xPlayer.canCarryItem(awardItem, 1) then
                    xPlayer.addInventoryItem(awardItem, 1)
                    if Config.DiscordWoodLogs then
                        sendToDiscord("Favágás","**"..GetPlayerName(source).."** Fát vágott!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 3066993)
                    end
                else
                    TriggerClientEvent('okokNotify:Alert', source, "Információ", "Nem tudsz többet cipelni"..' '..awardItemLabel, 5000, 'success') 
                end
            end
        else
            local xPlayer = ESX.GetPlayerFromId(source)
            TriggerClientEvent('frp_wooding:alertStaff', source)
            if Config.DiscordCheatLogs then
                sendToDiscord("Favágás","**"..GetPlayerName(source).."** fát vágott és túl ment a határon\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
            end
            Wait(2000)
            xPlayer.kick("Ki lettél kickelve mivel csalást észleltünk!")
        end
    else
        TriggerClientEvent('frp_wooding:alertStaff', source)
        if Config.DiscordCheatLogs then
            sendToDiscord("Favágás","**"..GetPlayerName(source).."** fát vágott és túl ment a határon!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
        end
        Wait(2000)
        xPlayer.kick("Ki lettél kickelve mivel csalást észleltünk!")
    end
end)

RegisterServerEvent('frp_wooding:sellWood')
AddEventHandler('frp_wooding:sellWood', function(distance)
    if distance ~= nil then
        if distance <= 3 then
            for k, v in pairs(Config.WoodPrices) do
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer.getInventoryItem(k).count > 0 then
                    local rewardAmount = 0
                    for i = 1, xPlayer.getInventoryItem(k).count do
                        rewardAmount = rewardAmount + math.random(v[1], v[2])
                    end
                    xPlayer.addMoney(rewardAmount)
                    TriggerClientEvent('okokNotify:Alert', source, "Információ", "Eladtad", 5000, 'success')
                    xPlayer.removeInventoryItem(k, xPlayer.getInventoryItem(k).count)
                end
            end
        else
            TriggerClientEvent('frp_wooding:alertStaff', source) 
            if Config.DiscordCheatLogs then
                sendToDiscord("Favágás","**"..GetPlayerName(source).."** megpróbálta eladni a fát, de nem sikerült!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
            end
            Wait(2000)
            xPlayer.kick("Ki lettél kickelve mivel csalást észleltünk!")
        end
    else
        TriggerClientEvent('frp_wooding:alertStaff', source) 
        if Config.DiscordCheatLogs then
            sendToDiscord("Favágás","**"..GetPlayerName(source).."** megpróbálta eladni a fát, de nem sikerült!\n**"..ESX.GetPlayerFromId(source).getIdentifier().."**", 15158332)
        end
        Wait(2000)
        xPlayer.kick("Ki lettél kickelve mivel csalást észleltünk!")
    end
end)

        RegisterServerEvent('frp_wooding:axeBroke')
AddEventHandler('frp_wooding:axeBroke', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem('axe')
    if xItem.count >= 1 then
        xPlayer.removeInventoryItem('axe', 1)
    end
end)

