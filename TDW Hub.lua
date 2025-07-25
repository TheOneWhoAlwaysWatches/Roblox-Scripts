--// Whitelist Setup (UserId-based) 
local whitelist = {
    [3972688973] = true, -- Main Acc
    [2522193455] = true, -- Inf God (Alt)
    [5146822757] = true, -- Monkey (Alt)
    [5054998059] = true, -- mjendeub (Alt)
  	[3429553477] = true, -- Dyllan144335 (Alt)
    [8407911841] = true, -- Void (Star)
    [1548866917] = true, -- Timmy
    [8551057429] = true, -- Timmy Alt
    [1799483953] = true, -- Sword
    [8237187551] = true, -- Alijah
    [1746591571] = true, -- Jenn
    [2901968025] = true, -- Eggy Alt
    [1513169967] = true, -- Eggy Main
    [7641469342] = true, -- Eggy Other Alt
}

local player = game.Players.LocalPlayer
if not whitelist[player.UserId] then
    player:Kick("GET OUT.")
    return
end

--// UI Initialization
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "TDWHub"

--// Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 620, 0, 370)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 3
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Name = "MainFrame"
MainFrame.ClipsDescendants = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = MainFrame

--// Toggle Button
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 40, 0, 40)
Toggle.Position = UDim2.new(0, 10, 0.5, -20)
Toggle.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Toggle.Text = "≡"
Toggle.TextColor3 = Color3.fromRGB(255, 0, 0)
Toggle.TextScaled = true
Toggle.Active = true
Toggle.Draggable = true

Toggle.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 20, 0, 0) -- Nudges the title 20 pixels to the right
Title.BackgroundTransparency = 1
Title.Text = "TDW HUB"
Title.Font = Enum.Font.Arcade
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Center

-- God Mode Tip (Moved upward to be visible, above page buttons)
local tipLabel = Instance.new("TextLabel", MainFrame)
tipLabel.Size = UDim2.new(0, 250, 0, 25)
tipLabel.Position = UDim2.new(0, 10, 0, 10)  -- Placed near top-right below title
tipLabel.BackgroundTransparency = 1
tipLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
tipLabel.Font = Enum.Font.Arcade
tipLabel.TextScaled = true
tipLabel.TextXAlignment = Enum.TextXAlignment.Left
tipLabel.Text = "Tip: Don't use Fast Respawn with God Mode"

--// Page Buttons Frame
local PageButtons = Instance.new("Frame", MainFrame)
PageButtons.Size = UDim2.new(0, 120, 1, -40)
PageButtons.Position = UDim2.new(0, 0, 0, 40)
PageButtons.BackgroundTransparency = 1

--// Divider Line between page buttons and scripts
local divider = Instance.new("Frame", MainFrame)
divider.Size = UDim2.new(0, 3, 1, -40)
divider.Position = UDim2.new(0, 125, 0, 40)
divider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
divider.BorderSizePixel = 0

--// Page Table
local Pages = {}
local currentPage = nil

--// Page Creation Function
local function createPage(name)
    local Page = Instance.new("Frame", MainFrame)
    Page.Size = UDim2.new(1, -135, 1, -40)
    Page.Position = UDim2.new(0, 130, 0, 40)
    Page.BackgroundTransparency = 1
    Page.Visible = (currentPage == nil)
    Page.Name = name
    Pages[name] = Page
    if not currentPage then currentPage = name end
    return Page
end

--// Create Pages with custom names
createPage("Main")
createPage("Misc Scripts")
createPage("Other Hubs")

local pageOrder = {"Main", "Misc Scripts", "Other Hubs"}
local buttonIndex = 0

for _, name in ipairs(pageOrder) do
    local page = Pages[name]
    local btn = Instance.new("TextButton", PageButtons)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, buttonIndex * 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 0, 0)
    btn.Font = Enum.Font.Arcade
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for pageName, frame in pairs(Pages) do
            frame.Visible = (pageName == name)
        end
        currentPage = name
    end)

    buttonIndex += 1
end

--// Script Functions organized by page
local Scripts = {
    ["Main"] = {
        function() loadstring(game:HttpGet("https://pastebin.com/raw/eGSEtnMf", true))() end, -- Get Base - 1
        function() loadstring(game:HttpGet("https://pastebin.com/raw/hPaJ14Yz", true))() end, -- Use Tools - 2
        function() loadstring(game:HttpGet("https://pastebin.com/raw/KY6nYR5k", true))() end, -- Get Tools - 3
        function() loadstring(game:HttpGet("https://pastebin.com/raw/KLuBj9p6", true))() end, -- God Cooldown - 4
        function() loadstring(game:HttpGet("https://pastebin.com/raw/y86skg02", true))() end, -- Respawn - 5
        function() loadstring(game:HttpGet("https://pastebin.com/raw/EcW85BCT", true))() end, -- Kill Aura - 6
        function() loadstring(game:HttpGet("https://pastebin.com/raw/JAJ42fWK", true))() end, -- Loopbring - 7
        function() loadstring(game:HttpGet("https://pastebin.com/raw/DRTgygJ2", true))() end, -- Infinite Yeild - 8
        function() loadstring(game:HttpGet("https://pastebin.com/raw/cAgbbMhi", true))() end, -- Anti Lag - 9
        function() loadstring(game:HttpGet("https://pastebin.com/raw/KKrLEsQd", true))() end, -- Auto Build Base - 10
        function() loadstring(game:HttpGet("https://pastebin.com/raw/aZik0isE", true))() end -- God Mode - 11
    },
        
    ["Misc Scripts"] = {
        function() loadstring(game:HttpGet("https://pastebin.com/raw/w1DW0m31",true))() end, -- Chat Spy - 1
        function() loadstring(game:HttpGet("https://pastebin.com/raw/eCpipCTH",true))() end, -- Emote Gui - 2
        function() loadstring(game:HttpGet("https://pastefy.app/xjoCsunl/raw",true))() end -- Ragdoll Tools - 3
    },
    ["Other Hubs"] = {
        function() loadstring(game:HttpGet("https://pastefy.app/kwOI1DmM/raw",true))() end, -- CTLM Hub V1 - 1
        function() loadstring(game:HttpGet("https://pastefy.app/UbJgpOeQ/raw",true))() end, -- CTLM Hub V2 - 2
        function() loadstring(game:HttpGet("https://pastefy.app/xhFiwEWy/raw",true))() end, -- Destroyer Hub - 3
        function() loadstring(game:HttpGet("https://raw.githubusercontent.com/3dsonsuce/acrylix/main/Acrylix",true))() end -- Acrylix - 4
    }
}

--// Button Factory using Scripts table
local function pagedButton(pageName, label, pos, scriptIndex)
    local btn = Instance.new("TextButton", Pages[pageName])
    btn.Size = UDim2.new(0, 150, 0, 40)
    btn.Position = pos
    btn.Text = label
    btn.Font = Enum.Font.Arcade
    btn.TextColor3 = Color3.fromRGB(255, 0, 0)
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(20, 0, 0)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local pageScripts = Scripts[pageName]
        if pageScripts and pageScripts[scriptIndex] then
            pageScripts[scriptIndex]()
        else
            print("Script not found for button:", label)
        end
    end)
end

--// Main Scripts buttons
pagedButton("Main", "Get Base V2", UDim2.new(0, 10, 0, 10), 1)
pagedButton("Main", "Use Tools V5", UDim2.new (0, 170, 0, 10), 2)
pagedButton("Main", "Get Tools", UDim2.new(0, 330, 0, 10), 3)
pagedButton("Main", "God Cooldown", UDim2.new(0, 10, 0, 60), 4)
pagedButton("Main", "Respawn V3", UDim2.new(0, 170, 0, 60), 5)
pagedButton("Main", "Kill Aura", UDim2.new(0, 330, 0, 60), 6)
pagedButton("Main", "Loopbring V2", UDim2.new(0, 10, 0, 110), 7)
pagedButton("Main", "Infinite Yeild", UDim2.new(0, 170, 0, 110), 8)
pagedButton("Main", "Anti Lag V2", UDim2.new(0, 330, 0, 110), 9)
pagedButton("Main", "Auto Build Base", UDim2.new(0, 10, 0, 160), 10)
pagedButton("Main", "God Mode", UDim2.new(0, 170, 0, 160), 11)

--// Misc Scripts buttons
pagedButton("Misc Scripts", "Auto Build Base", UDim2.new(0, 10, 0, 10), 1)
pagedButton("Misc Scripts", "Chat Spy", UDim2.new(0, 170, 0, 10), 2)
pagedButton("Misc Scripts", "Emote GUI", UDim2.new(0, 330, 0, 10), 3)
pagedButton("Misc Scripts", "Ragdoll Tools", UDim2.new(0, 10, 0, 60), 4)

--// Other Hubs buttons
pagedButton("Other Hubs", "CTLM Hub V1", UDim2.new(0, 10, 0, 10), 1)
pagedButton("Other Hubs", "CTLM Hub V2", UDim2.new(0, 170, 0, 10), 2)
pagedButton("Other Hubs", "Destroyer Hub", UDim2.new(0, 330, 0, 10), 3)
pagedButton("Other Hubs", "Acrylix", UDim2.new(o, 10, 0, 60), 4)