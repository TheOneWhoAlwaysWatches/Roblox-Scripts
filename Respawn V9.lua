-- Ultra-Max Respawn Script

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Global state (so script doesn’t double-run if executed twice)
_G.RespawnScript = _G.RespawnScript or { Active = false, Connections = {} }

-- Disconnect all stored connections
local function disconnectAll()
    for _, connection in ipairs(_G.RespawnScript.Connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    _G.RespawnScript.Connections = {}
end

-- Force the fastest possible respawn
local function forceRespawn()
    if ReplicatedStorage:FindFirstChild("Guide") then
        ReplicatedStorage.Guide:FireServer() -- Try the game’s built-in respawn remote
    elseif LocalPlayer and LocalPlayer:FindFirstChild("LoadCharacter") then
        LocalPlayer:LoadCharacter() -- Roblox’s native instant respawn
    else
        warn("[RespawnScript] No respawn method found (Guide or LoadCharacter).")
    end
end

-- Setup when character is added
local function onCharacterAdded(character)
    if not _G.RespawnScript.Active then return end
    local humanoid = character:WaitForChild("Humanoid", 2)
    if not humanoid then return end

    local hasRespawned = false

    -- Respawn BEFORE ragdoll (when health hits 1 or less)
    local healthConnection = humanoid.HealthChanged:Connect(function(health)
        if health <= 1 and _G.RespawnScript.Active and not hasRespawned then
            hasRespawned = true
            forceRespawn()
        end
    end)
    table.insert(_G.RespawnScript.Connections, healthConnection)

    -- Backup: if death actually fires
    local deathConnection = humanoid.Died:Connect(function()
        if _G.RespawnScript.Active and not hasRespawned then
            hasRespawned = true
            forceRespawn()
        end
    end)
    table.insert(_G.RespawnScript.Connections, deathConnection)
end

-- Toggle script on/off
local function toggleScript()
    if _G.RespawnScript.Active then
        print("[RespawnScript] Deactivating...")
        _G.RespawnScript.Active = false
        disconnectAll()
    else
        print("[RespawnScript] Activating...")
        _G.RespawnScript.Active = true

        -- Watch for new characters
        local charAddedConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        table.insert(_G.RespawnScript.Connections, charAddedConnection)

        -- If already spawned, hook current character
        if LocalPlayer.Character then
            onCharacterAdded(LocalPlayer.Character)
        else
            forceRespawn()
        end
    end
end

-- Start by toggling ON
toggleScript()
