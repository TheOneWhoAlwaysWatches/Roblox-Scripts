local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Tycoons = workspace:WaitForChild("Tycoons")

-- Excluded bases (hard skip)
local excludedBases = { "Insanity", "Giant", "Dark", "Spike", "Web", "Strong" }
local excludedBasesSet = {}
for _, base in ipairs(excludedBases) do
    excludedBasesSet[base] = true
end

-- Allowed bases (priority bases)
local allowedBases = { "Stone", "Magic", "Storm" }
local allowedBasesSet = {}
for _, base in ipairs(allowedBases) do
    allowedBasesSet[base] = true
end

-- Collect tools from allowed or non-excluded bases
local function CollectTools()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, v in ipairs(Tycoons:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Parent and v.Parent.Parent.Name:find("GearGiver1") then
            local baseModel = v.Parent.Parent.Parent
            local baseName = baseModel and baseModel.Name
            if baseName and (allowedBasesSet[baseName] or not excludedBasesSet[baseName]) then
                firetouchinterest(root, v.Parent, 0)
                firetouchinterest(root, v.Parent, 1)
            end
        end
    end
end

-- Run instantly and every frame
CollectTools()
RunService.Heartbeat:Connect(CollectTools)

-- Run after respawn
LocalPlayer.CharacterAdded:Connect(function()
    LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    CollectTools()
end)

-- Run when new pads appear
Tycoons.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("TouchTransmitter") and descendant.Parent and descendant.Parent.Parent and descendant.Parent.Parent.Name:find("GearGiver1") then
        CollectTools()
    end
end)
