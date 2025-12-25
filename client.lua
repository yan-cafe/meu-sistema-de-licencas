-- Client-side script for Vampire Power System

-- Command to use vampire power on target
RegisterCommand('podervampiro', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    
    if not targetId then
        TriggerEvent('chat:addMessage', {
            args = {'[Sistema]', 'Use: /podervampiro [id]'}
        })
        return
    end
    
    -- Send request to server to verify and apply power
    TriggerServerEvent('vampire:usePower', targetId)
end, false)

-- Event when vampire power is applied to this player (victim)
RegisterNetEvent('vampire:applyPowerEffect')
AddEventHandler('vampire:applyPowerEffect', function(vampireId)
    local playerPed = PlayerPedId()
    
    -- Play sound effect
    PlaySoundFrontend(-1, Config.SoundEffect, Config.SoundSet, true)
    
    -- Start screen effect
    StartScreenEffect(Config.ScreenEffect, 0, true)
    
    -- Notify player
    TriggerEvent('chat:addMessage', {
        args = {'[Vampiro]', Config.Notifications.PowerReceived}
    })
    
    -- Freeze player controls
    FreezeEntityPosition(playerPed, true)
    SetEntityInvincible(playerPed, true)
    
    -- Start drunk animation
    TaskStartScenarioInPlace(playerPed, Config.DrunkScenario, 0, true)
    
    -- Wait for animation duration
    Citizen.Wait(Config.AnimationDuration)
    
    -- Stop scenario and unfreeze
    ClearPedTasksImmediately(playerPed)
    FreezeEntityPosition(playerPed, false)
    SetEntityInvincible(playerPed, false)
    
    -- Request death from server
    TriggerServerEvent('vampire:killTarget')
end)

-- Event to execute death
RegisterNetEvent('vampire:executeDeath')
AddEventHandler('vampire:executeDeath', function()
    local playerPed = PlayerPedId()
    
    -- Set health to 0
    SetEntityHealth(playerPed, 0)
    
    -- Stop screen effect after death
    Citizen.Wait(1000)
    StopScreenEffect(Config.ScreenEffect)
end)

-- Event to sync animation to nearby players
RegisterNetEvent('vampire:syncAnimation')
AddEventHandler('vampire:syncAnimation', function(targetId, vampireId)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    
    if targetPed and targetPed ~= PlayerPedId() then
        -- Play the drunk scenario on the target for other players
        Citizen.CreateThread(function()
            TaskStartScenarioInPlace(targetPed, Config.DrunkScenario, 0, true)
            Citizen.Wait(Config.AnimationDuration)
            ClearPedTasksImmediately(targetPed)
        end)
    end
end)

-- Alternative drunk animation system (fallback)
function PlayDrunkAnimation(ped)
    local animSet = 'move_m@drunk@verydrunk'
    RequestAnimSet(animSet)
    
    while not HasAnimSetLoaded(animSet) do
        Citizen.Wait(10)
    end
    
    SetPedMovementClipset(ped, animSet, 1.0)
    
    -- Also play stumbling animation
    local animDict = 'amb@world_human_bum_standing@drunk@idle_a'
    RequestAnimDict(animDict)
    
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    
    TaskPlayAnim(ped, animDict, 'idle_a', 8.0, -8.0, -1, 1, 0, false, false, false)
    
    -- Cleanup after use
    Citizen.SetTimeout(10000, function()
        RemoveAnimSet(animSet)
        RemoveAnimDict(animDict)
    end)
end

-- Enhanced drunk effect with camera shake
function ApplyDrunkEffect(ped)
    local animSet = 'move_m@drunk@verydrunk'
    
    -- Shake camera
    ShakeGameplayCam('DRUNK_SHAKE', 1.0)
    
    -- Request and set drunk movement
    RequestAnimSet(animSet)
    while not HasAnimSetLoaded(animSet) do
        Citizen.Wait(10)
    end
    SetPedMovementClipset(ped, animSet, 1.0)
    
    -- Set time scale to slow motion briefly
    Citizen.CreateThread(function()
        SetTimecycleModifier('spectator5')
        Citizen.Wait(Config.AnimationDuration)
        ClearTimecycleModifier()
        StopGameplayCamShaking(true)
        
        -- Cleanup
        RemoveAnimSet(animSet)
    end)
end

-- Visual particle effects (optional enhancement)
function PlayVampireEffect(ped)
    local coords = GetEntityCoords(ped)
    local ptfxAsset = 'core'
    
    -- Request particle effects
    RequestNamedPtfxAsset(ptfxAsset)
    
    while not HasNamedPtfxAssetLoaded(ptfxAsset) do
        Citizen.Wait(10)
    end
    
    -- Play blood effect
    UseParticleFxAssetNextCall(ptfxAsset)
    StartParticleFxNonLoopedAtCoord('blood_stab', coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
    
    -- Cleanup after effect
    Citizen.SetTimeout(5000, function()
        RemoveNamedPtfxAsset(ptfxAsset)
    end)
end

print('^2[Vampire System] ^7Client-side loaded successfully!^0')
