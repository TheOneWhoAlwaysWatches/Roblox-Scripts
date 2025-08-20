-- ⚙️ SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- 💪 LOCKED POSE: Arms hang straight down
local LOCKED_CFRAMES = {
    R6 = {
        Left = {C0 = CFrame.new(-1.5, 0.5, 0), C1 = CFrame.new(0.5, 0.5, 0)},
        Right = {C0 = CFrame.new(1.5, 0.5, 0), C1 = CFrame.new(-0.5, 0.5, 0)},
    },
    R15 = {
        LeftShoulder = {C0 = CFrame.new(-1, 0.5, 0), C1 = CFrame.new(0.5, 0.5, 0)},
        RightShoulder = {C0 = CFrame.new(1, 0.5, 0), C1 = CFrame.new(-0.5, 0.5, 0)},
        LeftElbow = {C0 = CFrame.new(0, -1, 0), C1 = CFrame.new(0, 1, 0)},
        RightElbow = {C0 = CFrame.new(0, -1, 0), C1 = CFrame.new(0, 1, 0)}
    }
}

-- 🧊 Force-lock arms in place, override everything
local function freezeArms()
    if character:FindFirstChild("Torso") then
        -- R6 Rig
        local ls = character.Torso:FindFirstChild("Left Shoulder")
        local rs = character.Torso:FindFirstChild("Right Shoulder")
        if ls then ls.C0 = LOCKED_CFRAMES.R6.Left.C0 ls.C1 = LOCKED_CFRAMES.R6.Left.C1 end
        if rs then rs.C0 = LOCKED_CFRAMES.R6.Right.C0 rs.C1 = LOCKED_CFRAMES.R6.Right.C1 end
    elseif character:FindFirstChild("UpperTorso") then
        -- R15 Rig
        local us = character.UpperTorso
        local ls = us:FindFirstChild("LeftShoulder")
        local rs = us:FindFirstChild("RightShoulder")
        local le = character:FindFirstChild("LeftUpperArm") and character.LeftUpperArm:FindFirstChild("LeftElbow")
        local re = character:FindFirstChild("RightUpperArm") and character.RightUpperArm:FindFirstChild("RightElbow")

        if ls then ls.C0 = LOCKED_CFRAMES.R15.LeftShoulder.C0 ls.C1 = LOCKED_CFRAMES.R15.LeftShoulder.C1 end
        if rs then rs.C0 = LOCKED_CFRAMES.R15.RightShoulder.C0 rs.C1 = LOCKED_CFRAMES.R15.RightShoulder.C1 end
        if le then le.C0 = LOCKED_CFRAMES.R15.LeftElbow.C0 le.C1 = LOCKED_CFRAMES.R15.LeftElbow.C1 end
        if re then re.C0 = LOCKED_CFRAMES.R15.RightElbow.C0 re.C1 = LOCKED_CFRAMES.R15.RightElbow.C1 end
    end
end

-- ❌ Cancel all animations (so nothing can move arms)
local function disableArmAnimations()
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
end

-- 🔁 Update constantly to fight back against anything trying to move arms
RunService.RenderStepped:Connect(function()
    freezeArms()
    disableArmAnimations()
end)
RunService.Heartbeat:Connect(freezeArms)
RunService.Stepped:Connect(freezeArms)

-- ♻️ Reapply when character respawns
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = -- ⚙️ SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- 💪 LOCKED POSE: Arms hang straight down
local LOCKED_CFRAMES = {
    R6 = {
        Left = {C0 = CFrame.new(-1.5, 0.5, 0), C1 = CFrame.new(0.5, 0.5, 0)},
        Right = {C0 = CFrame.new(1.5, 0.5, 0), C1 = CFrame.new(-0.5, 0.5, 0)},
    },
    R15 = {
        LeftShoulder = {C0 = CFrame.new(-1, 0.5, 0), C1 = CFrame.new(0.5, 0.5, 0)},
        RightShoulder = {C0 = CFrame.new(1, 0.5, 0), C1 = CFrame.new(-0.5, 0.5, 0)},
        LeftElbow = {C0 = CFrame.new(0, -1, 0), C1 = CFrame.new(0, 1, 0)},
        RightElbow = {C0 = CFrame.new(0, -1, 0), C1 = CFrame.new(0, 1, 0)}
    }
}

-- 🧊 Force-lock arms in place, override everything
local function freezeArms()
    if character:FindFirstChild("Torso") then
        -- R6 Rig
        local ls = character.Torso:FindFirstChild("Left Shoulder")
        local rs = character.Torso:FindFirstChild("Right Shoulder")
        if ls then ls.C0 = LOCKED_CFRAMES.R6.Left.C0 ls.C1 = LOCKED_CFRAMES.R6.Left.C1 end
        if rs then rs.C0 = LOCKED_CFRAMES.R6.Right.C0 rs.C1 = LOCKED_CFRAMES.R6.Right.C1 end
    elseif character:FindFirstChild("UpperTorso") then
        -- R15 Rig
        local us = character.UpperTorso
        local ls = us:FindFirstChild("LeftShoulder")
        local rs = us:FindFirstChild("RightShoulder")
        local le = character:FindFirstChild("LeftUpperArm") and character.LeftUpperArm:FindFirstChild("LeftElbow")
        local re = character:FindFirstChild("RightUpperArm") and character.RightUpperArm:FindFirstChild("RightElbow")

        if ls then ls.C0 = LOCKED_CFRAMES.R15.LeftShoulder.C0 ls.C1 = LOCKED_CFRAMES.R15.LeftShoulder.C1 end
        if rs then rs.C0 = LOCKED_CFRAMES.R15.RightShoulder.C0 rs.C1 = LOCKED_CFRAMES.R15.RightShoulder.C1 end
        if le then le.C0 = LOCKED_CFRAMES.R15.LeftElbow.C0 le.C1 = LOCKED_CFRAMES.R15.LeftElbow.C1 end
        if re then re.C0 = LOCKED_CFRAMES.R15.RightElbow.C0 re.C1 = LOCKED_CFRAMES.R15.RightElbow.C1 end
    end
end

-- ❌ Cancel all animations (so nothing can move arms)
local function disableArmAnimations()
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
end

-- 🔁 Update constantly to fight back against anything trying to move arms
RunService.RenderStepped:Connect(function()
    freezeArms()
    disableArmAnimations()
end)
RunService.Heartbeat:Connect(freezeArms)
RunService.Stepped:Connect(freezeArms)

-- ♻️ Reapply when character respawns
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    wait(1)
    freezeArms()
end)

print("✅ Arms are now locked down FOREVER. They will NEVER move until you leave.")
character:WaitForChild("Humanoid")
    wait(1)
    freezeArms()
end)

print("✅ Arms are now locked down FOREVER. They will NEVER move until you leave.")
