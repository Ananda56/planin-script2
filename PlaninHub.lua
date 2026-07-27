-- =================================================================
-- ⚡ Executor Panel - Premium Glassmorphism UI (Roblox In-Game)
-- =================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Theme Color Definitions (7 Colors)
local THEMES = {
    Purple = Color3.fromHex("#8B5CF6"),
    Blue = Color3.fromHex("#3B82F6"),
    Green = Color3.fromHex("#22C55E"),
    Yellow = Color3.fromHex("#EAB308"),
    Red = Color3.fromHex("#EF4444"),
    Pink = Color3.fromHex("#EC4899"),
    Black = Color3.fromHex("#111111")
}

local CurrentTheme = THEMES.Purple
local CurrentThemeName = "Purple"

-- States & Logic Variables
local States = {
    BoostFPS = false,
    AutoFarm = false, -- สถานะสำหรับฟาร์มดาบอัตโนมัติ
    WalkSpeed = 16,
    JumpHeight = 50,
    FakeFPSValue = 60
}

-- Thread สำหรับ Auto Farm ดาบอัตโนมัติ (ninjaEvent)
task.spawn(function()
    while true do
        if States.AutoFarm then
            pcall(function()
                LocalPlayer.ninjaEvent:FireServer()
            end)
        end
        task.wait(0.01)
    end
end)

-- =================================================================
-- 1. ScreenGui Setup
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExecutorPanel_Premium"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- =================================================================
-- 2. Main Frame (760x420, Center, Glassmorphism, Responsive)
-- =================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 760, 0, 420)
MainFrame.Position = UDim2.new(0.5, -380, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromHex("#0F0F13")
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- UI Drop Shadow & Corner & Stroke
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.2
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Transparency = 0.8
MainStroke.Parent = MainFrame

-- เปิด UI Animation (Scale 90% -> 100%, Fade In)
MainFrame.Size = UDim2.new(0, 760 * 0.9, 0, 420 * 0.9)
MainFrame.BackgroundTransparency = 1

TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 760, 0, 420),
    BackgroundTransparency = 0.2
}):Play()

-- =================================================================
-- 3. Header (45px Height, Minimize, Close Buttons)
-- =================================================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Header.BackgroundTransparency = 0.4
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(0, 200, 1, 0)
HeaderTitle.Position = UDim2.new(0, 16, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "⚡ Executor Panel"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 14
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 150, 1, 0)
StatusLabel.Position = UDim2.new(1, -220, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🟢 Connected"
StatusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
StatusLabel.Parent = Header

-- Close Button (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -38, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = Header

-- Minimize Button (-)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -74, 0.5, -15)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "─"
MinimizeButton.TextColor3 = Color3.fromRGB(180, 180, 180)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = Header

-- Hover & Click Effects for Window Controls
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(239, 68, 68)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
end)

MinimizeButton.MouseEnter:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
MinimizeButton.MouseLeave:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
end)

-- Close Function with Animation
CloseButton.MouseButton1Click:Connect(function()
    local tw = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 760 * 0.9, 0, 420 * 0.9),
        BackgroundTransparency = 1
    })
    tw:Play()
    tw.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- Minimize / Maximize Function
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 760, 0, 45) or UDim2.new(0, 760, 0, 420)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = targetSize
    }):Play()
end)

-- =================================================================
-- 4. Sidebar & Navigation (Home, Player, Settings)
-- =================================================================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 180, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Sidebar.BackgroundTransparency = 0.25
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -180, 1, -45)
ContentContainer.Position = UDim2.new(0, 180, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ClipsDescendants = true
ContentContainer.Parent = MainFrame

local Pages = {}
local NavButtons = {}
local ActiveIndicators = {}
local ThemeElements = {}

local function RegisterThemeColor(obj, property)
    table.insert(ThemeElements, {Object = obj, Prop = property})
end

local function SwitchPage(pageName)
    for name, page in pairs(Pages) do
        if name == pageName then
            page.Visible = true
            page.Position = UDim2.new(1, 0, 0, 0)
            TweenService:Create(page, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
        else
            page.Visible = false
        end
    end
    for name, ind in pairs(ActiveIndicators) do
        ind.Visible = (name == pageName)
    end
end

local function CreateNavButton(name, displayName, yPos)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -16, 0, 42)
    Btn.Position = UDim2.new(0, 8, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Btn.BackgroundTransparency = 1
    Btn.Text = "      " .. displayName
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Sidebar
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 0, 24)
    Indicator.Position = UDim2.new(0, 0, 0.5, -12)
    Indicator.BackgroundColor3 = CurrentTheme
    Indicator.Visible = (name == "Home")
    Indicator.Parent = Btn
    RegisterThemeColor(Indicator, "BackgroundColor3")
    ActiveIndicators[name] = Indicator
    
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {Size = UDim2.new(1, -12, 0, 42), Position = UDim2.new(0, 10, 0, yPos)}):Play()
        TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {Size = UDim2.new(1, -16, 0, 42), Position = UDim2.new(0, 8, 0, yPos)}):Play()
        TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end)
    
    Btn.MouseButton1Click:Connect(function()
        SwitchPage(name)
    end)
    
    NavButtons[name] = Btn
end

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    Page.Visible = false
    Page.Parent = ContentContainer
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 14)
    Layout.Parent = Page
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 20)
    Padding.PaddingLeft = UDim.new(0, 20)
    Padding.PaddingRight = UDim.new(0, 20)
    Padding.PaddingBottom = UDim.new(0, 20)
    Padding.Parent = Page
    
    Pages[name] = Page
    return Page
end

CreateNavButton("Home", "🏠 Home", 15)
CreateNavButton("Player", "👤 Player", 65)
CreateNavButton("Settings", "⚙️ Settings", 115)

-- =================================================================
-- 5. Page: Home (Boost FPS & Auto Sword Farm)
-- =================================================================
local HomePage = CreatePage("Home")

local HomeTitle = Instance.new("TextLabel")
HomeTitle.Size = UDim2.new(1, 0, 0, 25)
HomeTitle.BackgroundTransparency = 1
HomeTitle.Text = "Dashboard & Automation"
HomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.TextSize = 18
HomeTitle.TextXAlignment = Enum.TextXAlignment.Left
HomeTitle.Parent = HomePage

-- ฟังก์ชันสร้าง Toggle Card แบบพรีเมียม
local function CreateToggleCard(titleText, descText, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 58)
    Card.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Card.BackgroundTransparency = 0.4
    Card.Parent = HomePage
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
    
    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(255, 255, 255)
    CardStroke.Transparency = 0.9
    CardStroke.Parent = Card

    local LabelFrame = Instance.new("Frame")
    LabelFrame.Size = UDim2.new(1, -70, 1, 0)
    LabelFrame.Position = UDim2.new(0, 15, 0, 0)
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.Parent = Card

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = LabelFrame

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, 0, 0, 16)
    Desc.Position = UDim2.new(0, 0, 0, 30)
    Desc.BackgroundTransparency = 1
    Desc.Text = descText
    Desc.TextColor3 = Color3.fromRGB(160, 160, 160)
    Desc.Font = Enum.Font.GothamMedium
    Desc.TextSize = 11
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = LabelFrame

    local ToggleBg = Instance.new("TextButton")
    ToggleBg.Size = UDim2.new(0, 44, 0, 24)
    ToggleBg.Position = UDim2.new(1, -54, 0.5, -12)
    ToggleBg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ToggleBg.Text = ""
    ToggleBg.Parent = Card
    Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -9)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.Parent = ToggleBg
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

    local toggled = false
    ToggleBg.MouseButton1Click:Connect(function()
        toggled = not toggled
        local goalPos = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local goalColor = toggled and CurrentTheme or Color3.fromRGB(45, 45, 55)
        
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = goalPos}):Play()
        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
        
        callback(toggled)
    end)

    RegisterThemeColor(ToggleBg, "BackgroundColor3")
    return ToggleBg, function(val)
        toggled = val
        local goalPos = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local goalColor = toggled and CurrentTheme or Color3.fromRGB(45, 45, 55)
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = goalPos}):Play()
        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
    end
end

-- 1. Boost FPS Toggle
CreateToggleCard("Boost FPS", "Optimizes rendering performance (Fake 1000 FPS)", function(state)
    States.BoostFPS = state
    if state then
        local valObj = Instance.new("NumberValue")
        valObj.Value = States.FakeFPSValue
        valObj.Changed:Connect(function(v)
            States.FakeFPSValue = math.floor(v)
            if _G.UpdateFpsLabel then _G.UpdateFpsLabel(States.FakeFPSValue) end
        end)
        TweenService:Create(valObj, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Value = 1000}):Play()
        task.delay(0.8, function() valObj:Destroy() end)
    else
        States.FakeFPSValue = 60
        if _G.UpdateFpsLabel then _G.UpdateFpsLabel(60) end
    end
end)

-- 2. Auto Sword Farm Toggle (ninjaEvent) ตามคำขอ
CreateToggleCard("Auto Sword Farm", "Automatically fires ninjaEvent for sword training", function(state)
    States.AutoFarm = state
end)

-- Stats Card (FPS & Hardware Monitor)
local StatsCard = Instance.new("Frame")
StatsCard.Size = UDim2.new(1, 0, 0, 85)
StatsCard.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
StatsCard.BackgroundTransparency = 0.4
StatsCard.Parent = HomePage
Instance.new("UICorner", StatsCard).CornerRadius = UDim.new(0, 8)

local FpsDisplay = Instance.new("TextLabel")
FpsDisplay.Size = UDim2.new(1, -30, 0, 25)
FpsDisplay.Position = UDim2.new(0, 15, 0, 12)
FpsDisplay.BackgroundTransparency = 1
FpsDisplay.Text = "Fake FPS : 60 FPS"
FpsDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsDisplay.Font = Enum.Font.GothamBold
FpsDisplay.TextSize = 13
FpsDisplay.TextXAlignment = Enum.TextXAlignment.Left
FpsDisplay.Parent = StatsCard

_G.UpdateFpsLabel = function(val)
    FpsDisplay.Text = "Fake FPS : " .. val .. " FPS"
end

local CpuDisplay = Instance.new("TextLabel")
CpuDisplay.Size = UDim2.new(1, -30, 0, 20)
CpuDisplay.Position = UDim2.new(0, 15, 0, 38)
CpuDisplay.BackgroundTransparency = 1
CpuDisplay.Text = "CPU Usage : 8%"
CpuDisplay.TextColor3 = Color3.fromRGB(160, 160, 160)
CpuDisplay.Font = Enum.Font.GothamMedium
CpuDisplay.TextSize = 11
CpuDisplay.TextXAlignment = Enum.TextXAlignment.Left
CpuDisplay.Parent = StatsCard

local MemDisplay = Instance.new("TextLabel")
MemDisplay.Size = UDim2.new(1, -30, 0, 20)
MemDisplay.Position = UDim2.new(0, 15, 0, 58)
MemDisplay.BackgroundTransparency = 1
MemDisplay.Text = "Memory : 126 MB"
MemDisplay.TextColor3 = Color3.fromRGB(160, 160, 160)
MemDisplay.Font = Enum.Font.GothamMedium
MemDisplay.TextSize = 11
MemDisplay.TextXAlignment = Enum.TextXAlignment.Left
MemDisplay.Parent = StatsCard

-- =================================================================
-- 6. Page: Player (WalkSpeed & JumpHeight Sliders)
-- =================================================================
local PlayerPage = CreatePage("Player")

local PlayerTitle = Instance.new("TextLabel")
PlayerTitle.Size = UDim2.new(1, 0, 0, 25)
PlayerTitle.BackgroundTransparency = 1
PlayerTitle.Text = "Player Attributes"
PlayerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerTitle.Font = Enum.Font.GothamBold
PlayerTitle.TextSize = 18
PlayerTitle.TextXAlignment = Enum.TextXAlignment.Left
PlayerTitle.Parent = PlayerPage

local function CreateSlider(title, minVal, maxVal, defaultVal, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 70)
    Card.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Card.BackgroundTransparency = 0.4
    Card.Parent = PlayerPage
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -30, 0, 22)
    Label.Position = UDim2.new(0, 15, 0, 10)
    Label.BackgroundTransparency = 1
    Label.Text = title .. " : " .. defaultVal
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card
    
    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -30, 0, 6)
    BarBg.Position = UDim2.new(0, 15, 0, 44)
    BarBg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = Card
    Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)
    
    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    BarFill.BackgroundColor3 = CurrentTheme
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBg
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)
    RegisterThemeColor(BarFill, "BackgroundColor3")
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 0.5, 0)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = BarBg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local UserInputService = game:GetService("UserInputService")
    
    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    BarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = BarBg.AbsolutePosition
            local absSize = BarBg.AbsoluteSize
            local pos = math.clamp((mousePos.X - absPos.X) / absSize.X, 0, 1)
            
            BarFill.Size = UDim2.new(pos, 0, 1, 0)
            Knob.Position = UDim2.new(pos, 0, 0.5, 0)
            
            local current = math.floor(minVal + (maxVal - minVal) * pos)
            Label.Text = title .. " : " .. current
            callback(current)
        end
    end)
end

CreateSlider("Walk Speed", 16, 200, 16, function(v)
    States.WalkSpeed = v
    pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = v end)
end)

CreateSlider("Jump Height", 50, 200, 50, function(v)
    States.JumpHeight = v
    pcall(function() 
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = v 
    end)
end)

-- =================================================================
-- 7. Page: Settings (7 Colors Theme Switcher)
-- =================================================================
local SettingsPage = CreatePage("Settings")

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, 0, 0, 25)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "Theme Customization"
SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 18
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = SettingsPage

local ThemeCard = Instance.new("Frame")
ThemeCard.Size = UDim2.new(1, 0, 0, 95)
ThemeCard.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ThemeCard.BackgroundTransparency = 0.4
ThemeCard.Parent = SettingsPage
Instance.new("UICorner", ThemeCard).CornerRadius = UDim.new(0, 8)

local ThemeDesc = Instance.new("TextLabel")
ThemeDesc.Size = UDim2.new(1, -30, 0, 20)
ThemeDesc.Position = UDim2.new(0, 15, 0, 12)
ThemeDesc.BackgroundTransparency = 1
ThemeDesc.Text = "Select Theme Color (7 Colors Available)"
ThemeDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
ThemeDesc.Font = Enum.Font.GothamMedium
ThemeDesc.TextSize = 12
ThemeDesc.TextXAlignment = Enum.TextXAlignment.Left
ThemeDesc.Parent = ThemeCard

local ColorContainer = Instance.new("Frame")
ColorContainer.Size = UDim2.new(1, -30, 0, 38)
ColorContainer.Position = UDim2.new(0, 15, 0, 42)
ColorContainer.BackgroundTransparency = 1
ColorContainer.Parent = ThemeCard

local ColorLayout = Instance.new("UIListLayout")
ColorLayout.FillDirection = Enum.FillDirection.Horizontal
ColorLayout.Padding = UDim.new(0, 10)
ColorLayout.Parent = ColorContainer

local function CreateColorButton(colorName, colorValue)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 36, 0, 36)
    Btn.BackgroundColor3 = colorValue
    Btn.Text = ""
    Btn.Parent = ColorContainer
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Transparency = (colorName == CurrentThemeName) and 0 or 1
    Stroke.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        CurrentThemeName = colorName
        for _, child in ipairs(ColorContainer:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChild("UIStroke") then
                child.UIStroke.Transparency = (child == Btn) and 0 or 1
            end
        end
        
        -- Theme Fade Transition (0.25s)
        local twInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        for _, item in ipairs(ThemeElements) do
            pcall(function()
                TweenService:Create(item.Object, twInfo, {[item.Prop] = colorValue}):Play()
            end)
        end
        CurrentTheme = colorValue
    end)
end

CreateColorButton("Purple", THEMES.Purple)
CreateColorButton("Blue", THEMES.Blue)
CreateColorButton("Green", THEMES.Green)
CreateColorButton("Yellow", THEMES.Yellow)
CreateColorButton("Red", THEMES.Red)
CreateColorButton("Pink", THEMES.Pink)
CreateColorButton("Black", THEMES.Black)

-- Default Page open
SwitchPage("Home")
