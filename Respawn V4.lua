-- ⚡ UltraFast Respawn Script V3

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Set this to the RemoteEvent that triggers respawn
local respawnRemote = ReplicatedStorage:FindFirstChild("Guide")

-- Toggle Logic
if _G.UltraRespawnActive then
    _G.UltraRespawnActive = false
    warn("Ultra Respawn deactivated.")
    return
else
    _G.UltraRespawnActive = true
    warn("Ultra Respawn activated.")
end

-- Watch Humanoid Died instantly (bind before CharacterAdded even fires)
local function hookHumanoidDied(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
    
    -- Connect instantly to Died
    humanoid.Died:Connect(function()
        if not _G.UltraRespawnActive then return end

        -- Fire Remote *as fast as possible*
        if respawnRemote then
            respawnRemote:FireServer()
        end
    end)
end

-- Monitor for new characters
LocalPlayer.CharacterAdded:Connect(hookHumanoidDied)

-- Hook existing character (if present)
if LocalPlayer.Character then
    hookHumanoidDied(LocalPlayer.Character)
end
