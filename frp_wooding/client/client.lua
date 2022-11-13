

ESX = exports["es_extended"]:getSharedObject()
local wooding = false

CreateThread(function()
    for i=1, #Config.WoodingAreas, 1 do
        CreateBlip(Config.WoodingAreas[i], 153, 0, "Fa", 0.75)
    end
    CreateBlip(Config.SellShop, 207, 5, "Fa Eladás", 0.80)
end)

CreateThread(function()
    while true do
        local Sleep = 1500
        local player = PlayerPedId()
        local pos = GetEntityCoords(player)
        for i=1, #Config.WoodingAreas, 1 do
            local dist = #(GetEntityCoords(player) - Config.WoodingAreas[i])	
            if dist <= 10 and not wooding then
                Sleep = 0
                DrawMarker(42, vector3(Config.WoodingAreas[i].x, Config.WoodingAreas[i].y, Config.WoodingAreas[i].z-0.2), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 0, 0, 255, false, true, 2, true, false, false, false) 
                if dist <= 1.5 and not wooding then
                    DrawText3Ds(Config.WoodingAreas[i], "[E] Favágás", 0.55, 1.5, 50)
                    if IsControlJustReleased(0, 38) and dist <= 1.5 then
                        ESX.TriggerServerCallback('frp_wooding:checkPick', function(output)
                            if output then
                                wooding = true
                                local modelHash = Config.Axe
                                local model = loadModel(modelHash)
                                local axe = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
                                AttachEntityToEntity(axe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
                                while wooding do
                                    Wait()
                                    local unarmed = `WEAPON_UNARMED`
                                    SetCurrentPedWeapon(PlayerPedId(), unarmed)
                                    ShowHelp("Nyomd meg ~INPUT_ATTACK~, hogy fát vághass ~INPUT_FRONTEND_RRIGHT~ Hogy a munkálatot abba hagyd")
                                    DisableControlAction(0, 24, true)
                                    if IsDisabledControlJustReleased(0, 24) then
                                        local dict = loadDict('melee@hatchet@streamed_core')
                                        TaskPlayAnim(PlayerPedId(), dict, 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
                                        local skillbar = CreateSkillbar(1, "medium")
                                        if skillbar then
                                            ClearPedTasks(PlayerPedId())
                                           WoodCut(dist)
                                        elseif not skillbar then
                                            local breakChance = math.random(1,7)
                                            if breakChance < Config.AxeBreakPercent then
                                                TriggerServerEvent('frp_wooding:axeBroke')
                                                exports['okokNotify']:Alert("Információ", "Rosszul találtad el a fát, és elpattant a fejszéd!", 5000, 'success')
                                                ClearPedTasks(PlayerPedId())
                                                break
                                            end
                                            ClearPedTasks(PlayerPedId())
                                            exports['okokNotify']:Alert("Információ", "Nem sikerült a vágás", 5000, 'success')
                                        end
                                    elseif IsControlJustReleased(0, 194) then
                                        break
                                    elseif #(GetEntityCoords(PlayerPedId()) - Config.WoodingAreas[i]) > 2.0 then
                                        break
                                    end
                                end
                                wooding = false
                                DeleteObject(axe)
                            elseif not output then
                                exports['okokNotify']:Alert("Információ", "Nincs Fejszéd!", 5000, 'success')
                            end
                        end, 'axe')
                    end	
                end
            end
        end
        Wait(Sleep)
     end
 end)

 --Sell Shop Functionality
CreateThread(function()
	while true do
        local Sleep = 1500
		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local dist = #(playerCoords - Config.SellShop)
		if dist <= 10.0 then
            Sleep = 0
            DrawMarker(29, vector3(Config.SellShop.x, Config.SellShop.y, Config.SellShop.z-0.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 205, 0, 100, false, true, 2, true, false, false, false) 
            if dist <= 1.5 then
                DrawText3Ds(Config.SellShop, "[E] Fa Eladása", 0.55, 1.5, 0.7)
                if IsControlJustReleased(0, 38) and dist <= 1.5 then
                    WoodingSellItems(dist)
                end
			end
		end
    Wait(Sleep)
	end
end)

RegisterNetEvent('frp_wooding:alertStaff')
AddEventHandler('frp_wooding:alertStaff', function()
end)