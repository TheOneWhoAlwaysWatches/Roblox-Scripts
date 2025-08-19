-- === LOOPBRING V6 (Circle Mode) — Tick-Perfect + Persistent ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local bringTargets = {}       -- currently active loopbring
local persistentTargets = {}  -- remembers selected players even if they leave

local circleRadius = 5
local circleSpeed = 0.03 -- tick-perfect interval

-- === UI ===
local bringUI = Instance.new("ScreenGui")
bringUI.Name = "LoopBringCircleUI"
bringUI.Parent = game.CoreGui
bringUI.ResetOnSpawn = false
bringUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Toggle button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 35, 0, 35)
toggle.Position = UDim2.new(1, -45, 0, 10)
toggle.AnchorPoint = Vector2.new(0.5, 0)
toggle.Text = "≡"
toggle.Font = Enum.Font.GothamBold
toggle.TextScaled = true
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.BackgroundColor3 = Color3.fromRGB(40, 0, 40)
toggle.Parent = bringUI

local grad = Instance.new("UIGradient", toggle)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 180)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 60))
}
grad.Rotation = 45

-- Dropdown frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(1, -220, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
frame.Visible = false
frame.Parent = bringUI
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(150, 0, 150)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 5
scroll.BackgroundTransparency = 1
scroll.Parent = frame

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 2)

-- === Player Selection Logic ===
local function loopBring(name)
	if not table.find(bringTargets, name) then
		table.insert(bringTargets, name)
	end
	persistentTargets[name] = true
end

local function stopBring(name)
	local i = table.find(bringTargets, name)
	if i then
		table.remove(bringTargets, i)
	end
end

function updatePlayerList()
	for _, btn in ipairs(scroll:GetChildren()) do
		if btn:IsA("TextButton") then btn:Destroy() end
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -8, 0, 28)
			b.Text = p.Name
			b.TextScaled = true
			b.Font = Enum.Font.Gotham
			b.BackgroundColor3 = table.find(bringTargets, p.Name) and Color3.fromRGB(120, 0, 120) or Color3.fromRGB(40, 0, 40)
			b.TextColor3 = Color3.new(1, 1, 1)
			b.Parent = scroll

			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

			b.MouseButton1Click:Connect(function()
				if table.find(bringTargets, p.Name) then
					stopBring(p.Name)
					persistentTargets[p.Name] = nil
				else
					loopBring(p.Name)
				end
				updatePlayerList()
			end)
		end
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 30)
end

toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	if frame.Visible then updatePlayerList() end
end)

-- Auto re-add persistent targets when they join
Players.PlayerAdded:Connect(function(p)
	if persistentTargets[p.Name] then
		loopBring(p.Name)
	end
	updatePlayerList()
end)

Players.PlayerRemoving:Connect(function(p)
	stopBring(p.Name) -- stop actively loopbringing
	updatePlayerList()
end)

-- Initial update
updatePlayerList()

-- === Tick-Perfect LoopBring ===
RunService.Heartbeat:Connect(function()
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root or #bringTargets == 0 then return end

	for i, name in ipairs(bringTargets) do
		local plr = nil
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Name == name then
				plr = p
				break
			end
		end

		local tChar = plr and plr.Character
		if tChar then
			local tRoot = tChar:FindFirstChild("HumanoidRootPart")
			if tRoot then
				local angle = math.rad((i / #bringTargets) * 360)
				local offset = Vector3.new(math.cos(angle) * circleRadius, 0, math.sin(angle) * circleRadius)
				tRoot.CFrame = CFrame.new(root.Position + offset)
			end
		end
	end
end)
