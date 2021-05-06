----------------------------------------------------------------------
               -- Discord : https://discord.gg/Nf6bpx2jMJ
                           -- Insert#1224
----------------------------------------------------------------------

ESX = nil

local isProcessing = false
local distressBottle = false
local mixfosfor = false
local inGas = false
local sayac = 0
---NPC---
local PlayerData = {}
local HasAlreadyEnteredMarker = false
local currentZone = nil
local DISTANCE = 10
local DISTANCE_INTERACTION = 2
local MARKER_SIZE = 1.0
local E_KEY = 38

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                'esx:getSharedObject',
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        PlayerData = ESX.GetPlayerData()
        start()
    end
)

function start()
    for _, ped in pairs(Config.Peds) do
        if ped.model ~= nil then

            local modelHash = GetHashKey(ped.model)
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Wait(1)
            end
            local SpawnedPed = CreatePed(2, modelHash, ped.pos, ped.h, false, true)
            TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
            Citizen.Wait(1)

            if ped.animation ~= nil then
                TaskStartScenarioInPlace(SpawnedPed, ped.animation, 0, false)
            end

            SetEntityInvincible(SpawnedPed, true)
            PlaceObjectOnGroundProperly(SpawnedPed)
            SetModelAsNoLongerNeeded(modelHash)
            SetBlockingOfNonTemporaryEvents(SpawnedPed, true)
	        TaskSetBlockingOfNonTemporaryEvents(SpawnedPed, true)
	        SetPedDiesWhenInjured(SpawnedPed, false)
	        SetPedCanPlayAmbientAnims(SpawnedPed, true)
	        SetPedCanRagdollFromPlayerImpact(SpawnedPed, false)
	        FreezeEntityPosition(SpawnedPed, true)

            Citizen.CreateThread(
                function()
                    local _ped = SpawnedPed
                    Citizen.Wait(1000)
                    FreezeEntityPosition(_ped, true)
                end
            )
        end
    end
    if PlayerData.job.name == 'police' then
        return
    end
    function spawnMarker(ped, coords)
        local cur_distance = GetDistanceBetweenCoords(coords, ped.pos, true)
        if ped.onEnter ~= nil and cur_distance < DISTANCE then
            if ped.isEnabled == nil or exports[ped.resource][ped.isEnabled]() then
                DrawMarker(1, ped.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, MARKER_SIZE, MARKER_SIZE, 0.4, 102, 0, 204, 50, false, false, 2, false, false, false, false)
                if cur_distance < DISTANCE_INTERACTION then
                    if not HasAlreadyEnteredMarker then
                        currentZone = ped.name
                        HasAlreadyEnteredMarker = true
                    end
                    if HasAlreadyEnteredMarker then
                        PlayerData = ESX.GetPlayerData()
                        if ped.onEnterText ~= nil then
                            ESX.ShowHelpNotification(ped.onEnterText)
                        else
                            ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour parler avec le contact.')
                        end
                        if IsControlPressed(0, 38) then
                            exports[ped.resource][ped.onEnter]()
                        end
                    end
                elseif ped.onExit ~= nil and HasAlreadyEnteredMarker and ped.name == currentZone then
                    HasAlreadyEnteredMarker = false
                    exports[ped.resource][ped.onExit]()
                end
            else
                if cur_distance < DISTANCE_INTERACTION then
                    if not HasAlreadyEnteredMarker then
                        ESX.ShowHelpNotification("Je n'ai rien à te proposer pour le moment.")
                    end
                else
                    HasAlreadyEnteredMarker = false
                end
            end
        end
    end

    Citizen.CreateThread(
        function()
            while true do
                Citizen.Wait(0)

                local coords = GetEntityCoords(PlayerPedId())
                for _, ped in pairs(Config.Peds) do
                    if ped.onEnter ~= nil or ped.onExit ~= nil then
                        spawnMarker(ped, coords)
                    end
                end
            end
        end
    )
end

---FIN PEDS--- 

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)



-- StageOne //
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 
        local sleep = 1000
        local playerPed = GetEntityCoords(PlayerPedId())
        local player = PlayerPedId()
        local dst = GetDistanceBetweenCoords(playerPed, Config.kordinatlar.aseton.x, Config.kordinatlar.aseton.y, Config.kordinatlar.aseton.z, true)
        if dst <= 1 then
            sleep = 1
            if not isProcessing then
                ESX.ShowFloatingHelpNotification("Pulsa ~y~E~w~ para embotellar la acetona" , vector3(Config.kordinatlar.aseton.x, Config.kordinatlar.aseton.y, Config.kordinatlar.aseton.z))
                if IsControlJustPressed(0, 38) and not isProcessing then
                    ESX.TriggerServerCallback("esx_bala_meta:checkItem", function(output)
                        if output then
                            TriggerServerEvent("esx_bala_meta:removeItem", "acetone", 1)
                            SetEntityHeading(player, Config.kordinatlar.aseton.h)
                            StageOne()
                        elseif not output then
                            exports['mythic_notify']:SendAlert("error", "Sin acetona")
                        end
                    end, "acetone", 1)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- StageTwo //
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 
        local sleep = 1000
        local playerPed = GetEntityCoords(PlayerPedId())
        local player = PlayerPedId()
        local dst = GetDistanceBetweenCoords(playerPed, Config.kordinatlar.damitma.x, Config.kordinatlar.damitma.y, Config.kordinatlar.damitma.z, true)
        if dst <= 1 then
            sleep = 1
            if not isProcessing then
                ESX.ShowFloatingHelpNotification("Pulsa ~y~E~w~ para destilar la acetona en botella" , vector3(Config.kordinatlar.damitma.x, Config.kordinatlar.damitma.y, Config.kordinatlar.damitma.z ))
                if IsControlJustPressed(0, 38) and not isProcessing then
                    ESX.TriggerServerCallback("esx_bala_meta:checkItem", function(output)
                        if output then
                            TriggerServerEvent("esx_bala_meta:removeItem", "acetonebottle", 2)
                            SetEntityHeading(player, Config.kordinatlar.damitma.h)
                            StageTwo()
                        elseif not output then
                            exports['mythic_notify']:SendAlert("error", "Sin acetona embotellada")
                        end
                    end, "acetonebottle", 2)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)


-- StageThree //
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1) 
        local sleep = 1000
        local playerPed = GetEntityCoords(PlayerPedId())
        local player = PlayerPedId()
        local dst = GetDistanceBetweenCoords(playerPed, Config.kordinatlar.fosfor.x, Config.kordinatlar.fosfor.y, Config.kordinatlar.fosfor.z, true)
        if dst <= 1 then
            sleep = 1
            if not isProcessing then
                ESX.ShowFloatingHelpNotification("Pulsa ~y~E~w~ para mezclar la acetona y el fosforo" , vector3(Config.kordinatlar.fosfor.x, Config.kordinatlar.fosfor.y, Config.kordinatlar.fosfor.z))
                if IsControlJustPressed(0, 38) and not isProcessing then
                    ESX.TriggerServerCallback("esx_bala_meta:checkItem", function(output)
                        if output then
                            SetEntityHeading(player, Config.kordinatlar.fosfor.h)
                            TriggerEvent("esx_bala_meta:questback")
                        elseif not output then
                            exports['mythic_notify']:SendAlert("error", "Sin acetona destilada")
                        end
                    end, "distilledbottle", 2)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("esx_bala_meta:questback")
AddEventHandler("esx_bala_meta:questback", function()
ESX.TriggerServerCallback("esx_bala_meta:checkItem", function(output)
    if output then
        TriggerEvent("esx_bala_meta:questions")
    elseif not output then
        exports['mythic_notify']:SendAlert("error", "Sin fósforo rojo")
    end
    end, "phosphorus", 2)
end)

-- stageFour //
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 
        local sleep = 1000
        local playerPed = GetEntityCoords(PlayerPedId())
        local player = PlayerPedId()
        local dst = GetDistanceBetweenCoords(playerPed, Config.kordinatlar.aluminyum.x, Config.kordinatlar.aluminyum.y, Config.kordinatlar.aluminyum.z, true)
        if dst <= 1 then
            sleep = 1
            if not isProcessing then
                ESX.ShowFloatingHelpNotification("Pulsa ~y~E~w~ para meter la mezcla en el horno" , vector3(Config.kordinatlar.aluminyum.x, Config.kordinatlar.aluminyum.y, Config.kordinatlar.aluminyum.z))
                if IsControlJustPressed(0, 38) and not isProcessing then
                    ESX.TriggerServerCallback("esx_bala_meta:checkItem", function(output)
                        if output then
                            SetEntityHeading(player, Config.kordinatlar.aluminyum.h)
                            StageFour()
                           -- TriggerEvent("esx_bala_meta:questionstwo")
                        elseif not output then
                            exports['mythic_notify']:SendAlert("error", "Sin mezcla de metanfetamina")
                        end
                    end, "mixedmeth", 1)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- StageOne //
function StageOne()
    isProcessing = true
        TriggerEvent("mythic_progbar:client:progress", {
                name = "acetone",
                duration = 10000,
                label = "Poniendo la acetona en la botella...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "mini@repair",
                    anim = "fixing_a_ped",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end)  
  Citizen.Wait(10000)
  TriggerServerEvent("esx_bala_meta:giveItem", "acetonebottle", 2)
  isProcessing = false
end

-- StageTwo //
function StageTwo()
    isProcessing = true
    distressBottle = true
        TriggerEvent("mythic_progbar:client:progress", {
                name = "distillation",
                duration = 5000,
                label = "Establiendo un mecanismo de destilación....",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "mp_arresting",
                    anim = "a_uncuff",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end) 
         Citizen.Wait(5000)
        exports['mythic_notify']:SendAlert("inform", "El proceso de destilación terminará después de 30 segundos.")
        Citizen.Wait(30000)
        exports['mythic_notify']:SendAlert("inform", "Destilación finalizada retire las botellas de la mesa")
        while distressBottle do
            Citizen.Wait(1)
        local playerPed = GetEntityCoords(PlayerPedId())
        local dst = GetDistanceBetweenCoords(playerPed, Config.kordinatlar.damitma.x, Config.kordinatlar.damitma.y, Config.kordinatlar.damitma.z, true)
        if dst <= 1 and distressBottle then
            ESX.ShowFloatingHelpNotification("Pulsa ~y~E~w~ para obtener las botellas d'acetona destilada" , vector3(Config.kordinatlar.damitma.x, Config.kordinatlar.damitma.y, Config.kordinatlar.damitma.z))
            if IsControlJustPressed(0, 38) then
                TriggerEvent("mythic_progbar:client:progress", {
                name = "bouteilles",
                duration = 2500,
                label = "Cogiendo las botellas...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "creatures@rottweiler@tricks@",
                    anim = "petting_franklin",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end) 
         Citizen.Wait(2500)
                TriggerServerEvent("esx_bala_meta:giveItem", "distilledbottle", 2)  
                distressBottle = false 
                Citizen.Wait(1500)
                isProcessing = false                        
            end
        end
    end    
end

-- StageThree //
function StageThree()
    isProcessing = true
    mixfosfor = true
        TriggerEvent("mythic_progbar:client:progress", {
                name = "melanger",
                duration = 5000,
                label = "Pones acetona y fósforo en la licuadora...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "amb@medic@standing@tendtodead@base",
                    anim = "base",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end) 
         Citizen.Wait(5000)
        exports['mythic_notify']:SendAlert("inform", "El proceso tardar 1 minuto")
        Citizen.Wait(60000)
        exports['mythic_notify']:SendAlert("inform", "El proceso de mezcla ha terminado ya puedes obtener la mezcla")
        while mixfosfor do
            Citizen.Wait(1)
        local playerPed = GetEntityCoords(PlayerPedId())
        local dst = GetDistanceBetweenCoords(playerPed, Config.kordinatlar.fosfor.x, Config.kordinatlar.fosfor.y, Config.kordinatlar.fosfor.z, true)
        if dst <= 1 and mixfosfor then
            ESX.ShowFloatingHelpNotification("Pulsa ~y~E~w~ para obtener la mezcla" , vector3(Config.kordinatlar.fosfor.x, Config.kordinatlar.fosfor.y, Config.kordinatlar.fosfor.z))
            if IsControlJustPressed(0, 38) then
                TriggerEvent("mythic_progbar:client:progress", {
                name = "bottleone",
                duration = 2500,
                label = "Cogiendo la mezcla...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "creatures@rottweiler@tricks@",
                    anim = "petting_franklin",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end) 
         Citizen.Wait(2500)
                TriggerServerEvent("esx_bala_meta:giveItem", "mixedmeth", 1)  
                mixfosfor = false 
                Citizen.Wait(1500)
                isProcessing = false                       
            end
        end
    end    
end


function StageFour()
    isProcessing = true
    TriggerServerEvent("esx_bala_meta:removeItem", "mixedmeth", 1)
        TriggerEvent("mythic_progbar:client:progress", {
                name = "acetone",
                duration = 10000,
                label = "Le matériau est versé dans le four...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "mini@repair",
                    anim = "fixing_a_ped",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end)      
        Citizen.Wait(10000)
        TriggerEvent("esx_bala_meta:questionstwo")
end


RegisterNetEvent("esx_bala_meta:questions")
AddEventHandler("esx_bala_meta:questions", function()
    local miktar = math.random(100,500)
    local chance = nil
    if miktar >=100 and miktar <= 150 then
        chance = 5
    elseif miktar >=150 and miktar <= 200 then
        chance = 2
    elseif miktar >=200 and miktar <= 250 then
        chance = 4
    elseif miktar >=250 and miktar <= 300 then
        chance = 1
    elseif miktar >=300 and miktar <= 350 then
        chance = 3
    elseif miktar >=350 and miktar <= 400 then
        chance = 6
    elseif miktar >=450 and miktar <= 500 then
        chance = 7
    end
    ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'fosforquest', 
  {
    title    = (miktar.. Config.questions.title),
    align = 'center', 
    elements = { 
      {label = (Config.questions.steps[1].label),     value = Config.questions.steps[1].value},
      {label = (Config.questions.steps[2].label),     value = Config.questions.steps[2].value},
      {label = (Config.questions.steps[3].label),     value = Config.questions.steps[3].value},
      {label = (Config.questions.steps[4].label),     value = Config.questions.steps[4].value},
      {label = (Config.questions.steps[5].label),     value = Config.questions.steps[5].value},
      {label = (Config.questions.steps[6].label),     value = Config.questions.steps[6].value},
      {label = (Config.questions.steps[7].label),     value = Config.questions.steps[7].value},
    }
  },  function(data, menu) 
    if data.current.value == chance then
        menu.close()
        TriggerServerEvent("esx_bala_meta:removeItem", "distilledbottle", 2)
        TriggerServerEvent("esx_bala_meta:removeItem", "phosphorus", 2)
        StageThree()
    else
        menu.close() 
        TriggerServerEvent("esx_bala_meta:removeItem", "distilledbottle", 2)
        TriggerServerEvent("esx_bala_meta:removeItem", "phosphorus", 2)
        fakeStart()
    end   
  end,
  function(data, menu) 
      menu.close() 
  end)
end)

function fakeStart()
    isProcessing = true
    mixfosfor = true
        TriggerEvent("mythic_progbar:client:progress", {
                name = "melanger2",
                duration = 5000,
                label = "Poniendo acetona y fósforo en la licuadora...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "amb@medic@standing@tendtodead@base",
                    anim = "base",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end) 
         Citizen.Wait(5000)
        exports['mythic_notify']:SendAlert("inform", "El proceso de mezcla terminará después de 1 minuto.")
        Citizen.Wait(60000)
        exports['mythic_notify']:SendAlert("inform", "El proceso de mezcla está terminado, puedes obtener la mezcla.")
        while mixfosfor do
            Citizen.Wait(1)
        local playerPed = GetEntityCoords(PlayerPedId())
        local dst = GetDistanceBetweenCoords(playerPed, Config.kordinatlar.fosfor.x, Config.kordinatlar.fosfor.y, Config.kordinatlar.fosfor.z, true)
        if dst <= 1 and mixfosfor then
            DrawText3D("Pulsa ~y~E~w~ para obtener la mezcla", vector3(Config.kordinatlar.fosfor.x, Config.kordinatlar.fosfor.y, Config.kordinatlar.fosfor.z))
            if IsControlJustPressed(0, 38) then
                TriggerEvent("mythic_progbar:client:progress", {
                name = "fosfor",
                duration = 2500,
                label = "Obtenir le mélange...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "creatures@rottweiler@tricks@",
                    anim = "petting_franklin",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end) 
         Citizen.Wait(2500)
                exports['mythic_notify']:SendAlert("error", "Impossible d'obtenir le paramètre...")
                Citizen.Wait(1000)
                animasyon(PlayerPedId(), "gestures@m@standing@casual", "gesture_damn")
                TriggerEvent("esx_bala_meta:gasiscoming", true)
                mixfosfor = false 
                Citizen.Wait(1500)
                isProcessing = false                     
            end
        end
    end    
end


RegisterNetEvent("esx_bala_meta:questionstwo")
AddEventHandler("esx_bala_meta:questionstwo", function()
    isProcessing = true
    local player = PlayerPedId()
    exports['mythic_notify']:SendAlert("inform", "La estufa comenzó a funcionar a 450 grados.")
    Citizen.Wait(2000)
    exports['mythic_notify']:SendAlert("inform", "Párese frente a la estufa y ajuste la calidad del material.")
     TriggerEvent("mythic_progbar:client:progress", {
                name = "fusion",
                duration = 20000,
                label = "Removiendo el polvo...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "random@shop_tattoo",
                    anim = "_idle_a",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end) 
    Citizen.Wait(20000)
    if isProcessing then
    ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'smelttwo', 
  {
    title    = (Config.questions.titletwo),
    align = 'center', 
    elements = { 
      {label = (Config.questions.stepstwo[1].label),     value = Config.questions.stepstwo[1].value},
      {label = (Config.questions.stepstwo[2].label),     value = Config.questions.stepstwo[2].value},
      {label = (Config.questions.stepstwo[3].label),     value = Config.questions.stepstwo[3].value},
    }
  },  function(data, menu) 
    if data.current.value == 1 then
        menu.close()
        ESX.TriggerServerCallback("esx_bala_meta:checkItem", function(output)
            if output then
            TriggerServerEvent("esx_bala_meta:removeItem", "aluminyum", 2)
            TriggerEvent("esx_bala_meta:questionsthree")
            elseif not output then          
            exports['mythic_notify']:SendAlert("error", "Sin aluminio tonto!")
            TriggerEvent("esx_bala_meta:stepone")
            TriggerEvent("esx_bala_meta:questionsthree")
            end
            end, "aluminyum", 2)        
    else
        menu.close() 
       TriggerEvent("esx_bala_meta:stepone")
       TriggerEvent("esx_bala_meta:questionsthree")
    end   
  end,
  function(data, menu) 
      menu.close() 
  end)
end
end)

RegisterNetEvent("esx_bala_meta:questionsthree")
AddEventHandler("esx_bala_meta:questionsthree", function()
     TriggerEvent("mythic_progbar:client:progress", {
                name = "smeltingthree",
                duration = 20000,
                label = "Cocinando...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "random@shop_tattoo",
                    anim = "_idle_a",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end) 
    Citizen.Wait(20000)
    if isProcessing then
    ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'smeltthree', 
  {
    title    = (Config.questions.titlethree),
    align = 'center', 
    elements = { 
      {label = (Config.questions.stepsthree[1].label),     value = Config.questions.stepsthree[1].value},
      {label = (Config.questions.stepsthree[2].label),     value = Config.questions.stepsthree[2].value},
      {label = (Config.questions.stepsthree[3].label),     value = Config.questions.stepsthree[3].value},
    }
  },  function(data, menu) 
    if data.current.value == 2 then
        menu.close() 
      TriggerEvent("esx_bala_meta:questionsfour")
    else
        menu.close() 
       TriggerEvent("esx_bala_meta:stepone")
       TriggerEvent("esx_bala_meta:questionsfour")
    end   
  end,
  function(data, menu) 
      menu.close() 
  end)
end
end)

RegisterNetEvent("esx_bala_meta:questionsfour")
AddEventHandler("esx_bala_meta:questionsfour", function()
     TriggerEvent("mythic_progbar:client:progress", {
                name = "smeltingfour",
                duration = 20000,
                label = "Removiendo el polvo...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "random@shop_tattoo",
                    anim = "_idle_a",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end) 
    Citizen.Wait(20000)
    if isProcessing then
    ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'smeltfour', 
  {
    title    = (Config.questions.titlefour),
    align = 'center', 
    elements = { 
      {label = (Config.questions.stepsfour[1].label),     value = Config.questions.stepsfour[1].value},
      {label = (Config.questions.stepsfour[2].label),     value = Config.questions.stepsfour[2].value},
      {label = (Config.questions.stepsfour[3].label),     value = Config.questions.stepsfour[3].value},
    }
  },  function(data, menu) 
    if data.current.value == 3 then
        menu.close() 
         TriggerEvent("mythic_progbar:client:progress", {
                name = "smeltingfour",
                duration = 20000,
                label = "Removiendo el polvo...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "random@shop_tattoo",
                    anim = "_idle_a",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end) 
         Citizen.Wait(20000)
        isProcessing = false
        TriggerEvent("esx_bala_meta:succes")
    else
        menu.close() 
                 TriggerEvent("mythic_progbar:client:progress", {
                name = "smeltingfour",
                duration = 20000,
                label = "Removiendo el polvo...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "random@shop_tattoo",
                    anim = "_idle_a",
                 },
                prop = {
                    -- model = "p_cs_script_bottle_s",
                 }
             }, function(status)
              if not status then
               end
         end) 
         Citizen.Wait(20000)
        isProcessing = false
        TriggerEvent("esx_bala_meta:succes")  
    end   
  end,
  function(data, menu) 
      menu.close() 
  end)
end
end)

RegisterNetEvent("esx_bala_meta:stepone")
AddEventHandler("esx_bala_meta:stepone", function()
    sayac = sayac + 1
end)


RegisterNetEvent("esx_bala_meta:succes")
AddEventHandler("esx_bala_meta:succes", function()
    if sayac == 0 then
        TriggerServerEvent("esx_bala_meta:giveItem", "meth", 6)
    elseif sayac == 1 then
        TriggerServerEvent("esx_bala_meta:giveItem", "meth", 4)
    elseif sayac == 2 then
        TriggerServerEvent("esx_bala_meta:giveItem", "meth", 2)
    elseif sayac == 3 then
        exports['mythic_notify']:SendAlert("error", "La calidad del material se ve terrible, no vale nada...")
    end
end)

RegisterCommand('methiptal', function()
TriggerEvent("esx_bala_meta:break", false)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1) 
        local sleep = 1000
        local player = PlayerPedId()
        if IsEntityDead(player) or not DoesEntityExist(player) then
		if isProcessing then
            exports['mythic_notify']:SendAlert("error", "Todas tus posesiones desperdiciadas por tu muerte..")
            TriggerEvent("esx_bala_meta:break", false)
		end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("esx_bala_meta:break")
AddEventHandler("esx_bala_meta:break", function(durum)
isProcessing = durum
FreezeEntityPosition(PlayerPedId(), false)
ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("esx_bala_meta:gasiscoming")
AddEventHandler("esx_bala_meta:gasiscoming", function(startGas)
    while true do   
        inGas = startGas
        Citizen.Wait(1)
        local sleep = 1000
        local gasCenter = vector3(1095.34,-3194.92,-38.92)
        local player = PlayerPedId()
        local playerCoord = GetEntityCoords(player)
        local dst = GetDistanceBetweenCoords(playerCoord, gasCenter, true)
        RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Citizen.Wait(10)
        end
        if inGas == true then
            sleep = 0
            SetPtfxAssetNextCall("core")
            Gas = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", gasCenter, 0.0, 0.0, 0.0, 0.80, false, false, false, false)          
            Citizen.Wait(10000)
            exports['mythic_notify']:SendAlert("error", "El gas de la licuadora te dañó los pulmones..")
            startGas = false 
            ApplyDamageToPed(player, 10, true)
            StopParticleFxLooped(Gas, 0)          
        end       
        Citizen.Wait(sleep)
    end
end)



-- 3D text lieu de traction //
function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 250
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 140)
end

-- Envoyer la fonction d'animation //
function animasyon(ped, ad, anim)  -- échantillon // animation(playerPed, "mp_common", "givetake1_a")
	ESX.Streaming.RequestAnimDict(ad, function()
		TaskPlayAnim(ped, ad, anim, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
	end)
end
