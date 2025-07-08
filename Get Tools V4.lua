-- ⚔️ Get Tools V4 - Optimized Tycoon Collector

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Tycoons = workspace:WaitForChild("Tycoons")

-- Excluded and allowed bases
local excludedBasesSet = {
	["Insanity"] = true, ["Giant"] = true, ["Dark"] = true,
	["Spike"] = true, ["Web"] = true, ["Strong"] = true
}

local allowedBasesSet = {
	["Stone"] = true, ["Magic"] = true, ["Storm"] = true
}

-- Debounced touch tracking
local touched = {} -- [Part] = lastTick
local touchCooldown = 0.5 -- seconds

local function safeTouch(root, pad)
	local now = tick()
	if not touched[pad] or now - touched[pad] > touchCooldown then
		touched[pad] = now
		firetouchinterest(root, pad, 0)
		firetouchinterest(root, pad, 1)
	end
end

-- Tool Collector
local function CollectTools()
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local function tryCollect(priorityOnly)
		for _, v in ipairs(Tycoons:GetDescendants()) do
			if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Parent and v.Parent.Parent.Name:find("GearGiver1") then
				local baseModel = v.Parent.Parent.Parent
				local baseName = baseModel and baseModel.Name
				local isAllowed = allowedBasesSet[baseName]
				local isExcluded = excludedBasesSet[baseName]

				if baseName then
					if priorityOnly and isAllowed then
						safeTouch(root, v.Parent)
					elseif not priorityOnly and not isExcluded and not isAllowed then
						safeTouch(root, v.Parent)
					end
				end
			end
		end
	end

	-- First: fast allowed bases
	tryCollect(true)
	-- Then: remaining usable bases
	tryCollect(false)
end

-- First run
CollectTools()

-- Every 0.1s max (faster than needed but lag-safe)
local lastTick = 0
RunService.Heartbeat:Connect(function()
	if tick() - lastTick >= 0.1 then
		lastTick = tick()
		CollectTools()
	end
end)

-- On respawn
LocalPlayer.CharacterAdded:Connect(function()
	LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	CollectTools()
end)

-- On new gear givers appearing
Tycoons.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("TouchTransmitter") and descendant.Parent and descendant.Parent.Parent and descendant.Parent.Parent.Name:find("GearGiver1") then
		CollectTools()
	end
end)
