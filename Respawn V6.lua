local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

_G.RespawnScript = _G.RespawnScript or { Active = false, Connections = {} }

local function disconnectAll()
    for _, conn in ipairs(_G.RespawnScript.Connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    _G.RespawnScript.Connections = {}
end

local function forceRespawn()
    local guide = ReplicatedStorage:FindFirstChild("Guide")
    if guide then
        guide:FireServer()
    else
        LocalPlayer:LoadCharacter()
    end
end

local function onCharacterAdded(character)
    if not _G.RespawnScript.Active then return end

    local humanoid = character:WaitForChild("Humanoid", 3)
    if not humanoid then return end

    local hasRespawned = false

    -- Fires the microsecond character starts being removed
    table.insert(_G.RespawnScript.Connections, character.AncestryChanged:Connect(function(_, parent)
        if _G.RespawnScript.Active and not parent and not hasRespawned then
            hasRespawned = true
            task.spawn(forceRespawn)
        end
    end))

    -- Backup: Humanoid death (failsafe)
    table.insert(_G.RespawnScript.Connections, humanoid.Died:Connect(function()
        if _G.RespawnScript.Active and not hasRespawned then
            hasRespawned = true
            task.spawn(forceRespawn)
        end
    end))

    -- Backup: Health drops to 0
    table.insert(_G.RespawnScript.Connections, humanoid.HealthChanged:Connect(function(h)
        if _G.RespawnScript.Active and h <= 0 and not hasRespawned then
            hasRespawned = true
            task.spawn(forceRespawn)
        end
    end))
end

local function toggleScript()
    if _G.RespawnScript.Active then
        _G.RespawnScript.Active = false
        disconnectAll()
    else
        _G.RespawnScript.Active = true
        table.insert(_G.RespawnScript.Connections, LocalPlayer.CharacterAdded:Connect(onCharacterAdded))
        if LocalPlayer.Character then
            onCharacterAdded(LocalPlayer.Character)
        else
            forceRespawn()
        end
    end
end

toggleScript()
