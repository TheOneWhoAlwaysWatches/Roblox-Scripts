-- ⚡ ULTRA-INSTANT TOOL GRABBER (no auto-equip, persistent touches)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Tycoons = workspace:WaitForChild("Tycoons")

-- CONFIG: tweak if needed
local PERSIST_FRAMES = 3        -- number of quick repeated bursts (frames)
local PERSIST_DELAY = 0.03      -- spacing between bursts (seconds) -> ~30ms

local excludedBases = { "Insanity", "Giant", "Dark", "Spike", "Web", "Strong" }
local allowedBases  = { "Stone", "Magic", "Storm" }
local excludedSet, allowedSet = {}, {}
for _, b in ipairs(excludedBases) do excludedSet[b] = true end
for _, b in ipairs(allowedBases)  do allowedSet[b] = true end

local function fireCollectOnce(root, pad)
    -- minimal single-frame two-phase contact
    pcall(function()
        firetouchinterest(root, pad, 0)
        firetouchinterest(root, pad, 1)
    end)
end

local function persistCollect(root, pad)
    -- schedule several rapid bursts across a few micro-frames
    for i = 0, PERSIST_FRAMES - 1 do
        local delayTime = i * PERSIST_DELAY
        task.delay(delayTime, function()
            -- check root still exists
            local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if r then
                fireCollectOnce(r, pad)
            end
        end)
    end
end

local function tryCollectToolsNow()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- iterate relevant pads once and persist-touch them
    for _, v in ipairs(Tycoons:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Parent and v.Parent.Parent.Name:find("GearGiver1") then
            local baseModel = v.Parent.Parent.Parent
            local baseName = baseModel and baseModel.Name
            if baseName and (allowedSet[baseName] or not excludedSet[baseName]) then
                persistCollect(root, v.Parent)
            end
        end
    end
end

-- ON RESPAWN: fire immediate collects (no defer)
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 2)
    -- attempt collection immediately (synchronous bursts scheduled)
    tryCollectToolsNow()
end)

-- WHEN NEW PAD APPEARS: instant attempt
Tycoons.DescendantAdded:Connect(function(desc)
    if desc:IsA("TouchTransmitter") and desc.Parent and desc.Parent.Parent and desc.Parent.Parent.Name:find("GearGiver1") then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            -- Immediate single persistent collect on new pad
            persistCollect(root, desc.Parent)
        end
    end
end)

-- Backup: small, extremely light periodic attempt (keeps things robust)
RunService.Heartbeat:Connect(function()
    -- very cheap: only do quick check once per frame; function itself is light
    -- comment this out if you want ZERO background activity
    tryCollectToolsNow()
end)

print("Ultra-GetTools (no-equip) loaded.")
