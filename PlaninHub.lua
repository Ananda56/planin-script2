-- =================================================================
-- ⚡ Executor Panel - Roblox In-Game UI (Exact Specification 100%)
-- =================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Theme Color Definitions
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

-- States
local States = {
    BoostFPS = false,
    WalkSpeed = 16,
    JumpHeight = 50,
    FakeFPSValue = 60
}

-- =================================================================
-- 1. ScreenGui Setup
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExecutorPanel_Strict"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- =================================================================
-- 2. Main Frame (760x420, Center, Glassmorphism, Animation)
-- =================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 760, 0, 420)
MainFrame.Position = UDim2.new(0.5, -380, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromHex("#0F0F13")
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Opening Animation (Scale 90% -> 100%, Transparency 1 -> 0.15, Back.Out, 0.35s)
MainFrame.Size = UDim2.new(0, 760 * 0.9, 0, 420 * 0.9)
MainFrame.BackgroundTransparency = 1

TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 760, 0, 420),
    BackgroundTransparency = 0.15
}):Play()

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Transparency = 0.85
MainStroke.Parent = MainFrame

-- =================================================================
-- 3. Header (45px Height)
-- =================================================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Header.BackgroundTransparency = 0.5
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
StatusLabel.Position = UDim2.new(1, -190, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🟢 Connected"
StatusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
StatusLabel.Parent = Header

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

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(239, 68, 68)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    local tw = TweenService:Create(MainFrame, TweenInfo.new(0.25), {
        Size = UDim2.new(0, 760 * 0.95, 0, 420 * 0.95),
        BackgroundTransparency = 1
    })
    tw:Play()
    tw.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- =================================================================
-- 4. Sidebar (3 Menu items exactly: Home, Player, Settings)
-- =================================================================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 180, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Sidebar.BackgroundTransparency = 0.3
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

local function UpdateAllThemeColors(newColor)
    CurrentTheme = newColor
    for _, item in ipairs(ThemeElements) do
        pcall(function()
            item.Object[item.Prop] = newColor
        end)
    end
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
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {Size = UDim2.new(1, -16, 0, 42), Position = UDim2.new(0, 8, 0, yPos)}):Play()
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
    Page.ScrollBarThickness = 0
    Page.Visible = false
    Page.Parent = ContentContainer
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 16)
    Layout.Parent = Page
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 25)
    Padding.PaddingLeft = UDim.new(0, 25)
    Padding.PaddingRight = UDim.new(0, 25)
    Padding.Parent = Page
    
    Pages[name] = Page
    return Page
end

CreateNavButton("Home", "🏠 Home", 15)
CreateNavButton("Player", "👤 Player", 65)
CreateNavButton("Settings", "⚙️ Settings", 115)

-- =================================================================
-- 5. Page: Home
-- =================================================================
local HomePage = CreatePage("Home")

local HomeTitle = Instance.new("TextLabel")
HomeTitle.Size = UDim2.new(1, 0, 0, 30)
HomeTitle.BackgroundTransparency = 1
HomeTitle.Text = "Boost FPS"
HomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.TextSize = 20
HomeTitle.TextXAlignment = Enum.TextXAlignment.Left
HomeTitle.Parent = HomePage

-- Toggle Card
local ToggleCard = Instance.new("Frame")
ToggleCard.Size = UDim2.new(1, 0, 0, 60)
ToggleCard.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ToggleCard.BackgroundTransparency = 0.5
ToggleCard.Parent = HomePage
Instance.new("UICorner", ToggleCard).CornerRadius = UDim.new(0, 8)

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Size = UDim2.new(0, 200, 1, 0)
ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "Boost FPS Mode"
ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleLabel.Font = Enum.Font.GothamBold
ToggleLabel.TextSize = 14
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = ToggleCard

local ToggleBg = Instance.new("TextButton")
ToggleBg.Size = UDim2.new(0, 48, 0, 26)
ToggleBg.Position = UDim2.new(1, -64, 0.5, -13)
ToggleBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ToggleBg.Text = ""
ToggleBg.Parent = ToggleCard
Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

local ToggleCircle = Instance.new("Frame")
ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
ToggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleCircle.Parent = ToggleBg
Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

-- Stats Panel (Fake FPS & CPU / Memory)
local StatsCard = Instance.new("Frame")
StatsCard.Size = UDim2.new(1, 0, 0, 95)
StatsCard.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
StatsCard.BackgroundTransparency = 0.5
StatsCard.Parent = HomePage
Instance.new("UICorner", StatsCard).CornerRadius = UDim.new(0, 8)

local FpsDisplay = Instance.new("TextLabel")
FpsDisplay.Size = UDim2.new(1, -20, 0, 30)
FpsDisplay.Position = UDim2.new(0, 15, 0, 12)
FpsDisplay.BackgroundTransparency = 1
FpsDisplay.Text = "Fake FPS : 60 FPS"
FpsDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsDisplay.Font = Enum.Font.GothamBold
FpsDisplay.TextSize = 14
FpsDisplay.TextXAlignment = Enum.TextXAlignment.Left
FpsDisplay.Parent = StatsCard

local CpuDisplay = Instance.new("TextLabel")
CpuDisplay.Size = UDim2.new(1, -20, 0, 20)
CpuDisplay.Position = UDim2.new(0, 15, 0, 44)
CpuDisplay.BackgroundTransparency = 1
CpuDisplay.Text = "CPU Usage : 8%"
CpuDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
CpuDisplay.Font = Enum.Font.GothamMedium
CpuDisplay.TextSize = 12
CpuDisplay.TextXAlignment = Enum.TextXAlignment.Left
CpuDisplay.Parent = StatsCard

local MemDisplay = Instance.new("TextLabel")
MemDisplay.Size = UDim2.new(1, -20, 0, 20)
MemDisplay.Position = UDim2.new(0, 15, 0, 66)
MemDisplay.BackgroundTransparency = 1
MemDisplay.Text = "Memory : 126 MB"
MemDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
MemDisplay.Font = Enum.Font.GothamMedium
MemDisplay.TextSize = 12
MemDisplay.TextXAlignment = Enum.TextXAlignment.Left
MemDisplay.Parent = StatsCard

-- Toggle Click Event
ToggleBg.MouseButton1Click:Connect(function()
    States.BoostFPS = not States.BoostFPS
    local goalCirclePos = States.BoostFPS and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    local goalBgColor = States.BoostFPS and CurrentTheme or Color3.fromRGB(50, 50, 60)
    
    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = goalCirclePos}):Play()
    TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = goalBgColor}):Play()
    
    if States.BoostFPS then
        local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local valObj = Instance.new("NumberValue")
        valObj.Value = States.FakeFPSValue
        valObj.Changed:Connect(function(v)
            States.FakeFPSValue = math.floor(v)
            FpsDisplay.Text = "Fake FPS : " .. States.FakeFPSValue .. " FPS"
        end)
        TweenService:Create(valObj, tweenInfo, {Value = 1000}):Play()
        task.delay(0.8, function() valObj:Destroy() end)
    else
        States.FakeFPSValue = 60
        FpsDisplay.Text = "Fake FPS : 60 FPS"
    end
end)

RegisterThemeColor(ToggleBg, "BackgroundColor3")

-- =================================================================
-- 6. Page: Player
-- =================================================================
local PlayerPage = CreatePage("Player")

local PlayerTitle = Instance.new("TextLabel")
PlayerTitle.Size = UDim2.new(1, 0, 0, 30)
PlayerTitle.BackgroundTransparency = 1
PlayerTitle.Text = "Player Attributes"
PlayerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerTitle.Font = Enum.Font.GothamBold
PlayerTitle.TextSize = 20
PlayerTitle.TextXAlignment = Enum.TextXAlignment.Left
PlayerTitle.Parent = PlayerPage

local function CreateSlider(title, minVal, maxVal, defaultVal, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 75)
    Card.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Card.BackgroundTransparency = 0.5
    Card.Parent = PlayerPage
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -30, 0, 25)
    Label.Position = UDim2.new(0, 15, 0, 10)
    Label.BackgroundTransparency = 1
    Label.Text = title .. " : " .. defaultVal
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card
    
    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -30, 0, 6)
    BarBg.Position = UDim2.new(0, 15, 0, 48)
    BarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
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
    
    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 0.5, 0)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Text = ""
    Knob.Parent = BarBg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local UserInputService = game:GetService("UserInputService")
    
    Knob.MouseButton1Down:Connect(function() dragging = true end)
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
SettingsTitle.Size = UDim2.new(1, 0, 0, 30)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "Theme Customization"
SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 20
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = SettingsPage

local ThemeCard = Instance.new("Frame")
ThemeCard.Size = UDim2.new(1, 0, 0, 90)
ThemeCard.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ThemeCard.BackgroundTransparency = 0.5
ThemeCard.Parent = SettingsPage
Instance.new("UICorner", ThemeCard).CornerRadius = UDim.new(0, 8)

local ThemeDesc = Instance.new("TextLabel")
ThemeDesc.Size = UDim2.new(1, -30, 0, 20)
ThemeDesc.Position = UDim2.new(0, 15, 0, 12)
ThemeDesc.BackgroundTransparency = 1
ThemeDesc.Text = "Select Theme Color (7 Colors Available)"
ThemeDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
ThemeDesc.Font = Enum.Font.GothamMedium
ThemeDesc.TextSize = 13
ThemeDesc.TextXAlignment = Enum.TextXAlignment.Left
ThemeDesc.Parent = ThemeCard

local ColorContainer = Instance.new("Frame")
ColorContainer.Size = UDim2.new(1, -30, 0, 36)
ColorContainer.Position = UDim2.new(0, 15, 0, 42)
ColorContainer.BackgroundTransparency = 1
ColorContainer.Parent = ThemeCard

local ColorLayout = Instance.new("UIListLayout")
ColorLayout.FillDirection = Enum.FillDirection.Horizontal
ColorLayout.Padding = UDim.new(0, 12)
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
        
        -- Theme transition fade animation (0.25s)
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
