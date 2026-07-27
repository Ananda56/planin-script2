--[[
    ================================================================
    SABER / NINJA AUTOMATION SYSTEM (PROFESSIONAL EDITION)
    ================================================================
    Author  : Dev Framework
    Engine  : Luau (Roblox Studio / Executor Compatible)
    Version : 2.0.0
--]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------
-- CONFIGURATION & STATE MANAGEMENT
--------------------------------------------------------------------
local Settings = {
    AutoFarmEnabled = false,
    AttackInterval = 0.001, -- ความเร็วในการส่งสัญญาณ (วินาที)
    MultiHitsPerLoop = 3,  -- จำนวนครั้งที่ย่อส่ง Event ต่อรอบ
    EventName = "ninjaEvent"
}

--------------------------------------------------------------------
-- USER INTERFACE INITIALIZATION
--------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutomationFrameworkUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 300, 0, 180)
MainContainer.Position = UDim2.new(0.5, -150, 0.5, -90)
MainContainer.BackgroundColor3 = Color3.fromRGB(18, 22, 28)
MainContainer.BorderSizePixel = 0
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainContainer

local MainBorder = Instance.new("UIStroke")
MainBorder.Color = Color3.fromRGB(45, 55, 72)
MainBorder.Thickness = 1.5
MainBorder.Parent = MainContainer

-- Header Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -30, 0, 40)
TitleLabel.Position = UDim2.new(0, 15, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SYSTEM AUTOMATION"
TitleLabel.TextColor3 = Color3.fromRGB(240, 243, 246)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainContainer

-- Subtitle / Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -30, 0, 20)
StatusLabel.Position = UDim2.new(0, 15, 0, 38)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Standby"
StatusLabel.TextColor3 = Color3.fromRGB(120, 140, 160)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainContainer

-- Action Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, -30, 0, 45)
ToggleButton.Position = UDim2.new(0, 15, 1, -60)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
ToggleButton.Text = "START AUTOMATION"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = MainContainer

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleButton

--------------------------------------------------------------------
-- HELPER FUNCTIONS
--------------------------------------------------------------------
-- ค้นหา RemoteEvent อย่างปลอดภัย
local function GetTargetEvent()
    local character = LocalPlayer.Character
    local event = LocalPlayer:FindFirstChild(Settings.EventName)
    
    if not event and character then
        event = character:FindFirstChild(Settings.EventName)
    end
    
    return event
end

-- อัปเดตสไตล์ UI ด้วย Animation
local function UpdateUIState(isActive)
    local targetColor = isActive and Color3.fromRGB(225, 45, 75) or Color3.fromRGB(0, 122, 255)
    local targetText = isActive and "STOP AUTOMATION" or "START AUTOMATION"
    local statusText = isActive and "Status: Active (Running...)" or "Status: Standby"
    local statusColor = isActive and Color3.fromRGB(50, 215, 120) or Color3.fromRGB(120, 140, 160)

    TweenService:Create(ToggleButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = targetColor
    }):Play()

    ToggleButton.Text = targetText
    StatusLabel.Text = statusText
    StatusLabel.TextColor3 = statusColor
end

--------------------------------------------------------------------
-- CORE LOGIC (EXECUTION ENGINE)
--------------------------------------------------------------------
local function StartAutoFarmProcess()
    task.spawn(function()
        while Settings.AutoFarmEnabled do
            local remoteEvent = GetTargetEvent()
            
            if remoteEvent then
                -- ย้ำส่งสัญญาณตามจำนวน MultiHitsPerLoop เพื่อประสิทธิภาพสูงสุด
                for i = 1, Settings.MultiHitsPerLoop do
                    remoteEvent:FireServer("swingKatana")
                end
            end
            
            task.wait(Settings.AttackInterval)
        end
    end)
end

--------------------------------------------------------------------
-- EVENT LISTENERS
--------------------------------------------------------------------
ToggleButton.MouseButton1Click:Connect(function()
    Settings.AutoFarmEnabled = not Settings.AutoFarmEnabled
    UpdateUIState(Settings.AutoFarmEnabled)
    
    if Settings.AutoFarmEnabled then
        StartAutoFarmProcess()
    end
end)
