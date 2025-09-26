-- ⚡ ULTRA-INSTANT RESPAWN v2 ⚡
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local respawned = false

local function forceRespawn()
    if respawned then return end
    respawned = true
    if LocalPlayer:FindFirstChild("LoadCharacter") then
        LocalPlayer:LoadCharacter() -- fastest native respawn
    elseif ReplicatedStorage:FindFirstChild("Guide") then
        ReplicatedStorage.Guide:FireServer()
    end
end

local function onCharacterAdded(char)
    respawned = false
    local humanoid = char:WaitForChild("Humanoid", 1)

    -- Frame-perfect check
    local conn
    conn = RunService.Stepped:Connect(function()
        if humanoid and humanoid.Health <= 0.01 then
            forceRespawn()
            conn:Disconnect()
        end
    end)

    -- Extra safety: also listen to Humanoid removal (instant respawn if Humanoid disappears)
    char.ChildRemoved:Connect(function(child)
        if child == humanoid then
            forceRespawn()
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Initial load
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
else
    forceRespawn()
end

print("⚡ ULTRA-INSTANT RESPAWN v11 loaded ⚡")
