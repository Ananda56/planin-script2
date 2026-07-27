-- =================================================================
-- 🐟 Planin Hub - Advanced Gaming Intelligence (Roblox Native UI)
-- =================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local UI_COLORS = {
    Background = Color3.fromRGB(12, 12, 12),
    Panel = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(255, 0, 0), -- Default Accent
    Text = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(150, 150, 150)
}

local States = {
    AccentColor = UI_COLORS.Accent,
    WalkSpeed = 16,
    JumpPower = 50,
    GodMode = false,
    Invisibility = false
}

-- =================================================================
-- 1. สร้าง ScreenGui
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlaninHub_Advanced"
ScreenGui.ResetOnSpawn = false

local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- =================================================================
-- 2. สร้างโครงสร้างหลัก (Main Frame & Sidebar)
-- =================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 750, 0, 450)
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -225)
MainFrame.BackgroundColor3 = UI_COLORS.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "PLANIN HUB"
TitleText.TextColor3 = UI_COLORS.Text
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TopBar

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0, 150, 1, 0)
StatusText.Position = UDim2.new(1, -165, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "🟢 Live Status: Working"
StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 12
StatusText.TextXAlignment = Enum.TextXAlignment.Right
StatusText.Parent = TopBar

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = UI_COLORS.Panel
Sidebar.BackgroundTransparency = 0.5
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -160, 1, -40)
ContentContainer.Position = UDim2.new(0, 160, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- =================================================================
-- 3. ระบบ Tab Management
-- =================================================================
local Tabs = {}
local TabButtons = {}

local function SwitchTab(tabName)
    for name, frame in pairs(Tabs) do
        frame.Visible = (name == tabName)
    end
    for name, btn in pairs(TabButtons) do
        if name == tabName then
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.TextColor3 = States.AccentColor
        else
            btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            btn.BackgroundTransparency = 1
            btn.TextColor3 = UI_COLORS.Muted
        end
    end
end

local function CreateTabButton(name, yPos)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 35)
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.BackgroundTransparency = 1
    Btn.Text = name
    Btn.TextColor3 = UI_COLORS.Muted
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 13
    Btn.AutoButtonColor = false
    Btn.Parent = Sidebar
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
    
    TabButtons[name] = Btn
    return Btn
end

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -40, 1, -40)
    Page.Position = UDim2.new(0, 20, 0, 20)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 4
    Page.Visible = false
    Page.Parent = ContentContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 15)
    UIListLayout.Parent = Page
    
    Tabs[name] = Page
    return Page
end

-- =================================================================
-- 4. สร้างหน้า UI ตาม HTML (Home, Character, Settings)
-- =================================================================

-- สร้างปุ่ม Sidebar
CreateTabButton("Home", 20)
CreateTabButton("Character", 65)
CreateTabButton("Settings", 120)

-- [PAGE: Home]
local HomePage = CreatePage("Home")
local HomeTitle = Instance.new("TextLabel")
HomeTitle.Size = UDim2.new(1, 0, 0, 40)
HomeTitle.BackgroundTransparency = 1
HomeTitle.Text = "Home."
HomeTitle.TextColor3 = UI_COLORS.Text
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.TextSize = 32
HomeTitle.TextXAlignment = Enum.TextXAlignment.Left
HomeTitle.Parent = HomePage

local HomeDesc = HomeTitle:Clone()
HomeDesc.Size = UDim2.new(1, 0, 0, 20)
HomeDesc.Text = "Welcome back. Everything is synced and ready to perform."
HomeDesc.TextColor3 = UI_COLORS.Muted
HomeDesc.Font = Enum.Font.Gotham
HomeDesc.TextSize = 14
HomeDesc.Parent = HomePage

-- [PAGE: Character]
local CharPage = CreatePage("Character")
local CharTitle = HomeTitle:Clone()
CharTitle.Text = "Character."
CharTitle.Parent = CharPage

-- ฟังก์ชันสร้าง Input Panel (สำหรับ WalkSpeed / JumpPower)
local function CreateInputPanel(parent, title, defaultVal, callback)
    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(1, 0, 0, 60)
    Panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Panel.Parent = parent
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.TextColor3 = UI_COLORS.Text
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Panel
    
    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0, 80, 0, 30)
    Input.Position = UDim2.new(1, -100, 0.5, -15)
    Input.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Input.TextColor3 = UI_COLORS.Text
    Input.Text = tostring(defaultVal)
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 14
    Input.Parent = Panel
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)
    
    Input.FocusLost:Connect(function()
        local val = tonumber(Input.Text)
        if val then callback(val) else Input.Text = tostring(defaultVal) end
    end)
end

-- ฟังก์ชันสร้าง Toggle Panel (สำหรับ God Mode / Invisibility)
local function CreateTogglePanel(parent, title, callback)
    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(1, 0, 0, 50)
    Panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Panel.Parent = parent
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.TextColor3 = UI_COLORS.Text
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Panel
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -55, 0.5, -10)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Panel
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.Position = UDim2.new(0, 2, 0.5, -8)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Indicator.Parent = ToggleBtn
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    
    local toggled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        callback(toggled)
        local goal = {}
        if toggled then
            goal.Position = UDim2.new(1, -18, 0.5, -8)
            ToggleBtn.BackgroundColor3 = States.AccentColor
        else
            goal.Position = UDim2.new(0, 2, 0.5, -8)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        TweenService:Create(Indicator, TweenInfo.new(0.2), goal):Play()
    end)
end

-- เพิ่มระบบลงใน Character Tab
CreateInputPanel(CharPage, "Walk Speed", 16, function(val)
    States.WalkSpeed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

CreateInputPanel(CharPage, "Jump Power", 50, function(val)
    States.JumpPower = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

CreateTogglePanel(CharPage, "Invisibility (Client)", function(val)
    States.Invisibility = val
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if val then
                    if not part:GetAttribute("OrigTrans") then part:SetAttribute("OrigTrans", part.Transparency) end
                    part.Transparency = 1
                else
                    if part:GetAttribute("OrigTrans") then part.Transparency = part:GetAttribute("OrigTrans") end
                end
            end
        end
    end
end)

-- [PAGE: Settings]
local SettingsPage = CreatePage("Settings")
local SettingsTitle = HomeTitle:Clone()
SettingsTitle.Text = "Settings."
SettingsTitle.Parent = SettingsPage

local SettingsDesc = HomeDesc:Clone()
SettingsDesc.Text = "Customize the look and feel of your Planin Hub experience."
SettingsDesc.Parent = SettingsPage

local function CreateColorButton(parent, color)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 30, 0, 30)
    Btn.BackgroundColor3 = color
    Btn.Text = ""
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", Btn).Color = Color3.fromRGB(255, 255, 255)
    
    Btn.MouseButton1Click:Connect(function()
        States.AccentColor = color
        -- อัปเดตสีทั้ง UI
        SwitchTab("Settings") -- รีเฟรชปุ่ม Sidebar
        HomeTitle.TextColor3 = color
        CharTitle.TextColor3 = color
        SettingsTitle.TextColor3 = color
    end)
end

local ColorPanel = Instance.new("Frame")
ColorPanel.Size = UDim2.new(1, 0, 0, 60)
ColorPanel.BackgroundTransparency = 1
ColorPanel.Parent = SettingsPage

local ColorLayout = Instance.new("UIListLayout")
ColorLayout.FillDirection = Enum.FillDirection.Horizontal
ColorLayout.Padding = UDim.new(0, 10)
ColorLayout.Parent = ColorPanel

CreateColorButton(ColorPanel, Color3.fromRGB(255, 0, 0))    -- Red
CreateColorButton(ColorPanel, Color3.fromRGB(59, 130, 246)) -- Blue
CreateColorButton(ColorPanel, Color3.fromRGB(16, 185, 129)) -- Green
CreateColorButton(ColorPanel, Color3.fromRGB(245, 158, 11)) -- Orange
CreateColorButton(ColorPanel, Color3.fromRGB(168, 85, 247)) -- Purple

-- =================================================================
-- 5. ระบบ Loop Update (บังคับค่าต่างๆ ให้เสถียร)
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

-- Initialize
SwitchTab("Home")
