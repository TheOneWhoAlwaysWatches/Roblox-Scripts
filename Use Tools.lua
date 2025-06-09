-- Use Tools

--== UI Setup ==--
local player = game.Players.LocalPlayer
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
toolButton.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green when off
toolButton.TextSize = 20

Instance.new("UICorner", toolButton).CornerRadius = UDim.new(0.2, 0)

local stroke = Instance.new("UIStroke", toolButton)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(200, 0, 0)
stroke.Transparency = 0.1

local gradient = Instance.new("UIGradient", toolButton)
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 0)),
})
gradient.Rotation = 45

--== Logic Setup ==--
local RunService = game:GetService("RunService")
local Heartbeat = RunService.Heartbeat

local attackEnabled = false
local attackingTools = {}

--== Core Functions ==--

local function equipAndUseTools()
	if not attackEnabled or not player.Character then return end

	local tools = player.Backpack:GetChildren()
	for i = 1, #tools do
		local tool = tools[i]
		if tool:IsA("Tool") and not attackingTools[tool] then
			tool.Parent = player.Character
			attackingTools[tool] = true

			-- Fast, frame-based activation
			task.spawn(function()
				while attackEnabled and tool.Parent == player.Character do
					pcall(function() tool:Activate() end)
					Heartbeat:Wait()
				end
				attackingTools[tool] = nil
			end)

			-- Clean up if tool is unequipped
			tool.AncestryChanged:Connect(function(_, parent)
				if not attackEnabled or parent ~= player.Character then
					attackingTools[tool] = nil
				end
			end)
		end
	end
end

local function toggleAttack()
	attackEnabled = not attackEnabled
	toolButton.Text = attackEnabled and "ON" or "OFF"
	toolButton.TextColor3 = attackEnabled and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 0)

	if not attackEnabled then
		-- Unequip all tools
		for _, tool in ipairs(player.Character:GetChildren()) do
			if tool:IsA("Tool") then
				tool.Parent = player.Backpack
			end
		end
		attackingTools = {}
	else
		equipAndUseTools()
	end
end

toolButton.MouseButton1Click:Connect(toggleAttack)

--== Auto Trigger Events ==--

-- Fast backpack equip
player.Backpack.ChildAdded:Connect(function(child)
	if child:IsA("Tool") and attackEnabled then
		child.Parent = player.Character
		equipAndUseTools()
	end
end)

-- Re-equip dropped tools
player.Character.ChildRemoved:Connect(function(tool)
	if attackEnabled and tool:IsA("Tool") then
		task.defer(function()
			if tool.Parent == player.Backpack then
				tool.Parent = player.Character
			end
		end)
	end
end)

-- Re-equip after respawn
player.CharacterAdded:Connect(function()
	task.wait(1)
	if attackEnabled then
		equipAndUseTools()
	end
end)

-- Frame-checker backup (safety net)
Heartbeat:Connect(function()
	if attackEnabled then
		equipAndUseTools()
	end
end)