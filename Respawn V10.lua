-- ⚡ ULTRA-INSTANT RESPAWN
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function forceRespawn()
    if LocalPlayer:FindFirstChild("LoadCharacter") then
        LocalPlayer:LoadCharacter() -- fastest native respawn
    elseif ReplicatedStorage:FindFirstChild("Guide") then
        ReplicatedStorage.Guide:FireServer()
    end
end

local function onCharacterAdded(char)
    local humanoid = char:WaitForChild("Humanoid", 1)
    if not humanoid then return end
    local respawned = false

    humanoid.HealthChanged:Connect(function(health)
        if health <= 0.1 and not respawned then
            respawned = true
            forceRespawn()
        end
    end)

    humanoid.Died:Connect(function()
        if not respawned then
            respawned = true
            forceRespawn()
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
else
    forceRespawn()
end
