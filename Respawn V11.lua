-- ⚡ ULTRA-INSTANT RESPAWN v12 ⚡
-- Aggressive frame-perfect respawn for 1v1s

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- attempt respawn immediately
local function forceRespawn()
    if LocalPlayer:FindFirstChild("LoadCharacter") then
        LocalPlayer:LoadCharacter()
    elseif ReplicatedStorage:FindFirstChild("Guide") then
        ReplicatedStorage.Guide:FireServer()
    end
end

-- track character
local function onCharacterAdded(char)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        -- if humanoid hasn’t spawned yet, retry ASAP without yielding
        char.ChildAdded:Connect(function(c)
            if c:IsA("Humanoid") then
                humanoid = c
            end
        end)
    end

    -- frame-perfect death detection
    RunService.Heartbeat:Connect(function()
        if humanoid and humanoid.Health <= 0 then
            forceRespawn()
        end
    end)

    -- instant fallback: if humanoid is destroyed
    char.ChildRemoved:Connect(function(c)
        if c == humanoid then
            forceRespawn()
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- if already loaded, hook immediately
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
else
    forceRespawn()
end

print("⚡ ULTRA-INSTANT RESPAWN v12 loaded ⚡")
