-- Server-side script for Vampire Power System
local vampiros = {} -- Store vampire players

-- Function to check if player is vampire
function IsVampire(source)
    return vampiros[source] == true
end

-- Command to set a player as vampire (admin only)
RegisterCommand('setvampiro', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    if targetId then
        vampiros[targetId] = true
        TriggerClientEvent('chat:addMessage', source, {
            args = {'[Sistema]', 'Jogador ' .. targetId .. ' agora é um vampiro!'}
        })
        TriggerClientEvent('chat:addMessage', targetId, {
            args = {'[Sistema]', 'Você agora é um vampiro! Use /podervampiro [id] para usar seu poder.'}
        })
    end
end, false)

-- Command to remove vampire status
RegisterCommand('removevampiro', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    if targetId then
        vampiros[targetId] = false
        TriggerClientEvent('chat:addMessage', source, {
            args = {'[Sistema]', 'Jogador ' .. targetId .. ' não é mais um vampiro!'}
        })
    end
end, false)

-- Event triggered when vampire uses power on target
RegisterServerEvent('vampire:usePower')
AddEventHandler('vampire:usePower', function(targetId)
    local source = source
    
    -- Verify if source is a vampire
    if not IsVampire(source) then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'[Sistema]', 'Você não é um vampiro!'}
        })
        return
    end
    
    -- Verify if target exists and is online
    if not targetId or GetPlayerName(targetId) == nil then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'[Sistema]', 'Jogador não encontrado!'}
        })
        return
    end
    
    -- Verify if target is not the same player
    if source == targetId then
        TriggerClientEvent('chat:addMessage', source, {
            args = {'[Sistema]', 'Você não pode usar o poder em si mesmo!'}
        })
        return
    end
    
    -- Notify the vampire
    TriggerClientEvent('chat:addMessage', source, {
        args = {'[Vampiro]', 'Poder usado em ' .. GetPlayerName(targetId) .. '!'}
    })
    
    -- Trigger the power effect on the target (client-side)
    TriggerClientEvent('vampire:applyPowerEffect', targetId, source)
    
    -- Sync animation to all nearby players
    TriggerClientEvent('vampire:syncAnimation', -1, targetId, source)
end)

-- Event to trigger death after animation
RegisterServerEvent('vampire:killTarget')
AddEventHandler('vampire:killTarget', function()
    local source = source
    
    -- Set player health to 0 (death)
    TriggerClientEvent('vampire:executeDeath', source)
end)

-- Clean up vampire status when player disconnects
AddEventHandler('playerDropped', function(reason)
    local source = source
    if vampiros[source] then
        vampiros[source] = nil
    end
end)

print('^2[Vampire System] ^7Server-side loaded successfully!^0')
