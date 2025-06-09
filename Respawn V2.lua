-- Respawn V2

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if not _G.RespawnScript then
    _G.RespawnScript = { Active = false, Connections = {} }
end

local function disconnectAll()
    for _, conn in ipairs(_G.RespawnScript.Connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    _G.RespawnScript.Connections = {}
end

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    local deathConn
    deathConn = humanoid.Died:Connect(function()
        if _G.RespawnScript.Active then
            local guide = ReplicatedStorage:FindFirstChild("Guide")
            if guide then
                guide:FireServer()  -- Fire respawn only when player naturally dies
            end
        end
    end)
    table.insert(_G.RespawnScript.Connections, deathConn)
end

if _G.RespawnScript.Active then
    print("Respawn script deactivated.")
    _G.RespawnScript.Active = false
    disconnectAll()
else
    print("Respawn script activated.")
    _G.RespawnScript.Active = true

    local charAddedConn = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    table.insert(_G.RespawnScript.Connections, charAddedConn)

    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end
end