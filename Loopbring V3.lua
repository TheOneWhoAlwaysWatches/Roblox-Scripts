-- Loopbring V3
local bringTargets = {}
local distance = 2
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function createUIElement(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do obj[k] = v end
	return obj
end

-- UI Setup
local ui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ui.Name = "LoopBringUI"
ui.ResetOnSpawn = false

-- Toggle Button
local toggle = createUIElement("TextButton", {
	Parent = ui,
	Text = "≡",
	Size = UDim2.new(0, 32, 0, 32),
	Position = UDim2.new(0, 10, 0, 90),
	BackgroundColor3 = Color3.fromRGB(90, 0, 0),
	TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.GothamBold,
	TextScaled = true,
	ZIndex = 10
})
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
local grad = Instance.new("UIGradient", toggle)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
}
grad.Rotation = 45

-- Main Frame
local frame = createUIElement("Frame", {
	Parent = ui,
	Size = UDim2.new(0, 220, 0, 210),
	Position = UDim2.new(0.5, -110, 0.5, -105),
	BackgroundColor3 = Color3.fromRGB(25, 5, 5),
	BackgroundTransparency = 0.1,
	BorderSizePixel = 0,
	Visible = true,
	Draggable = true,
	Active = true
})
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(200, 0, 0)

toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Distance Label
local distanceLabel = createUIElement("TextLabel", {
	Parent = frame,
	Text = "Distance: " .. distance,
	Size = UDim2.new(1, 0, 0, 25),
	Position = UDim2.new(0, 0, 0, 70),
	BackgroundTransparency = 1,
	TextColor3 = Color3.fromRGB(255, 120, 120),
	Font = Enum.Font.GothamBold,
	TextScaled = true
})

-- Dropdown Button
local dropdownButton = createUIElement("TextButton", {
	Parent = frame,
	Text = "Select Player",
	Size = UDim2.new(1, -20, 0, 30),
	Position = UDim2.new(0, 10, 0, 10),
	BackgroundColor3 = Color3.fromRGB(60, 0, 0),
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBold,
	TextScaled = true
})
Instance.new("UICorner", dropdownButton).CornerRadius = UDim.new(0, 8)

-- Dropdown Frame
local dropdownFrame = createUIElement("Frame", {
	Parent = frame,
	Position = UDim2.new(0, 10, 0, 40),
	Size = UDim2.new(1, -20, 0, 70),
	BackgroundColor3 = Color3.fromRGB(40, 0, 0),
	Visible = false,
	ClipsDescendants = true
})
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", dropdownFrame).Color = Color3.fromRGB(255, 0, 0)

local scroll = createUIElement("ScrollingFrame", {
	Parent = dropdownFrame,
	Size = UDim2.new(1, 0, 1, 0),
	CanvasSize = UDim2.new(0, 0, 0, 0),
	ScrollBarThickness = 5,
	BackgroundTransparency = 1
})
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 2)

-- Styled Button Generator
local function styledButton(text, pos, parent)
	local btn = createUIElement("TextButton", {
		Parent = parent,
		Text = text,
		Size = UDim2.new(0, 80, 0, 28),
		Position = pos,
		BackgroundColor3 = Color3.fromRGB(80, 0, 0),
		TextColor3 = Color3.new(1, 1, 1),
		TextScaled = true,
		Font = Enum.Font.GothamBold
	})
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
	local g = Instance.new("UIGradient", btn)
	g.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0))
	}
	g.Rotation = 90
	return btn
end

-- Bring All & Remove All
local bringAll = styledButton("Bring All", UDim2.new(0.5, -40, 0, 110), frame)
local removeAll = styledButton("Remove All", UDim2.new(0.5, -40, 1, -35), frame)

-- Distance buttons
local plus = styledButton("+", UDim2.new(0.5, 55, 1, -35), frame)
plus.Size = UDim2.new(0, 28, 0, 28)
local minus = styledButton("-", UDim2.new(0.5, -83, 1, -35), frame)
minus.Size = UDim2.new(0, 28, 0, 28)

-- Gradient helper
local function bloodGradient(button)
	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 0))
	}
	grad.Rotation = 45
	grad.Parent = button
end

-- Bring Logic
local function updateTeleportation()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	for _, name in ipairs(bringTargets) do
		local plr = Players:FindFirstChild(name)
		if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local target = plr.Character.HumanoidRootPart
			local pos = root.Position + root.CFrame.LookVector * distance
			target.CFrame = CFrame.new(pos, root.Position) * CFrame.Angles(0, math.rad(180), 0)
		end
	end
end

local function loopBring(name)
	if table.find(bringTargets, name) then return end
	table.insert(bringTargets, name)
	coroutine.wrap(function()
		while table.find(bringTargets, name) do
			updateTeleportation()
			task.wait(0.05)
		end
	end)()
end

local function stopBring(name)
	local i = table.find(bringTargets, name)
	if i then table.remove(bringTargets, i) end
end

local function updatePlayerList()
	for _, btn in ipairs(scroll:GetChildren()) do
		if btn:IsA("TextButton") then btn:Destroy() end
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local b = createUIElement("TextButton", {
				Parent = scroll,
				Text = p.Name,
				Size = UDim2.new(1, -8, 0, 26),
				TextScaled = true,
				Font = Enum.Font.Gotham,
				TextColor3 = table.find(bringTargets, p.Name) and Color3.new(1, 1, 1) or Color3.fromRGB(0, 255, 0),
				BackgroundColor3 = Color3.fromRGB(40, 0, 0)
			})
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
			if table.find(bringTargets, p.Name) then bloodGradient(b) end
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
	scroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 28)
end

-- Button Hooks
dropdownButton.MouseButton1Click:Connect(function()
	dropdownFrame.Visible = not dropdownFrame.Visible
	if dropdownFrame.Visible then updatePlayerList() end
end)

bringAll.MouseButton1Click:Connect(function()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then loopBring(p.Name) end
	end
	updatePlayerList()
end)

removeAll.MouseButton1Click:Connect(function()
	bringTargets = {}
	updatePlayerList()
end)

plus.MouseButton1Click:Connect(function()
	distance += 1
	distanceLabel.Text = "Distance: " .. distance
end)

minus.MouseButton1Click:Connect(function()
	distance = math.max(1, distance - 1)
	distanceLabel.Text = "Distance: " .. distance
end)

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(p)
	stopBring(p.Name)
	updatePlayerList()
end)

distanceLabel.Text = "Distance: " .. distance