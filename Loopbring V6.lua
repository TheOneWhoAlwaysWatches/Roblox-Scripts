local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- SETTINGS
local DEFAULT_DISTANCE = 5 -- default distance players will be brought behind you
local LoopBrings = {}
local BringDistance = DEFAULT_DISTANCE

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoopBringGUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- Toggle Panel
local ToggleFrame = Instance.new("Frame", ScreenGui)
ToggleFrame.Size = UDim2.new(0, 80, 0, 30)
ToggleFrame.Position = UDim2.new(1, -90, 0, 20)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", ToggleFrame)
UICorner.CornerRadius = UDim.new(0, 6)

local Stroke = Instance.new("UIStroke", ToggleFrame)
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2
Stroke.Transparency = 0.2

local ToggleButton = Instance.new("TextButton", ToggleFrame)
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.Text = "LoopBring"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.AutoButtonColor = false

local UICornerBtn = Instance.new("UICorner", ToggleButton)
UICornerBtn.CornerRadius = UDim.new(0, 6)

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 50)
Frame.Position = UDim2.new(1, -230, 0, 60)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.ClipsDescendants = true
Frame.Visible = false

local UICornerFrame = Instance.new("UICorner", Frame)
UICornerFrame.CornerRadius = UDim.new(0, 8)

local ListFrame = Instance.new("ScrollingFrame", Frame)
ListFrame.Size = UDim2.new(1, 0, 1, -40)
ListFrame.Position = UDim2.new(0, 0, 0, 40)
ListFrame.BackgroundTransparency = 1
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout", ListFrame)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.Padding = UDim.new(0, 5)

-- Distance Controls
local DistanceFrame = Instance.new("Frame", Frame)
DistanceFrame.Size = UDim2.new(1, 0, 0, 40)
DistanceFrame.Position = UDim2.new(0, 0, 0, 0)
DistanceFrame.BackgroundTransparency = 1

local DistanceLabel = Instance.new("TextLabel", DistanceFrame)
DistanceLabel.Size = UDim2.new(0.6, 0, 1, 0)
DistanceLabel.Position = UDim2.new(0, 5, 0, 0)
DistanceLabel.BackgroundTransparency = 1
DistanceLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
DistanceLabel.Font = Enum.Font.GothamBold
DistanceLabel.TextSize = 14
DistanceLabel.Text = "Distance: " .. BringDistance

local IncreaseBtn = Instance.new("TextButton", DistanceFrame)
IncreaseBtn.Size = UDim2.new(0.15, 0, 1, 0)
IncreaseBtn.Position = UDim2.new(0.65, 0, 0, 0)
IncreaseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
IncreaseBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
IncreaseBtn.Text = "+"
IncreaseBtn.Font = Enum.Font.GothamBold
IncreaseBtn.TextSize = 20

local DecreaseBtn = Instance.new("TextButton", DistanceFrame)
DecreaseBtn.Size = UDim2.new(0.15, 0, 1, 0)
DecreaseBtn.Position = UDim2.new(0.82, 0, 0, 0)
DecreaseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DecreaseBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
DecreaseBtn.Text = "-"
DecreaseBtn.Font = Enum.Font.GothamBold
DecreaseBtn.TextSize = 20

-- Toggle Animation
local function toggleVisibility()
    local isVisible = Frame.Visible
    Frame.Visible = true
    local goal = {Size = isVisible and UDim2.new(0, 220, 0, 50) or UDim2.new(0, 220, 0, 300)}
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween = TweenService:Create(Frame, tweenInfo, goal)

    tween:Play()
    tween.Completed:Connect(function()
        if isVisible then
            Frame.Visible = false
        end
    end)
end

ToggleButton.MouseButton1Click:Connect(toggleVisibility)

-- LoopBring Function
local function loopBring(targetPlayer, label)
    if LoopBrings[targetPlayer.UserId] then
        LoopBrings[targetPlayer.UserId] = nil
        label.Text = targetPlayer.Name
        label.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end

    LoopBrings[targetPlayer.UserId] = true
    label.Text = targetPlayer.Name .. " [Looped]"
    label.TextColor3 = Color3.fromRGB(255, 50, 50)

    task.spawn(function()
        while LoopBrings[targetPlayer.UserId] and targetPlayer and targetPlayer.Character and LocalPlayer.Character do
            if not Players:FindFirstChild(targetPlayer.Name) then break end
            if targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                targetPlayer.Character.HumanoidRootPart.CFrame =
                    LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -BringDistance)
                targetPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
            task.wait(0.1)
        end
    end)
end

-- Update Player List
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
            playerButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            playerButton.TextColor3 = Color3.fromRGB(255, 0, 0)
            playerButton.Font = Enum.Font.GothamBold
            playerButton.TextSize = 16
            playerButton.AutoButtonColor = false
            playerButton.Text = player.Name

            local UICornerPlayer = Instance.new("UICorner", playerButton)
            UICornerPlayer.CornerRadius = UDim.new(0, 6)

            if LoopBrings[player.UserId] then
                playerButton.Text = player.Name .. " [Looped]"
                playerButton.TextColor3 = Color3.fromRGB(255, 50, 50)
            end

            playerButton.MouseButton1Click:Connect(function()
                loopBring(player, playerButton)
            end)

            playerButton.Parent = ListFrame
        end
    end

    ListFrame.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 35)
end

-- Distance Button Controls
IncreaseBtn.MouseButton1Click:Connect(function()
    BringDistance = BringDistance + 1
    DistanceLabel.Text = "Distance: " .. BringDistance
end)

DecreaseBtn.MouseButton1Click:Connect(function()
    if BringDistance > 1 then
        BringDistance = BringDistance - 1
        DistanceLabel.Text = "Distance: " .. BringDistance
    end
end)

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()
