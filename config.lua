-- Configuração do Sistema de Poder Vampiro
Config = {}

-- Configurações de animação
Config.AnimationDuration = 5000 -- Duração da animação em milissegundos (5 segundos)
Config.DrunkScenario = 'WORLD_HUMAN_DRUG_DEALER' -- Cenário de animação de bêbado

-- Configurações de som
Config.SoundEffect = 'Bed' -- Nome do efeito sonoro
Config.SoundSet = 'WastedSounds' -- Conjunto de sons

-- Configurações de efeitos visuais
Config.ScreenEffect = 'DeathFailOut' -- Efeito de tela

-- Configurações de permissões
Config.UsePermissions = false -- Se true, verifica permissões do ACE
Config.PermissionName = 'vampire.power' -- Nome da permissão ACE

-- Configurações de cooldown
Config.UseCooldown = true -- Se true, adiciona cooldown ao poder
Config.CooldownTime = 30000 -- Tempo de cooldown em milissegundos (30 segundos)

-- Configurações de distância
Config.MaxDistance = 10.0 -- Distância máxima para usar o poder (em metros)

-- Configurações de notificações
Config.Notifications = {
    NotVampire = 'Você não é um vampiro!',
    PlayerNotFound = 'Jogador não encontrado!',
    CannotUseSelf = 'Você não pode usar o poder em si mesmo!',
    PowerUsed = 'Poder usado em %s!',
    PowerReceived = 'Você foi atingido pelo poder do vampiro!',
    Cooldown = 'Aguarde %s segundos para usar o poder novamente!',
    TooFar = 'O alvo está muito longe!',
    SetVampire = 'Jogador %s agora é um vampiro!',
    RemoveVampire = 'Jogador %s não é mais um vampiro!',
    VampireStatus = 'Você agora é um vampiro! Use /podervampiro [id] para usar seu poder.',
}

-- Configurações de logs
Config.EnableLogs = true -- Se true, registra uso do poder
Config.LogWebhook = '' -- Webhook do Discord para logs (opcional)
