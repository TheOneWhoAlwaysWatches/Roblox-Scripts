-- === LOOPBRING V7 (Black+Red Theme, Persistent, Respawn Safe) ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local bringTargets = {}       -- active loopbring
local persistentTargets = {}  -- remembers selected players even if they leave

local circleRadius = 5
local circleSpeed = 0.03 -- tick-perfect interval

-- === UI ===
local bringUI = Instance.new("ScreenGui")
bringUI.Name = "LoopBringUI"
bringUI.Parent = game.CoreGui
bringUI.ResetOnSpawn = false
bringUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Toggle button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 120, 0, 40)
toggle.Position = UDim2.new(1, -125, 0.5, -20) -- middle right
toggle.AnchorPoint = Vector2.new(0, 0)
toggle.Text = "LoopBring"
toggle.Font = Enum.Font.GothamBold
toggle.TextScaled = true
toggle.TextColor3 = Color3.fromRGB(255, 0, 0)
toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggle.Parent = bringUI

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

local uiStroke = Instance.new("UIStroke", toggle)
uiStroke.Color = Color3.fromRGB(180, 0, 0)
uiStroke.Thickness = 2

-- Dropdown frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(1, -350, 0.5, -125) -- to the left of toggle
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Parent = bringUI
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(200, 0, 0)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 5
scroll.BackgroundTransparency = 1
scroll.Parent = frame

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 3)

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
	persistentTargets[name] = nil
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
			b.BackgroundColor3 = table.find(bringTargets, p.Name) 
				and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(40, 40, 40)
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
	stopBring(p.Name)
	updatePlayerList()
end)

-- Respawn persistence: re-loopbring on respawn
local function onCharacterAdded(plr, char)
	if persistentTargets[plr.Name] then
		loopBring(plr.Name)
	end
end
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(c) onCharacterAdded(p, c) end)
end)
for _,p in ipairs(Players:GetPlayers()) do
	p.CharacterAdded:Connect(function(c) onCharacterAdded(p, c) end)
end

-- Initial update
updatePlayerList()

-- === Tick-Perfect LoopBring (always persistent) ===
RunService.Heartbeat:Connect(function()
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root or #bringTargets == 0 then return end

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
end)
