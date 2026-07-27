-- =================================================================
-- 🐟 Planin Hub - Advanced Gaming Intelligence (Exact HTML Replica)
-- =================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local THEME = {
    BgColor = Color3.fromRGB(12, 12, 12),
    SidebarBg = Color3.fromRGB(20, 20, 20),
    CardBg = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(255, 0, 0),
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(176, 176, 176)
}

local States = {
    WalkSpeed = 16,
    JumpPower = 50,
    GodMode = false,
    Invisibility = false
}

-- =================================================================
-- 1. สร้าง ScreenGui หลัก
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlaninHub_HTML_Style"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- =================================================================
-- 2. โครงสร้างหน้าต่างหลัก (Main Layout)
-- =================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 850, 0, 520)
MainFrame.Position = UDim2.new(0.5, -425, 0.5, -260)
MainFrame.BackgroundColor3 = THEME.BgColor
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Top Navbar
local Navbar = Instance.new("Frame")
Navbar.Size = UDim2.new(1, 0, 0, 50)
Navbar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Navbar.BorderSizePixel = 0
Navbar.Parent = MainFrame

local NavTitle = Instance.new("TextLabel")
NavTitle.Size = UDim2.new(0, 300, 1, 0)
NavTitle.Position = UDim2.new(0, 20, 0, 0)
NavTitle.BackgroundTransparency = 1
NavTitle.Text = "PLANIN HUB   DISCORD.GG/G4fwZWnUTA"
NavTitle.TextColor3 = THEME.TextMuted
NavTitle.Font = Enum.Font.Code
NavTitle.TextSize = 12
NavTitle.TextXAlignment = Enum.TextXAlignment.Left
NavTitle.Parent = Navbar

local LiveStatus = Instance.new("TextLabel")
LiveStatus.Size = UDim2.new(0, 200, 1, 0)
LiveStatus.Position = UDim2.new(1, -220, 0, 0)
LiveStatus.BackgroundTransparency = 1
LiveStatus.Text = "●  LIVE STATUS: WORKING"
LiveStatus.TextColor3 = Color3.fromRGB(34, 197, 94)
LiveStatus.Font = Enum.Font.GothamBold
LiveStatus.TextSize = 11
LiveStatus.TextXAlignment = Enum.TextXAlignment.Right
LiveStatus.Parent = Navbar

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 220, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = THEME.SidebarBg
Sidebar.BackgroundTransparency = 0.6
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Content Area
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -220, 1, -50)
Container.Position = UDim2.new(0, 220, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- =================================================================
-- 3. ระบบ Tab & Navigation แบบเป๊ะตาม HTML
-- =================================================================
local Pages = {}
local NavButtons = {}
local AccentElements = {} -- เก็บ element ที่ต้องเปลี่ยนสีตาม Accent Color

local function RegisterAccentElement(element, prop)
    table.insert(AccentElements, {Obj = element, Prop = prop})
end

local function UpdateAccentColors(newColor)
    THEME.Accent = newColor
    for _, item in ipairs(AccentElements) do
        pcall(function()
            item.Obj[item.Prop] = newColor
        end)
    end
end

local function SwitchTab(tabName)
    for name, page in pairs(Pages) do
        page.Visible = (name == tabName)
    end
    for name, btnData in pairs(NavButtons) do
        local btn = btnData.Button
        local indicator = btnData.Indicator
        if name == tabName then
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundTransparency = 0.9
            btn.TextColor3 = THEME.TextWhite
            indicator.Visible = true
        else
            btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            btn.BackgroundTransparency = 1
            btn.TextColor3 = THEME.TextMuted
            indicator.Visible = false
        end
    end
end

local function CreateNavButton(name, text, yPos)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 40)
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = "      " .. text
    Btn.TextColor3 = THEME.TextMuted
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.AutoButtonColor = false
    Btn.Parent = Sidebar
    
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    -- Active Indicator แถบสีแดงด้านซ้าย
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 1, 0)
    Indicator.BackgroundColor3 = THEME.Accent
    Indicator.Visible = false
    Indicator.Parent = Btn
    RegisterAccentElement(Indicator, "BackgroundColor3")
    
    Btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
    
    NavButtons[name] = {Button = Btn, Indicator = Indicator}
end

local function CreatePageFrame(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.Visible = false
    Page.Parent = Container
    
    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 20)
    UIList.Parent = Page
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 40)
    UIPadding.PaddingLeft = UDim.new(0, 40)
    UIPadding.PaddingRight = UDim.new(0, 40)
    UIPadding.Parent = Page
    
    Pages[name] = Page
    return Page
end

CreateNavButton("home", "Home", 20)
CreateNavButton("character", "Character", 70)
CreateNavButton("settings", "Preferences", 125)

-- =================================================================
-- 4. สร้างเนื้อหาแต่ละหน้า (HTML Replica)
-- =================================================================

---------------------------------------------------------------------
-- PAGE: HOME
---------------------------------------------------------------------
local HomePage = CreatePageFrame("home")

local HomeTitle = Instance.new("TextLabel")
HomeTitle.Size = UDim2.new(1, 0, 0, 50)
HomeTitle.BackgroundTransparency = platform or 1
HomeTitle.Text = "Home  •"
HomeTitle.TextColor3 = THEME.TextWhite
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.TextSize = 32
HomeTitle.TextXAlignment = Enum.TextXAlignment.Left
HomeTitle.Parent = HomePage
RegisterAccentElement(HomeTitle, "TextColor3")

local HomeDesc = Instance.new("TextLabel")
HomeDesc.Size = UDim2.new(1, 0, 0, 30)
HomeDesc.BackgroundTransparency = 1
HomeDesc.Text = "Welcome back. Everything is synced and ready to perform. Your configuration \"Optimized_v2\" is loaded."
HomeDesc.TextColor3 = THEME.TextMuted
HomeDesc.Font = Enum.Font.Gotham
HomeDesc.TextSize = 13
HomeDesc.TextXAlignment = Enum.TextXAlignment.Left
HomeDesc.Parent = HomePage

-- Grid Cards ในหน้า Home
local HomeGrid = Instance.new("Frame")
HomeGrid.Size = UDim2.new(1, 0, 0, 120)
HomeGrid.BackgroundTransparency = 1
HomeGrid.Parent = HomePage

local GridFlow = Instance.new("UIListLayout")
GridFlow.FillDirection = Enum.FillDirection.Horizontal
GridFlow.Padding = UDim.new(0, 15)
GridFlow.Parent = HomeGrid

local function CreateHomeCard(title, desc)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(0.48, 0, 1, 0)
    Card.BackgroundColor3 = THEME.CardBg
    Card.BackgroundTransparency = 0.8
    Card.Parent = HomeGrid
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)
    
    local T = Instance.new("TextLabel")
    T.Size = UDim2.new(1, -60, 0, 25)
    T.Position = UDim2.new(0, 20, 0, 20)
    T.BackgroundTransparency = 1
    T.Text = title
    T.TextColor3 = THEME.TextWhite
    T.Font = Enum.Font.GothamBold
    T.TextSize = 15
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.Parent = Card
    
    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1, -60, 0, 40)
    D.Position = UDim2.new(0, 20, 0, 45)
    D.BackgroundTransparency = 1
    D.Text = desc
    D.TextColor3 = THEME.TextMuted
    D.Font = Enum.Font.Gotham
    D.TextSize = 11
    D.TextWrapped = true
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.Parent = Card
end

CreateHomeCard("Auto Farm", "Automatically harvest resources in the current zone.")
CreateHomeCard("Auto Click", "Simulate rapid clicking at the cursor position.")

---------------------------------------------------------------------
-- PAGE: CHARACTER
---------------------------------------------------------------------
local CharPage = CreatePageFrame("character")

local CharTitle = Instance.new("TextLabel")
CharTitle.Size = UDim2.new(1, 0, 0, 50)
CharTitle.BackgroundTransparency = 1
CharTitle.Text = "Character  •"
CharTitle.TextColor3 = THEME.TextWhite
CharTitle.Font = Enum.Font.GothamBold
CharTitle.TextSize = 32
CharTitle.TextXAlignment = Enum.TextXAlignment.Left
CharTitle.Parent = CharPage
RegisterAccentElement(CharTitle, "TextColor3")

local CharDesc = Instance.new("TextLabel")
CharDesc.Size = UDim2.new(1, 0, 0, 20)
CharDesc.BackgroundTransparency = 1
CharDesc.Text = "Modify your interaction with the world and physical attributes."
CharDesc.TextColor3 = THEME.TextMuted
CharDesc.Font = Enum.Font.Gotham
CharDesc.TextSize = 13
CharDesc.TextXAlignment = Enum.TextXAlignment.Left
CharDesc.Parent = CharPage

-- Character Inputs / Toggles Box
local CharBox = Instance.new("Frame")
CharBox.Size = UDim2.new(1, 0, 0, 180)
CharBox.BackgroundColor3 = THEME.CardBg
CharBox.BackgroundTransparency = 0.8
CharBox.Parent = CharPage
Instance.new("UICorner", CharBox).CornerRadius = UDim.new(0, 12)

local function AddSpeedControl(yOffset, labelText, defaultVal, callback)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(0, 200, 0, 20)
    L.Position = UDim2.new(0, 20, 0, yOffset)
    L.BackgroundTransparency = 1
    L.Text = labelText
    L.TextColor3 = THEME.TextWhite
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = CharBox
    
    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0, 60, 0, 30)
    Box.Position = UDim2.new(1, -80, 0, yOffset - 5)
    Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Box.Text = tostring(defaultVal)
    Box.TextColor3 = THEME.TextWhite
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 13
    Box.Parent = CharBox
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
    
    Box.FocusLost:Connect(function()
        local v = tonumber(Box.Text)
        if v then callback(v) else Box.Text = tostring(defaultVal) end
    end)
end

AddSpeedControl(30, "Walk Speed", 16, function(val)
    States.WalkSpeed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

AddSpeedControl(90, "Jump Power", 50, function(val)
    States.JumpPower = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

---------------------------------------------------------------------
-- PAGE: SETTINGS (Preferences)
---------------------------------------------------------------------
local SettingsPage = CreatePageFrame("settings")

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, 0, 0, 50)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "Settings  •"
SettingsTitle.TextColor3 = THEME.TextWhite
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 32
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = SettingsPage
RegisterAccentElement(SettingsTitle, "TextColor3")

local SettingsDesc = Instance.new("TextLabel")
SettingsDesc.Size = UDim2.new(1, 0, 0, 20)
SettingsDesc.BackgroundTransparency = 1
SettingsDesc.Text = "Customize the look and feel of your Planin Hub experience."
SettingsDesc.TextColor3 = THEME.TextMuted
SettingsDesc.Font = Enum.Font.Gotham
SettingsDesc.TextSize = 13
SettingsDesc.TextXAlignment = Enum.TextXAlignment.Left
SettingsDesc.Parent = SettingsPage

local SettingsBox = Instance.new("Frame")
SettingsBox.Size = UDim2.new(1, 0, 0, 200)
SettingsBox.BackgroundColor3 = THEME.CardBg
SettingsBox.BackgroundTransparency = 0.8
SettingsBox.Parent = SettingsPage
Instance.new("UICorner", SettingsBox).CornerRadius = UDim.new(0, 12)

local AccLabel = Instance.new("TextLabel")
AccLabel.Size = UDim2.new(1, -40, 0, 30)
AccLabel.Position = UDim2.new(0, 20, 0, 20)
AccLabel.BackgroundTransparency = 1
AccLabel.Text = "ACTIVE ACCENT COLOR"
AccLabel.TextColor3 = THEME.TextMuted
AccLabel.Font = Enum.Font.GothamBold
AccLabel.TextSize = 11
AccLabel.TextXAlignment = Enum.TextXAlignment.Left
AccLabel.Parent = SettingsBox

local ColorRow = Instance.new("Frame")
ColorRow.Size = UDim2.new(1, -40, 0, 45)
ColorRow.Position = UDim2.new(0, 20, 0, 55)
ColorRow.BackgroundTransparency = 1
ColorRow.Parent = SettingsBox

local ColorList = Instance.new("UIListLayout")
ColorList.FillDirection = Enum.FillDirection.Horizontal
ColorList.Padding = UDim.new(0, 12)
ColorList.Parent = ColorRow

local function CreateColorSelector(color)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 40, 0, 40)
    Btn.BackgroundColor3 = color
    Btn.Text = ""
    Btn.Parent = ColorRow
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    Btn.MouseButton1Click:Connect(function()
        UpdateAccentColors(color)
    end)
end

CreateColorSelector(Color3.fromRGB(255, 0, 0))    -- Red
CreateColorSelector(Color3.fromRGB(59, 130, 246)) -- Blue
CreateColorSelector(Color3.fromRGB(16, 185, 129)) -- Green
CreateColorSelector(Color3.fromRGB(245, 158, 11)) -- Orange
CreateColorSelector(Color3.fromRGB(168, 85, 247)) -- Purple
CreateColorSelector(Color3.fromRGB(255, 255, 255)) -- White

-- =================================================================
-- 5. ระบบ Loop รักษาสถานะตัวละคร
-- =================================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            if States.WalkSpeed ~= 16 then
                char.Humanoid.WalkSpeed = States.WalkSpeed
            end
        end
    end)
end)

-- เริ่มต้นเปิดหน้า Home เป็นค่าเริ่มต้น
SwitchTab("home")
