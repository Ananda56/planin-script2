-- PlaninHub UI Script
-- วางใน LocalScript (เช่น StarterGui หรือ Executor)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- ===================== CONFIG =====================
local REMOTE_NAME = "ninjaEvent" -- ชื่อ RemoteEvent
local DEFAULT_FARM_SPEED = 0.05  -- วินาที (ยิ่งน้อยยิ่งเร็ว)
local DEFAULT_WALKSPEED = 16
-- ==================================================

-- สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")-- PlaninHub UI Script
-- วางใน LocalScript (เช่น StarterGui หรือ Executor)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- ===================== CONFIG =====================
local REMOTE_NAME = "ninjaEvent" -- ชื่อ RemoteEvent
local DEFAULT_FARM_SPEED = 0.05  -- วินาที (ยิ่งน้อยยิ่งเร็ว)
local DEFAULT_WALKSPEED = 16
-- ==================================================

-- สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlaninHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 420, 0, 320)
Main.Position = UDim2.new(0.5, -210, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(45, 45, 55)
UIStroke.Thickness = 1.5
UIStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PlaninHub  |  Version: 1.0.0"
Title.TextColor3 = Color3.fromRGB(220, 220, 230)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = Sidebar

local SideFix = Instance.new("Frame")
SideFix.Size = UDim2.new(0, 15, 1, 0)
SideFix.Position = UDim2.new(1, -15, 0, 0)
SideFix.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
SideFix.BorderSizePixel = 0
SideFix.Parent = Sidebar

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -120, 1, -50)
Content.Position = UDim2.new(0, 115, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- ฟังก์ชันสร้างปุ่มหมวดหมู่
local function createTabButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, -16, 0, 34)
	btn.Position = UDim2.new(0, 8, 0, 12 + (order - 1) * 42)
	btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(180, 180, 200)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.Parent = Sidebar

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 7)
	corner.Parent = btn

	return btn
end

local FarmTabBtn = createTabButton("ระบบฟาร์ม", 1)
local PlayerTabBtn = createTabButton("ระบบผู้เล่น", 2)

-- ===================== ระบบฟาร์ม =====================
local FarmPage = Instance.new("Frame")
FarmPage.Name = "FarmPage"
FarmPage.Size = UDim2.new(1, 0, 1, 0)
FarmPage.BackgroundTransparency = 1
FarmPage.Visible = true
FarmPage.Parent = Content

local FarmTitle = Instance.new("TextLabel")
FarmTitle.Size = UDim2.new(1, 0, 0, 25)
FarmTitle.BackgroundTransparency = 1
FarmTitle.Text = "Auto Farm  (ninjaEvent)"
FarmTitle.TextColor3 = Color3.fromRGB(200, 200, 220)
FarmTitle.Font = Enum.Font.GothamBold
FarmTitle.TextSize = 15
FarmTitle.TextXAlignment = Enum.TextXAlignment.Left
FarmTitle.Parent = FarmPage

-- Toggle Auto Farm
local AutoFarmToggle = Instance.new("TextButton")
AutoFarmToggle.Size = UDim2.new(0, 160, 0, 32)
AutoFarmToggle.Position = UDim2.new(0, 0, 0, 40)
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
AutoFarmToggle.Text = "Auto Farm: OFF"
AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
AutoFarmToggle.Font = Enum.Font.GothamMedium
AutoFarmToggle.TextSize = 13
AutoFarmToggle.Parent = FarmPage

local AFCorner = Instance.new("UICorner")
AFCorner.CornerRadius = UDim.new(0, 7)
AFCorner.Parent = AutoFarmToggle

-- Speed Label + Slider แบบง่าย
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 22)
SpeedLabel.Position = UDim2.new(0, 0, 0, 90)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "ความเร็วการย้ำ: 0.05 วินาที"
SpeedLabel.TextColor3 = Color3.fromRGB(170, 170, 190)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = FarmPage

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0, 100, 0, 30)
SpeedBox.Position = UDim2.new(0, 0, 0, 118)
SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
SpeedBox.Text = "0.05"
SpeedBox.TextColor3 = Color3.fromRGB(220, 220, 240)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.PlaceholderText = "0.01 - 1"
SpeedBox.Parent = FarmPage

local SBCorner = Instance.new("UICorner")
SBCorner.CornerRadius = UDim.new(0, 6)
SBCorner.Parent = SpeedBox

local SpeedNote = Instance.new("TextLabel")
SpeedNote.Size = UDim2.new(1, 0, 0, 40)
SpeedNote.Position = UDim2.new(0, 0, 0, 160)
SpeedNote.BackgroundTransparency = 1
SpeedNote.Text = "ยิ่งเลขน้อย = ยิ่งเร็ว\nแนะนำ 0.03 ~ 0.08 (ขึ้นอยู่กับเกม)"
SpeedNote.TextColor3 = Color3.fromRGB(140, 140, 160)
SpeedNote.Font = Enum.Font.Gotham
SpeedNote.TextSize = 12
SpeedNote.TextXAlignment = Enum.TextXAlignment.Left
SpeedNote.TextYAlignment = Enum.TextYAlignment.Top
SpeedNote.Parent = FarmPage

-- ===================== ระบบผู้เล่น =====================
local PlayerPage = Instance.new("Frame")
PlayerPage.Name = "PlayerPage"
PlayerPage.Size = UDim2.new(1, 0, 1, 0)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Visible = false
PlayerPage.Parent = Content

local PlayerTitle = Instance.new("TextLabel")
PlayerTitle.Size = UDim2.new(1, 0, 0, 25)
PlayerTitle.BackgroundTransparency = 1
PlayerTitle.Text = "ระบบผู้เล่น"
PlayerTitle.TextColor3 = Color3.fromRGB(200, 200, 220)
PlayerTitle.Font = Enum.Font.GothamBold
PlayerTitle.TextSize = 15
PlayerTitle.TextXAlignment = Enum.TextXAlignment.Left
PlayerTitle.Parent = PlayerPage

-- Invisible Toggle
local InvisToggle = Instance.new("TextButton")
InvisToggle.Size = UDim2.new(0, 160, 0, 32)
InvisToggle.Position = UDim2.new(0, 0, 0, 40)
InvisToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
InvisToggle.Text = "ล่องหน: OFF"
InvisToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
InvisToggle.Font = Enum.Font.GothamMedium
InvisToggle.TextSize = 13
InvisToggle.Parent = PlayerPage

local InvisCorner = Instance.new("UICorner")
InvisCorner.CornerRadius = UDim.new(0, 7)
InvisCorner.Parent = InvisToggle

-- WalkSpeed
local SpeedLabel2 = Instance.new("TextLabel")
SpeedLabel2.Size = UDim2.new(1, 0, 0, 22)
SpeedLabel2.Position = UDim2.new(0, 0, 0, 90)
SpeedLabel2.BackgroundTransparency = 1
SpeedLabel2.Text = "ความเร็วตัวละคร (WalkSpeed)"
SpeedLabel2.TextColor3 = Color3.fromRGB(170, 170, 190)
SpeedLabel2.Font = Enum.Font.Gotham
SpeedLabel2.TextSize = 13
SpeedLabel2.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel2.Parent = PlayerPage

local WalkSpeedBox = Instance.new("TextBox")
WalkSpeedBox.Size = UDim2.new(0, 100, 0, 30)
WalkSpeedBox.Position = UDim2.new(0, 0, 0, 118)
WalkSpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
WalkSpeedBox.Text = "16"
WalkSpeedBox.TextColor3 = Color3.fromRGB(220, 220, 240)
WalkSpeedBox.Font = Enum.Font.Gotham
WalkSpeedBox.TextSize = 14
WalkSpeedBox.Parent = PlayerPage

local WSCorner = Instance.new("UICorner")
WSCorner.CornerRadius = UDim.new(0, 6)
WSCorner.Parent = WalkSpeedBox

local ApplySpeedBtn = Instance.new("TextButton")
ApplySpeedBtn.Size = UDim2.new(0, 90, 0, 30)
ApplySpeedBtn.Position = UDim2.new(0, 110, 0, 118)
ApplySpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 90, 160)
ApplySpeedBtn.Text = "Apply"
ApplySpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplySpeedBtn.Font = Enum.Font.GothamMedium
ApplySpeedBtn.TextSize = 13
ApplySpeedBtn.Parent = PlayerPage

local ApplyCorner = Instance.new("UICorner")
ApplyCorner.CornerRadius = UDim.new(0, 6)
ApplyCorner.Parent = ApplySpeedBtn

-- ===================== LOGIC =====================
local autoFarm = false
local farmSpeed = DEFAULT_FARM_SPEED
local invisOn = false
local farmConnection = nil

-- หา Remote
local function getRemote()
	local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
	if not remote then
		-- ลองหาในที่อื่น ๆ (ปรับตามเกมจริง)
		for _, v in pairs(ReplicatedStorage:GetDescendants()) do
			if v.Name == REMOTE_NAME and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
				return v
			end
		end
	end
	return remote
end

-- Auto Farm Loop
local function startFarm()
	if farmConnection then farmConnection:Disconnect() end
	farmConnection = RunService.Heartbeat:Connect(function()
		if not autoFarm then return end
		local remote = getRemote()
		if remote and remote:IsA("RemoteEvent") then
			pcall(function()
				remote:FireServer() -- ปรับ argument ตามเกมจริงได้
			end)
		end
		task.wait(farmSpeed)
	end)
end

-- Toggle Auto Farm
AutoFarmToggle.MouseButton1Click:Connect(function()
	autoFarm = not autoFarm
	if autoFarm then
		AutoFarmToggle.Text = "Auto Farm: ON"
		AutoFarmToggle.TextColor3 = Color3.fromRGB(100, 255, 130)
		AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(30, 60, 40)
		startFarm()
	else
		AutoFarmToggle.Text = "Auto Farm: OFF"
		AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
		AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
		if farmConnection then
			farmConnection:Disconnect()
			farmConnection = nil
		end
	end
end)

-- เปลี่ยนความเร็วฟาร์ม
SpeedBox.FocusLost:Connect(function()
	local num = tonumber(SpeedBox.Text)
	if num and num > 0 then
		farmSpeed = math.clamp(num, 0.01, 2)
		SpeedBox.Text = tostring(farmSpeed)
		SpeedLabel.Text = "ความเร็วการย้ำ: " .. farmSpeed .. " วินาที"
	else
		SpeedBox.Text = tostring(farmSpeed)
	end
end)

-- ล่องหน
InvisToggle.MouseButton1Click:Connect(function()
	invisOn = not invisOn
	character = player.Character or player.CharacterAdded:Wait()
	
	if invisOn then
		InvisToggle.Text = "ล่องหน: ON"
		InvisToggle.TextColor3 = Color3.fromRGB(100, 255, 130)
		InvisToggle.BackgroundColor3 = Color3.fromRGB(30, 60, 40)
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				part.Transparency = 1
			end
		end
	else
		InvisToggle.Text = "ล่องหน: OFF"
		InvisToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
		InvisToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				part.Transparency = 0
			elseif part:IsA("Decal") then
				part.Transparency = 0
			end
		end
	end
end)

-- Apply WalkSpeed
ApplySpeedBtn.MouseButton1Click:Connect(function()
	local num = tonumber(WalkSpeedBox.Text)
	if num and num > 0 then
		humanoid = (player.Character or player.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = num
		end
	end
end)

-- สลับหน้า
local function switchTab(page)
	FarmPage.Visible = (page == "Farm")
	PlayerPage.Visible = (page == "Player")
	
	FarmTabBtn.BackgroundColor3 = (page == "Farm") and Color3.fromRGB(50, 70, 120) or Color3.fromRGB(32, 32, 40)
	FarmTabBtn.TextColor3 = (page == "Farm") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 200)
	
	PlayerTabBtn.BackgroundColor3 = (page == "Player") and Color3.fromRGB(50, 70, 120) or Color3.fromRGB(32, 32, 40)
	PlayerTabBtn.TextColor3 = (page == "Player") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 200)
end

FarmTabBtn.MouseButton1Click:Connect(function() switchTab("Farm") end)
PlayerTabBtn.MouseButton1Click:Connect(function() switchTab("Player") end)

-- ปิดหน้าต่าง
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

-- เปิด/ปิดด้วยปุ่ม RightControl
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)

-- อัปเดต character เมื่อตาย/เกิดใหม่
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	if invisOn then
		task.wait(0.5)
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				part.Transparency = 1
			end
		end
	end
end)

print("PlaninHub loaded! กด RightControl เพื่อเปิด/ปิด UI")
ScreenGui.Name = "PlaninHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 420, 0, 320)
Main.Position = UDim2.new(0.5, -210, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(45, 45, 55)
UIStroke.Thickness = 1.5
UIStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PlaninHub  |  Version: 1.0.0"
Title.TextColor3 = Color3.fromRGB(220, 220, 230)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = Sidebar

local SideFix = Instance.new("Frame")
SideFix.Size = UDim2.new(0, 15, 1, 0)
SideFix.Position = UDim2.new(1, -15, 0, 0)
SideFix.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
SideFix.BorderSizePixel = 0
SideFix.Parent = Sidebar

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -120, 1, -50)
Content.Position = UDim2.new(0, 115, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- ฟังก์ชันสร้างปุ่มหมวดหมู่
local function createTabButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, -16, 0, 34)
	btn.Position = UDim2.new(0, 8, 0, 12 + (order - 1) * 42)
	btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(180, 180, 200)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.Parent = Sidebar

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 7)
	corner.Parent = btn

	return btn
end

local FarmTabBtn = createTabButton("ระบบฟาร์ม", 1)
local PlayerTabBtn = createTabButton("ระบบผู้เล่น", 2)

-- ===================== ระบบฟาร์ม =====================
local FarmPage = Instance.new("Frame")
FarmPage.Name = "FarmPage"
FarmPage.Size = UDim2.new(1, 0, 1, 0)
FarmPage.BackgroundTransparency = 1
FarmPage.Visible = true
FarmPage.Parent = Content

local FarmTitle = Instance.new("TextLabel")
FarmTitle.Size = UDim2.new(1, 0, 0, 25)
FarmTitle.BackgroundTransparency = 1
FarmTitle.Text = "Auto Farm  (ninjaEvent)"
FarmTitle.TextColor3 = Color3.fromRGB(200, 200, 220)
FarmTitle.Font = Enum.Font.GothamBold
FarmTitle.TextSize = 15
FarmTitle.TextXAlignment = Enum.TextXAlignment.Left
FarmTitle.Parent = FarmPage

-- Toggle Auto Farm
local AutoFarmToggle = Instance.new("TextButton")
AutoFarmToggle.Size = UDim2.new(0, 160, 0, 32)
AutoFarmToggle.Position = UDim2.new(0, 0, 0, 40)
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
AutoFarmToggle.Text = "Auto Farm: OFF"
AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
AutoFarmToggle.Font = Enum.Font.GothamMedium
AutoFarmToggle.TextSize = 13
AutoFarmToggle.Parent = FarmPage

local AFCorner = Instance.new("UICorner")
AFCorner.CornerRadius = UDim.new(0, 7)
AFCorner.Parent = AutoFarmToggle

-- Speed Label + Slider แบบง่าย
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 22)
SpeedLabel.Position = UDim2.new(0, 0, 0, 90)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "ความเร็วการย้ำ: 0.05 วินาที"
SpeedLabel.TextColor3 = Color3.fromRGB(170, 170, 190)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = FarmPage

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0, 100, 0, 30)
SpeedBox.Position = UDim2.new(0, 0, 0, 118)
SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
SpeedBox.Text = "0.05"
SpeedBox.TextColor3 = Color3.fromRGB(220, 220, 240)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.PlaceholderText = "0.01 - 1"
SpeedBox.Parent = FarmPage

local SBCorner = Instance.new("UICorner")
SBCorner.CornerRadius = UDim.new(0, 6)
SBCorner.Parent = SpeedBox

local SpeedNote = Instance.new("TextLabel")
SpeedNote.Size = UDim2.new(1, 0, 0, 40)
SpeedNote.Position = UDim2.new(0, 0, 0, 160)
SpeedNote.BackgroundTransparency = 1
SpeedNote.Text = "ยิ่งเลขน้อย = ยิ่งเร็ว\nแนะนำ 0.03 ~ 0.08 (ขึ้นอยู่กับเกม)"
SpeedNote.TextColor3 = Color3.fromRGB(140, 140, 160)
SpeedNote.Font = Enum.Font.Gotham
SpeedNote.TextSize = 12
SpeedNote.TextXAlignment = Enum.TextXAlignment.Left
SpeedNote.TextYAlignment = Enum.TextYAlignment.Top
SpeedNote.Parent = FarmPage

-- ===================== ระบบผู้เล่น =====================
local PlayerPage = Instance.new("Frame")
PlayerPage.Name = "PlayerPage"
PlayerPage.Size = UDim2.new(1, 0, 1, 0)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Visible = false
PlayerPage.Parent = Content

local PlayerTitle = Instance.new("TextLabel")
PlayerTitle.Size = UDim2.new(1, 0, 0, 25)
PlayerTitle.BackgroundTransparency = 1
PlayerTitle.Text = "ระบบผู้เล่น"
PlayerTitle.TextColor3 = Color3.fromRGB(200, 200, 220)
PlayerTitle.Font = Enum.Font.GothamBold
PlayerTitle.TextSize = 15
PlayerTitle.TextXAlignment = Enum.TextXAlignment.Left
PlayerTitle.Parent = PlayerPage

-- Invisible Toggle
local InvisToggle = Instance.new("TextButton")
InvisToggle.Size = UDim2.new(0, 160, 0, 32)
InvisToggle.Position = UDim2.new(0, 0, 0, 40)
InvisToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
InvisToggle.Text = "ล่องหน: OFF"
InvisToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
InvisToggle.Font = Enum.Font.GothamMedium
InvisToggle.TextSize = 13
InvisToggle.Parent = PlayerPage

local InvisCorner = Instance.new("UICorner")
InvisCorner.CornerRadius = UDim.new(0, 7)
InvisCorner.Parent = InvisToggle

-- WalkSpeed
local SpeedLabel2 = Instance.new("TextLabel")
SpeedLabel2.Size = UDim2.new(1, 0, 0, 22)
SpeedLabel2.Position = UDim2.new(0, 0, 0, 90)
SpeedLabel2.BackgroundTransparency = 1
SpeedLabel2.Text = "ความเร็วตัวละคร (WalkSpeed)"
SpeedLabel2.TextColor3 = Color3.fromRGB(170, 170, 190)
SpeedLabel2.Font = Enum.Font.Gotham
SpeedLabel2.TextSize = 13
SpeedLabel2.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel2.Parent = PlayerPage

local WalkSpeedBox = Instance.new("TextBox")
WalkSpeedBox.Size = UDim2.new(0, 100, 0, 30)
WalkSpeedBox.Position = UDim2.new(0, 0, 0, 118)
WalkSpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
WalkSpeedBox.Text = "16"
WalkSpeedBox.TextColor3 = Color3.fromRGB(220, 220, 240)
WalkSpeedBox.Font = Enum.Font.Gotham
WalkSpeedBox.TextSize = 14
WalkSpeedBox.Parent = PlayerPage

local WSCorner = Instance.new("UICorner")
WSCorner.CornerRadius = UDim.new(0, 6)
WSCorner.Parent = WalkSpeedBox

local ApplySpeedBtn = Instance.new("TextButton")
ApplySpeedBtn.Size = UDim2.new(0, 90, 0, 30)
ApplySpeedBtn.Position = UDim2.new(0, 110, 0, 118)
ApplySpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 90, 160)
ApplySpeedBtn.Text = "Apply"
ApplySpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplySpeedBtn.Font = Enum.Font.GothamMedium
ApplySpeedBtn.TextSize = 13
ApplySpeedBtn.Parent = PlayerPage

local ApplyCorner = Instance.new("UICorner")
ApplyCorner.CornerRadius = UDim.new(0, 6)
ApplyCorner.Parent = ApplySpeedBtn

-- ===================== LOGIC =====================
local autoFarm = false
local farmSpeed = DEFAULT_FARM_SPEED
local invisOn = false
local farmConnection = nil

-- หา Remote
local function getRemote()
	local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
	if not remote then
		-- ลองหาในที่อื่น ๆ (ปรับตามเกมจริง)
		for _, v in pairs(ReplicatedStorage:GetDescendants()) do
			if v.Name == REMOTE_NAME and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
				return v
			end
		end
	end
	return remote
end

-- Auto Farm Loop
local function startFarm()
	if farmConnection then farmConnection:Disconnect() end
	farmConnection = RunService.Heartbeat:Connect(function()
		if not autoFarm then return end
		local remote = getRemote()
		if remote and remote:IsA("RemoteEvent") then
			pcall(function()
				remote:FireServer() -- ปรับ argument ตามเกมจริงได้
			end)
		end
		task.wait(farmSpeed)
	end)
end

-- Toggle Auto Farm
AutoFarmToggle.MouseButton1Click:Connect(function()
	autoFarm = not autoFarm
	if autoFarm then
		AutoFarmToggle.Text = "Auto Farm: ON"
		AutoFarmToggle.TextColor3 = Color3.fromRGB(100, 255, 130)
		AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(30, 60, 40)
		startFarm()
	else
		AutoFarmToggle.Text = "Auto Farm: OFF"
		AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
		AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
		if farmConnection then
			farmConnection:Disconnect()
			farmConnection = nil
		end
	end
end)

-- เปลี่ยนความเร็วฟาร์ม
SpeedBox.FocusLost:Connect(function()
	local num = tonumber(SpeedBox.Text)
	if num and num > 0 then
		farmSpeed = math.clamp(num, 0.01, 2)
		SpeedBox.Text = tostring(farmSpeed)
		SpeedLabel.Text = "ความเร็วการย้ำ: " .. farmSpeed .. " วินาที"
	else
		SpeedBox.Text = tostring(farmSpeed)
	end
end)

-- ล่องหน
InvisToggle.MouseButton1Click:Connect(function()
	invisOn = not invisOn
	character = player.Character or player.CharacterAdded:Wait()
	
	if invisOn then
		InvisToggle.Text = "ล่องหน: ON"
		InvisToggle.TextColor3 = Color3.fromRGB(100, 255, 130)
		InvisToggle.BackgroundColor3 = Color3.fromRGB(30, 60, 40)
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				part.Transparency = 1
			end
		end
	else
		InvisToggle.Text = "ล่องหน: OFF"
		InvisToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
		InvisToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				part.Transparency = 0
			elseif part:IsA("Decal") then
				part.Transparency = 0
			end
		end
	end
end)

-- Apply WalkSpeed
ApplySpeedBtn.MouseButton1Click:Connect(function()
	local num = tonumber(WalkSpeedBox.Text)
	if num and num > 0 then
		humanoid = (player.Character or player.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = num
		end
	end
end)

-- สลับหน้า
local function switchTab(page)
	FarmPage.Visible = (page == "Farm")
	PlayerPage.Visible = (page == "Player")
	
	FarmTabBtn.BackgroundColor3 = (page == "Farm") and Color3.fromRGB(50, 70, 120) or Color3.fromRGB(32, 32, 40)
	FarmTabBtn.TextColor3 = (page == "Farm") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 200)
	
	PlayerTabBtn.BackgroundColor3 = (page == "Player") and Color3.fromRGB(50, 70, 120) or Color3.fromRGB(32, 32, 40)
	PlayerTabBtn.TextColor3 = (page == "Player") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 200)
end

FarmTabBtn.MouseButton1Click:Connect(function() switchTab("Farm") end)
PlayerTabBtn.MouseButton1Click:Connect(function() switchTab("Player") end)

-- ปิดหน้าต่าง
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

-- เปิด/ปิดด้วยปุ่ม RightControl
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)

-- อัปเดต character เมื่อตาย/เกิดใหม่
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	if invisOn then
		task.wait(0.5)
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				part.Transparency = 1
			end
		end
	end
end)

print("PlaninHub loaded! กด RightControl เพื่อเปิด/ปิด UI")
