-- ⚔️ TDW Hyper Tool Spammer (Max Tick Speed)

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- UI Setup
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "DemonicToolGui"
screenGui.ResetOnSpawn = false

local toolButton = Instance.new("TextButton")
toolButton.Name = "AttackToggle"
toolButton.Parent = screenGui
toolButton.Position = UDim2.new(1, -170, 0, 100)
toolButton.Size = UDim2.new(0, 80, 0, 40)
toolButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
toolButton.Font = Enum.Font.GothamBlack
toolButton.Text = "OFF"
toolButton.TextColor3 = Color3.fromRGB(0, 255, 0)
toolButton.TextSize = 20

Instance.new("UICorner", toolButton).CornerRadius = UDim.new(0.2, 0)

local stroke = Instance.new("UIStroke", toolButton)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(200, 0, 0)

local gradient = Instance.new("UIGradient", toolButton)
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 0)),
})
gradient.Rotation = 45

-- Logic
local attacking = false
local activeTools = {}

local function activateTool(tool)
	if activeTools[tool] then return end
	activeTools[tool] = true

	task.spawn(function()
		while attacking and tool.Parent == player.Character do
			pcall(function() tool:Activate() end)
			RunService.PostSimulation:Wait()
		end
		activeTools[tool] = nil
	end)

	tool.AncestryChanged:Connect(function(_, parent)
		if not attacking or parent ~= player.Character then
			activeTools[tool] = nil
		end
	end)
end

local function equipAllTools()
	if not attacking or not player.Character then return end
	for _, tool in ipairs(player.Backpack:GetChildren()) do
		if tool:IsA("Tool") then
			tool.Parent = player.Character
		end
	end
	for _, tool in ipairs(player.Character:GetChildren()) do
		if tool:IsA("Tool") then
			activateTool(tool)
		end
	end
end

local function toggleAttack()
	attacking = not attacking
	toolButton.Text = attacking and "ON" or "OFF"
	toolButton.TextColor3 = attacking and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 0)

	if not attacking then
		for _, tool in ipairs(player.Character:GetChildren()) do
			if tool:IsA("Tool") then
				tool.Parent = player.Backpack
			end
		end
		activeTools = {}
	else
		equipAllTools()
	end
end

toolButton.MouseButton1Click:Connect(toggleAttack)

-- Event Handlers
player.Backpack.ChildAdded:Connect(function(child)
	if child:IsA("Tool") and attacking then
		child.Parent = player.Character
	end
end)

player.CharacterAdded:Connect(function()
	task.wait(1)
	if attacking then
		equipAllTools()
	end
end)

-- 🔁 Ultra Fast Tick Equip/Use Handler
RunService.PostSimulation:Connect(function()
	if attacking then
		equipAllTools()
	end
end)
