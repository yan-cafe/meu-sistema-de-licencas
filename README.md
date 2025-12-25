# Sistema de Poder Exclusivo de Vampiro - FiveM

## Descrição
Este recurso implementa um poder exclusivo para vampiros no FiveM, permitindo que jogadores vampiros usem uma habilidade especial que causa uma sequência de animação de bêbado seguida de morte no alvo.

## Características

### Funcionalidades Principais
- ✅ **Exclusivo para Vampiros**: Apenas jogadores marcados como vampiros podem usar o poder
- ✅ **Animação de Bêbado**: O alvo cambaleará por 5 segundos antes de morrer
- ✅ **Bloqueio de Controle**: O alvo não pode controlar o personagem durante a animação
- ✅ **Sincronização**: Animações visíveis para todos os jogadores próximos
- ✅ **Efeitos Visuais e Sonoros**: Sons e efeitos de tela durante a ativação
- ✅ **Morte Definitiva**: Após a animação, o alvo morre sem possibilidade de reviver automaticamente

### Efeitos Aplicados
- Som de morte (WastedSounds)
- Efeito de tela (DeathFailOut)
- Animação de bêbado/drogado (WORLD_HUMAN_DRUG_DEALER)
- Tremor de câmera opcional
- Congelamento do personagem durante animação
- Morte automática após 5 segundos

## Instalação

1. Clone ou baixe este repositório
2. Coloque a pasta na sua pasta de recursos do servidor FiveM
3. Adicione ao `server.cfg`:
```
ensure meu-sistema-de-licencas
```
4. Reinicie o servidor

## Comandos

### Administração
```
/setvampiro [id] - Define um jogador como vampiro
/removevampiro [id] - Remove o status de vampiro de um jogador
```

### Uso do Poder
```
/podervampiro [id] - Usa o poder vampiro no jogador alvo (apenas vampiros)
```

## Como Funciona

### Fluxo de Execução

1. **Ativação**: Um jogador vampiro usa `/podervampiro [id]` no alvo
2. **Verificação**: O servidor verifica se o jogador é um vampiro válido
3. **Aplicação do Efeito**:
   - Sons e efeitos visuais são ativados
   - O alvo é congelado no lugar
   - Animação de bêbado começa
   - Outros jogadores veem a animação sincronizada
4. **Morte**: Após 5 segundos, o alvo morre automaticamente

### Segurança
- Apenas vampiros registrados podem usar o poder
- Não é possível usar o poder em si mesmo
- Verificação de jogador online antes de aplicar efeitos
- Limpeza automática de status ao desconectar

## Estrutura de Arquivos

```
meu-sistema-de-licencas/
├── fxmanifest.lua      # Manifesto do recurso
├── config.lua          # Configurações centralizadas
├── server.lua          # Lógica servidor (verificações, morte)
├── client.lua          # Lógica cliente (animações, efeitos)
├── licencas.json       # Arquivo de licenças (opcional)
└── README.md           # Este arquivo
```

## Configuração

Você pode ajustar as configurações no `config.lua`:

```lua
-- Configurações de animação
Config.AnimationDuration = 5000 -- Duração da animação em milissegundos (5 segundos)
Config.DrunkScenario = 'WORLD_HUMAN_DRUG_DEALER' -- Cenário de animação de bêbado

-- Configurações de som
Config.SoundEffect = 'Bed' -- Nome do efeito sonoro
Config.SoundSet = 'WastedSounds' -- Conjunto de sons

-- Configurações de efeitos visuais
Config.ScreenEffect = 'DeathFailOut' -- Efeito de tela

-- Outras configurações disponíveis:
-- - Config.UseCooldown: Habilita/desabilita cooldown
-- - Config.CooldownTime: Tempo de cooldown em ms
-- - Config.MaxDistance: Distância máxima para usar o poder
-- - Config.UsePermissions: Habilita verificação de permissões ACE
-- - Config.Notifications: Mensagens personalizadas
```

## Exemplos de Uso

### Exemplo 1: Definir Vampiro
```
Admin: /setvampiro 1
Sistema: Jogador 1 agora é um vampiro!
```

### Exemplo 2: Usar Poder
```
Vampiro (ID 1): /podervampiro 2
Sistema: Poder usado em PlayerName!
[Jogador 2 entra em animação de bêbado por 5 segundos]
[Jogador 2 morre]
```

## Requisitos Técnicos

- FiveM Server (última versão recomendada)
- Game Build: GTA V
- Framework: Standalone (não requer framework específico)

## Troubleshooting

### O poder não funciona
- Verifique se o jogador foi definido como vampiro com `/setvampiro`
- Confirme que o ID do alvo está correto
- Verifique os logs do servidor para erros

### Animação não aparece
- Certifique-se de que o recurso está iniciado corretamente
- Verifique se há conflitos com outros recursos de animação
- Tente reiniciar o recurso: `restart meu-sistema-de-licencas`

### Morte não ocorre
- Verifique se não há recursos que impedem morte
- Confirme que o evento está sendo disparado no servidor

## Suporte e Contribuições

Para reportar bugs ou sugerir melhorias, abra uma issue no repositório.

## Licença

Este projeto está sob a licença MIT. Sinta-se livre para modificar e usar conforme necessário.

## Autor

Yan Cafe

## Changelog

### v1.0.0
- Lançamento inicial
- Implementação do poder vampiro
- Sistema de animação de bêbado
- Sincronização entre jogadores
- Efeitos visuais e sonoros
