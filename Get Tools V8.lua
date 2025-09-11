-- ⚡ ULTRA-INSTANT TOOL GRABBER + AUTO-EQUIP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Tycoons = workspace:WaitForChild("Tycoons")

-- Config
local excludedBases = { "Insanity", "Giant", "Dark", "Spike", "Web", "Strong" }
local allowedBases  = { "Stone", "Magic", "Storm" }
local excludedSet, allowedSet = {}, {}
for _, b in ipairs(excludedBases) do excludedSet[b] = true end
for _, b in ipairs(allowedBases) do allowedSet[b] = true end

-- Touch helper
local function fireCollect(root, pad)
    firetouchinterest(root, pad, 0)
    firetouchinterest(root, pad, 1)
end

-- Collect instantly + persist a few frames
local function CollectTools()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, v in ipairs(Tycoons:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Parent and v.Parent.Parent.Name:find("GearGiver1") then
            local baseModel = v.Parent.Parent.Parent
            local baseName = baseModel and baseModel.Name
            if baseName and (allowedSet[baseName] or not excludedSet[baseName]) then
                for i = 0, 2 do
                    task.delay(i * 0.05, function()
                        local rootNow = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if rootNow then
                            fireCollect(rootNow, v.Parent)
                        end
                    end)
                end
            end
        end
    end

    -- Force equip instantly
    task.defer(function()
        if char then
            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = char
                end
            end
        end
    end)
end

-- Run on spawn
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    CollectTools()
end)

-- Run when new pads spawn
Tycoons.DescendantAdded:Connect(function(desc)
    if desc:IsA("TouchTransmitter") and desc.Parent and desc.Parent.Parent and desc.Parent.Parent.Name:find("GearGiver1") then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            fireCollect(root, desc.Parent)
        end
    end
end)

-- Backup refresher
RunService.Heartbeat:Connect(CollectTools)
