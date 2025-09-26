-- ⚡ ULTRA-INSTANT TOOL GRABBER v2 ⚡
-- Fires every frame for maximum speed with persistent touches

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Tycoons = workspace:WaitForChild("Tycoons")

-- CONFIG
local hitPerFrame = 2 -- touches per frame for reliability
local allowedBases  = { "Stone", "Magic", "Storm" }
local excludedBases = { "Insanity", "Giant", "Dark", "Spike", "Web", "Strong" }

-- convert tables to sets for fast lookup
local allowedSet, excludedSet = {}, {}
for _, b in ipairs(allowedBases) do allowedSet[b] = true end
for _, b in ipairs(excludedBases) do excludedSet[b] = true end

local function fireTouch(root, pad)
    pcall(function()
        firetouchinterest(root, pad, 0)
        firetouchinterest(root, pad, 1)
    end)
end

local function collectPad(root, pad)
    for i = 1, hitPerFrame do
        fireTouch(root, pad)
    end
end

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function collectAllTools()
    local root = getRoot()
    if not root then return end

    for _, v in ipairs(Tycoons:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Parent and v.Parent.Parent.Name:find("GearGiver1") then
            local baseModel = v.Parent.Parent.Parent
            local baseName = baseModel and baseModel.Name
            if baseName and (allowedSet[baseName] or not excludedSet[baseName]) then
                collectPad(root, v.Parent)
            end
        end
    end
end

-- Fires immediately on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 2)
    collectAllTools()
end)

-- Fires immediately when new pad appears
Tycoons.DescendantAdded:Connect(function(desc)
    if desc:IsA("TouchTransmitter") and desc.Parent and desc.Parent.Parent and desc.Parent.Parent.Name:find("GearGiver1") then
        local root = getRoot()
        if root then
            collectPad(root, desc.Parent)
        end
    end
end)

-- Run every Heartbeat (frame-perfect)
RunService.Heartbeat:Connect(collectAllTools)

print("⚡ ULTRA-INSTANT TOOL GRABBER v9 loaded ⚡")
