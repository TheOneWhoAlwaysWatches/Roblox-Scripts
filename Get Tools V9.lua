-- ⚡ ULTRA-INSTANT TOOL GRABBER v10 ⚡
-- Optimized: cache pads, no full scan every frame

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Tycoons = workspace:WaitForChild("Tycoons")

-- CONFIG
local hitPerFrame = 2
local allowedBases  = { "Stone", "Magic", "Storm" }
local excludedBases = { "Insanity", "Giant", "Dark", "Spike", "Web", "Strong" }

-- convert to sets
local allowedSet, excludedSet = {}, {}
for _, b in ipairs(allowedBases) do allowedSet[b] = true end
for _, b in ipairs(excludedBases) do excludedSet[b] = true end

-- cache of all valid pads
local pads = {}

local function fireTouch(root, pad)
    firetouchinterest(root, pad, 0)
    firetouchinterest(root, pad, 1)
end

local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- add pad to cache
local function registerPad(pad)
    local baseModel = pad.Parent and pad.Parent.Parent
    if not baseModel then return end
    local baseName = baseModel.Name
    if baseName and (allowedSet[baseName] or not excludedSet[baseName]) then
        pads[pad] = true
    end
end

-- remove pad from cache
local function unregisterPad(pad)
    pads[pad] = nil
end

-- initialize existing pads
for _, v in ipairs(Tycoons:GetDescendants()) do
    if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Parent and v.Parent.Parent.Name:find("GearGiver1") then
        registerPad(v.Parent)
    end
end

-- listen for new ones
Tycoons.DescendantAdded:Connect(function(desc)
    if desc:IsA("TouchTransmitter") and desc.Parent and desc.Parent.Parent and desc.Parent.Parent.Name:find("GearGiver1") then
        registerPad(desc.Parent)
    end
end)

Tycoons.DescendantRemoving:Connect(function(desc)
    if desc:IsA("TouchTransmitter") then
        unregisterPad(desc.Parent)
    end
end)

-- fire instantly on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 2)
end)

-- main loop: only loop cached pads
RunService.Heartbeat:Connect(function()
    local root = getRoot()
    if not root then return end
    for pad in pairs(pads) do
        for i = 1, hitPerFrame do
            fireTouch(root, pad)
        end
    end
end)

print("⚡ ULTRA-INSTANT TOOL GRABBER v10 loaded ⚡")
