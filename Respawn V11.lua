-- ⚡ ULTRA-INSTANT RESPAWN v12 FIXED ⚡
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
        char.ChildAdded:Connect(function(c)
            if c:IsA("Humanoid") then
                humanoid = c
            end
        end)
    end

    -- Death detection — run once
    local heartbeatConnection
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        if humanoid and humanoid.Health <= 0 then
            heartbeatConnection:Disconnect() -- stop loop
            forceRespawn()
        end
    end)

    -- instant fallback: if humanoid is destroyed
    char.ChildRemoved:Connect(function(c)
        if c == humanoid then
            heartbeatConnection:Disconnect()
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

print("⚡ ULTRA-INSTANT RESPAWN v12 FIXED loaded ⚡")
