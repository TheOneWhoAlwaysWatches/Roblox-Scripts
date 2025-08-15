local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Master toggle
_G.RespawnScript = _G.RespawnScript or { Active = false, Connections = {} }

-- Disconnect previous connections
local function disconnectAll()
    for _, conn in ipairs(_G.RespawnScript.Connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    _G.RespawnScript.Connections = {}
end

-- Force respawn function
local function forceRespawn()
    local guide = ReplicatedStorage:FindFirstChild("Guide")
    if guide then
        guide:FireServer()
    else
        LocalPlayer:LoadCharacter()
    end
end

-- Listen for character death/removal
local function onCharacterAdded(char)
    if not _G.RespawnScript.Active then return end

    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    local hasRespawned = false

    -- Fires immediately when humanoid dies
    table.insert(_G.RespawnScript.Connections, humanoid.Died:Connect(function()
        if _G.RespawnScript.Active and not hasRespawned then
            hasRespawned = true
            task.spawn(forceRespawn)
        end
    end))

    -- Fires the microsecond character is removed
    table.insert(_G.RespawnScript.Connections, char.AncestryChanged:Connect(function(_, parent)
        if _G.RespawnScript.Active and not parent and not hasRespawned then
            hasRespawned = true
            task.spawn(forceRespawn)
        end
    end))

    -- Fires if CharacterRemoving is triggered
    table.insert(_G.RespawnScript.Connections, char:GetPropertyChangedSignal("Parent"):Connect(function()
        if _G.RespawnScript.Active and not char.Parent and not hasRespawned then
            hasRespawned = true
            task.spawn(forceRespawn)
        end
    end))
end

-- Toggle script on/off
local function toggleScript()
    if _G.RespawnScript.Active then
        _G.RespawnScript.Active = false
        disconnectAll()
    else
        _G.RespawnScript.Active = true
        table.insert(_G.RespawnScript.Connections,
            LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        )
        if LocalPlayer.Character then
            onCharacterAdded(LocalPlayer.Character)
        end
    end
end

toggleScript()
