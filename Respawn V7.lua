-- Instant Respawn Script (Optimized)
-- Purpose: Respawns the player on the exact tick they die, no spam, no delay.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Script State
_G.RespawnScript = _G.RespawnScript or { Active = false, Connections = {} }

-- Disconnect all active connections
local function disconnectAll()
    for _, connection in ipairs(_G.RespawnScript.Connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    _G.RespawnScript.Connections = {}
end

-- Force an instant respawn using the fastest available method
local function forceRespawn()
    if ReplicatedStorage:FindFirstChild("Guide") then
        ReplicatedStorage.Guide:FireServer() -- Preferred respawn remote
    elseif LocalPlayer and LocalPlayer:FindFirstChild("LoadCharacter") then
        LocalPlayer:LoadCharacter() -- Fallback direct method
    else
        warn("[RespawnScript] Could not find 'Guide' or 'LoadCharacter'.")
    end
end

-- Set up death detection for a character
local function onCharacterAdded(character)
    if not _G.RespawnScript.Active then return end

    local humanoid = character:WaitForChild("Humanoid", 2)
    if not humanoid then return end

    local hasRespawned = false

    -- Tick-perfect: Trigger on the exact death frame
    local deathConnection = humanoid.Died:Connect(function()
        if _G.RespawnScript.Active and not hasRespawned then
            hasRespawned = true
            forceRespawn()
        end
    end)

    table.insert(_G.RespawnScript.Connections, deathConnection)

    -- Extra safety: if death somehow wasn’t caught
    local healthConnection = humanoid.HealthChanged:Connect(function(health)
        if health <= 0 and _G.RespawnScript.Active and not hasRespawned then
            hasRespawned = true
            forceRespawn()
        end
    end)

    table.insert(_G.RespawnScript.Connections, healthConnection)
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

        -- Always listen for new characters
        local charAddedConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        table.insert(_G.RespawnScript.Connections, charAddedConnection)

        -- If already alive, set up immediately
        if LocalPlayer.Character then
            onCharacterAdded(LocalPlayer.Character)
        else
            forceRespawn()
        end
    end
end

-- Start script
toggleScript()
