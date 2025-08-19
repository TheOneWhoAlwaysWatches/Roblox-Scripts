-- ⚡ DEMONIC INSTANT TOOL GRABBER — Optimized Tick Edition
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

-- Collect a single tool instantly
local function CollectTool(root, toolPad)
    for _ = 1, 4 do
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

-- Tick-perfect heartbeat
RunService.Heartbeat:Connect(CollectTools)

-- Respawn catch
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    CollectTools()
end)

-- Instant after a new pad spawns — only touch the new one
Tycoons.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("TouchTransmitter") and descendant.Parent and descendant.Parent.Parent and descendant.Parent.Parent.Name:find("GearGiver1") then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            CollectTool(root, descendant.Parent)
        end
    end
end)
