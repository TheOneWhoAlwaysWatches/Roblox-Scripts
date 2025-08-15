-- ⚡ DEMONIC INSTANT TOOL GRABBER — Triple Frame Burst Edition
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Tycoons = workspace:WaitForChild("Tycoons")

-- Skip/priority base sets
local excludedBases = { "Insanity", "Giant", "Dark", "Spike", "Web", "Strong" }
local allowedBases = { "Stone", "Magic", "Storm" }
local excludedBasesSet, allowedBasesSet = {}, {}
for _, b in ipairs(excludedBases) do excludedBasesSet[b] = true end
for _, b in ipairs(allowedBases) do allowedBasesSet[b] = true end

-- Instant touch spam
local function CollectTools()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, v in ipairs(Tycoons:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Parent and v.Parent.Parent.Name:find("GearGiver1") then
            local baseModel = v.Parent.Parent.Parent
            local baseName = baseModel and baseModel.Name
            if baseName and (allowedBasesSet[baseName] or not excludedBasesSet[baseName]) then
                task.spawn(function()
                    -- Burst touch: hit pad multiple times instantly
                    for _ = 1, 4 do
                        firetouchinterest(root, v.Parent, 0)
                        firetouchinterest(root, v.Parent, 1)
                    end
                end)
            end
        end
    end
end

-- Initial grab
CollectTools()

-- Run every possible frame point
RunService.Heartbeat:Connect(CollectTools)
RunService.Stepped:Connect(CollectTools)
RunService.PostSimulation:Connect(CollectTools)

-- Instant after respawn — no wait
LocalPlayer.CharacterAdded:Connect(function()
    task.defer(CollectTools)
end)

-- React instantly to new pads
Tycoons.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("TouchTransmitter") and descendant.Parent and descendant.Parent.Parent and descendant.Parent.Parent.Name:find("GearGiver1") then
        CollectTools()
    end
end)
