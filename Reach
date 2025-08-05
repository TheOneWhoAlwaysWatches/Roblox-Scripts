-- Store original properties for restoration

local originalProperties = {}

local function applyReach(tool, size)

    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then

        local handle = tool.Handle

        

        -- Save original properties if not stored

        if not originalProperties[tool] then

            originalProperties[tool] = {

                Size = handle.Size,

                GripPos = tool.GripPos

            }

        end

        -- Apply reach modification

        handle.Size = Vector3.new(0.5, 0.5, size or 9)

        tool.GripPos = Vector3.new(0, 0, 0)

        

        -- Prevent duplicate SelectionBox

        if not handle:FindFirstChild("SelectionBox") then

            local selectionBox = Instance.new("SelectionBox")

            selectionBox.Name = "SelectionBox"

            selectionBox.Adornee = handle

            selectionBox.Parent = handle

        end

        -- Prevent duplicate AntiLag flag

        if not handle:FindFirstChild("AntiLag") then

            local antiLag = Instance.new("BoolValue")

            antiLag.Name = "AntiLag"

            antiLag.Parent = handle

        end

    end

end

local function restoreOriginalProperties(tool)

    if tool:IsA("Tool") and tool:FindFirstChild("Handle") and originalProperties[tool] then

        local handle = tool.Handle

        local props = originalProperties[tool]

        

        -- Restore original size and position

        handle.Size = props.Size

        tool.GripPos = props.GripPos

        

        -- Cleanup stored data

        originalProperties[tool] = nil

    end

end

local function reach(size)

    local player = game.Players.LocalPlayer

    local character = player.Character

    if not character then return end

    for _, tool in ipairs(character:GetChildren()) do

        if tool:IsA("Tool") then

            applyReach(tool, size)

        end

    end

end

local function onCharacterAdded(character)

    character:WaitForChild("HumanoidRootPart")

    -- Apply reach to all existing tools

    reach(9)

    -- Detect when new tools are equipped

    character.ChildAdded:Connect(function(child)

        if child:IsA("Tool") then

            applyReach(child, 9)

        end

    end)

    

    -- Restore original properties when a tool is removed

    character.ChildRemoved:Connect(function(child)

        if child:IsA("Tool") then

            restoreOriginalProperties(child)

        end

    end)

end

-- Bind to player's character

local player = game.Players.LocalPlayer

player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then

    onCharacterAdded(player.Character)

end
