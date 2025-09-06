-- ⚡ ULTRA-INSTANT TOOL GRABBER v2
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Tycoons = workspace:WaitForChild("Tycoons")

-- Exclusions / Allowed sets
local excludedBases = { "Insanity", "Giant", "Dark", "Spike", "Web", "Strong" }
local allowedBases = { "Stone", "Magic", "Storm" }
local excludedBasesSet, allowedBasesSet = {}, {}
for _, b in ipairs(excludedBases) do excludedBasesSet[b] = true end
for _, b in ipairs(allowedBases) do allowedBasesSet[b] = true end

-- Touch helper
local function CollectTool(root, toolPad)
    -- Spam multiple times to make sure it registers
    for _ = 1, 8 do
        firetouchinterest(root, toolPad, 0)
        firetouchinterest(root, toolPad, 1)
    end
end

-- Main grab function
local function CollectTools()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, v in ipairs(Tycoons:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Parent and v.Parent.Parent.Name:find("GearGiver1") then
            local baseModel = v.Parent.Parent.Parent
            local baseName = baseModel and baseModel.Name
            if baseName and (allowedBasesSet[baseName] or not excludedBasesSet[baseName]) then
                CollectTool(root, v.Parent)
            end
        end
    end
end

-- 🟢 Instant-grab on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart") -- wait for root
    task.defer(CollectTools)              -- collect immediately on next tick
end)

-- 🟢 Instant-grab when new pad spawns
Tycoons.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("TouchTransmitter") and descendant.Parent and descendant.Parent.Parent and descendant.Parent.Parent.Name:find("GearGiver1") then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            CollectTool(root, descendant.Parent)
        end
    end
end)

-- 🟢 Backup loop (keeps tools if you lose them mid-fight)
RunService.Heartbeat:Connect(CollectTools)
