local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Master toggle
_G.RespawnScript = _G.RespawnScript or { Active = false, Connections = {} }

local function disconnectAll()
    for _, c in ipairs(_G.RespawnScript.Connections) do
        if c and c.Connected then
            c:Disconnect()
        end
    end
    _G.RespawnScript.Connections = {}
end

local function forceRespawn()
    -- Fires instantly, bypassing animation waits
    if ReplicatedStorage:FindFirstChild("Guide") then
        ReplicatedStorage.Guide:FireServer()
    elseif LocalPlayer and LocalPlayer.LoadCharacter then
        LocalPlayer:LoadCharacter()
    end
end

local function onCharacterAdded(char)
    if not _G.RespawnScript.Active then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local hasRespawned = false

    -- Fires before Humanoid.Died finishes death animation
    table.insert(_G.RespawnScript.Connections,
        char.AncestryChanged:Connect(function(_, parent)
            if not parent and _G.RespawnScript.Active and not hasRespawned then
                hasRespawned = true
                task.spawn(forceRespawn)
            end
        end)
    )

    -- Safety net: still listen to Humanoid.Died in case CharacterRemoving is delayed
    table.insert(_G.RespawnScript.Connections,
        humanoid.Died:Connect(function()
            if _G.RespawnScript.Active and not hasRespawned then
                hasRespawned = true
                task.spawn(forceRespawn)
            end
        end)
    )
end

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
        else
            forceRespawn()
        end
    end
end

toggleScript()
