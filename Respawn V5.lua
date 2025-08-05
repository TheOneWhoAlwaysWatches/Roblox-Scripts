local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Configuración del estado del script
_G.RespawnScript = _G.RespawnScript or { Active = false, Connections = {} }

-- Función para desconectar todas las conexiones activas
local function disconnectAll()
    for _, connection in ipairs(_G.RespawnScript.Connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    _G.RespawnScript.Connections = {}
end

-- Fuerza un respawn inmediato con la función más rápida disponible
local function forceRespawn()
    if ReplicatedStorage:FindFirstChild("Guide") then
        ReplicatedStorage.Guide:FireServer() -- Llama al evento de respawn
    elseif LocalPlayer and LocalPlayer:FindFirstChild("LoadCharacter") then
        LocalPlayer:LoadCharacter() -- Alternativa más rápida si está disponible
    else
        print("[RespawnScript] No se encontró 'Guide' ni 'LoadCharacter'.")
    end
end

-- Maneja el evento `CharacterAdded`
local function onCharacterAdded(character)
    if not _G.RespawnScript.Active then return end

    local humanoid = character:WaitForChild("Humanoid", 3)
    if not humanoid then return end

    -- Asegura que solo se haga una vez el respawn por muerte
    local hasRespawned = false

    -- Conectar el evento de muerte para respawn inmediato
    local deathConnection = humanoid.Died:Connect(function()
        if _G.RespawnScript.Active and not hasRespawned then
            hasRespawned = true
            forceRespawn()
        end
    end)

    table.insert(_G.RespawnScript.Connections, deathConnection)

    -- Respawn instantáneo al detectar vida en 0
    local healthConnection = humanoid.HealthChanged:Connect(function(health)
        if health <= 0 and _G.RespawnScript.Active and not hasRespawned then
            hasRespawned = true
            forceRespawn()
        end
    end)

    table.insert(_G.RespawnScript.Connections, healthConnection)
end

-- Alterna el estado del script
local function toggleScript()
    if _G.RespawnScript.Active then
        print("[RespawnScript] Desactivando...")
        _G.RespawnScript.Active = false
        disconnectAll()
    else
        print("[RespawnScript] Activando...")
        _G.RespawnScript.Active = true

        -- Conexión al evento `CharacterAdded`
        local charAddedConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        table.insert(_G.RespawnScript.Connections, charAddedConnection)

        -- Maneja el personaje actual si ya está cargado
        if LocalPlayer.Character then
            onCharacterAdded(LocalPlayer.Character)
        else
            -- Si el personaje no existe, fuerza el respawn
            forceRespawn()
        end
    end
end

-- Ejecuta la función para alternar el estado
toggleScript()
