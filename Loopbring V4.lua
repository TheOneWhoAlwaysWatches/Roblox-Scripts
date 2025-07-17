-- === LOOPBRING V4 (Circle Mode) ===
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local bringTargets = {}
local circleRadius = 5  -- Distance from player
local circleSpeed = 0.1 -- Teleport speed

-- === UI ===
local bringUI = Instance.new("ScreenGui")
bringUI.Name = "LoopBringCircleUI"
bringUI.Parent = game.CoreGui
bringUI.ResetOnSpawn = false
bringUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Toggle button (top right)
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

toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	if frame.Visible then updatePlayerList() end
end)

-- Live update players
local function loopBring(name)
	if table.find(bringTargets, name) then return end
	table.insert(bringTargets, name)
end

local function stopBring(name)
	local i = table.find(bringTargets, name)
	if i then table.remove(bringTargets, i) end
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
				else
					loopBring(p.Name)
				end
				updatePlayerList()
			end)
		end
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 30)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(p)
	stopBring(p.Name)
	updatePlayerList()
end)

-- === Circle Loop ===
task.spawn(function()
	while task.wait(circleSpeed) do
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root and #bringTargets > 0 then
			for i, name in ipairs(bringTargets) do
				local plr = Players:FindFirstChild(name)
				local tChar = plr and plr.Character
				local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
				if tRoot then
					local angle = math.rad((i / #bringTargets) * 360)
					local offset = Vector3.new(math.cos(angle) * circleRadius, 0, math.sin(angle) * circleRadius)
					tRoot.CFrame = CFrame.new(root.Position + offset)
				end
			end
		end
	end
end)
