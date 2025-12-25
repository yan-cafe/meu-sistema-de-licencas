-- Client-side script for Vampire Power System

-- Configuration
local Config = {
    animationDuration = 5000, -- Duration of drunk animation in milliseconds (5 seconds)
    drunkScenario = 'WORLD_HUMAN_DRUG_DEALER', -- Scenario for drunk-like animation
    soundEffect = 'Bed', -- Sound effect name
    soundSet = 'WastedSounds', -- Sound set name
    screenEffect = 'DeathFailOut', -- Screen effect
}

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
    PlaySoundFrontend(-1, Config.soundEffect, Config.soundSet, true)
    
    -- Start screen effect
    StartScreenEffect(Config.screenEffect, 0, true)
    
    -- Notify player
    TriggerEvent('chat:addMessage', {
        args = {'[Vampiro]', 'Você foi atingido pelo poder do vampiro!'}
    })
    
    -- Freeze player controls
    FreezeEntityPosition(playerPed, true)
    SetEntityInvincible(playerPed, true)
    
    -- Start drunk animation
    TaskStartScenarioInPlace(playerPed, Config.drunkScenario, 0, true)
    
    -- Wait for animation duration
    Citizen.Wait(Config.animationDuration)
    
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
    
    -- Ensure player dies
    NetworkExplodeVehicle(GetVehiclePedIsIn(playerPed, false), true, false, 0)
    
    -- Stop screen effect after death
    Citizen.Wait(1000)
    StopScreenEffect(Config.screenEffect)
end)

-- Event to sync animation to nearby players
RegisterNetEvent('vampire:syncAnimation')
AddEventHandler('vampire:syncAnimation', function(targetId, vampireId)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    
    if targetPed and targetPed ~= PlayerPedId() then
        -- Play the drunk scenario on the target for other players
        Citizen.CreateThread(function()
            TaskStartScenarioInPlace(targetPed, Config.drunkScenario, 0, true)
            Citizen.Wait(Config.animationDuration)
            ClearPedTasksImmediately(targetPed)
        end)
    end
end)

-- Alternative drunk animation system (fallback)
function PlayDrunkAnimation(ped)
    RequestAnimSet('move_m@drunk@verydrunk')
    
    while not HasAnimSetLoaded('move_m@drunk@verydrunk') do
        Citizen.Wait(10)
    end
    
    SetPedMovementClipset(ped, 'move_m@drunk@verydrunk', 1.0)
    
    -- Also play stumbling animation
    RequestAnimDict('amb@world_human_bum_standing@drunk@idle_a')
    
    while not HasAnimDictLoaded('amb@world_human_bum_standing@drunk@idle_a') do
        Citizen.Wait(10)
    end
    
    TaskPlayAnim(ped, 'amb@world_human_bum_standing@drunk@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0, false, false, false)
end

-- Enhanced drunk effect with camera shake
function ApplyDrunkEffect(ped)
    -- Shake camera
    ShakeGameplayCam('DRUNK_SHAKE', 1.0)
    
    -- Set drunk movement
    SetPedMovementClipset(ped, 'move_m@drunk@verydrunk', 1.0)
    
    -- Set time scale to slow motion briefly
    Citizen.CreateThread(function()
        SetTimecycleModifier('spectator5')
        Citizen.Wait(Config.animationDuration)
        ClearTimecycleModifier()
        StopGameplayCamShaking(true)
    end)
end

-- Visual particle effects (optional enhancement)
function PlayVampireEffect(ped)
    local coords = GetEntityCoords(ped)
    
    -- Request particle effects
    RequestNamedPtfxAsset('core')
    
    while not HasNamedPtfxAssetLoaded('core') do
        Citizen.Wait(10)
    end
    
    -- Play blood effect
    UseParticleFxAssetNextCall('core')
    StartParticleFxNonLoopedAtCoord('blood_stab', coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
end

print('^2[Vampire System] ^7Client-side loaded successfully!^0')
