local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local LoopBrings = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoopBringGUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- Small toggle button frame
local ToggleFrame = Instance.new("Frame", ScreenGui)
ToggleFrame.Size = UDim2.new(0, 80, 0, 30)
ToggleFrame.Position = UDim2.new(1, -90, 0, 20)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleFrame.BorderSizePixel = 0
ToggleFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner", ToggleFrame)
UICorner.CornerRadius = UDim.new(0, 6)

-- Blood-red glow stroke
local Stroke = Instance.new("UIStroke", ToggleFrame)
Stroke.Color = Color3.fromRGB(139,0,0)
Stroke.Thickness = 2
Stroke.Transparency = 0.2
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Toggle button
local ToggleButton = Instance.new("TextButton", ToggleFrame)
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(139,0,0)
ToggleButton.Text = "loopbring"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.AutoButtonColor = false

local UICornerBtn = Instance.new("UICorner", ToggleButton)
UICornerBtn.CornerRadius = UDim.new(0, 6)

-- Player list panel
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 50)
Frame.Position = UDim2.new(1, -230, 0, 60)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(139,0,0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.ClipsDescendants = true

local Gradient = Instance.new("UIGradient")
Gradient.Parent = Frame
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(139,0,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
Gradient.Rotation = 130

local UICornerFrame = Instance.new("UICorner", Frame)
UICornerFrame.CornerRadius = UDim.new(0, 8)

local ListFrame = Instance.new("ScrollingFrame", Frame)
ListFrame.Size = UDim2.new(1, 0, 1, -10)
ListFrame.Position = UDim2.new(0, 0, 0, 10)
ListFrame.BackgroundTransparency = 1
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout", ListFrame)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.Padding = UDim.new(0, 5)

-- Toggle animation
local function toggleVisibility()
    local goal = {Size = Frame.Visible and UDim2.new(0, 220, 0, 50) or UDim2.new(0, 220, 0, 250)}
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween = TweenService:Create(Frame, tweenInfo, goal)

    Frame.Visible = true
    tween:Play()

    tween.Completed:Connect(function()
        if goal.Size == UDim2.new(0, 220, 0, 50) then
            Frame.Visible = false
        end
    end)
end

ToggleButton.MouseButton1Click:Connect(toggleVisibility)

-- LoopBring function
local function loopBring(targetPlayer, label)
    if LoopBrings[targetPlayer.UserId] then
        LoopBrings[targetPlayer.UserId] = nil
        label.Text = targetPlayer.Name
        label.TextColor3 = Color3.fromRGB(139,0,0)
        return
    end

    LoopBrings[targetPlayer.UserId] = true
    label.Text = targetPlayer.Name .. " [Loopbringed]"
    label.TextColor3 = Color3.fromRGB(255, 85, 85)

    task.spawn(function()
        while LoopBrings[targetPlayer.UserId] and targetPlayer and targetPlayer.Character and LocalPlayer.Character do
            if not Players:FindFirstChild(targetPlayer.Name) then break end
            if targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                targetPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                targetPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
            wait(0.1)
        end
    end)
end

-- Update player list
local function updatePlayerList()
    for _, child in ipairs(ListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local playerButton = Instance.new("TextButton", ListFrame)
            playerButton.Size = UDim2.new(1, 0, 0, 30)
            playerButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            playerButton.TextColor3 = Color3.fromRGB(139,0,0)
            playerButton.Font = Enum.Font.GothamBold
            playerButton.TextSize = 16
            playerButton.AutoButtonColor = false
            playerButton.Text = player.Name

            local UICornerPlayer = Instance.new("UICorner", playerButton)
            UICornerPlayer.CornerRadius = UDim.new(0, 6)

            if LoopBrings[player.UserId] then
                playerButton.Text = player.Name .. " [Loopbringed]"
                playerButton.TextColor3 = Color3.fromRGB(255, 85, 85)
            end

            playerButton.MouseEnter:Connect(function()
                playerButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
            end)

            playerButton.MouseLeave:Connect(function()
                playerButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end)

            playerButton.MouseButton1Click:Connect(function()
                loopBring(player, playerButton)
            end)

            playerButton.Parent = ListFrame
        end
    end

    ListFrame.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 35)
end

Players.PlayerAdded:Connect(function(player)
    updatePlayerList()
    if LoopBrings[player.UserId] then
        task.wait(1)
        for _, button in ipairs(ListFrame:GetChildren()) do
            if button:IsA("TextButton") and button.Text:find(player.Name) then
                loopBring(player, button)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()
