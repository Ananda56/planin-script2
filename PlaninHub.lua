-- =================================================================
-- 🚀 HIGH-PERFORMANCE AUTO FARM GUI (ULTIMATE VERSION)
-- =================================================================

-- 1. Create UI Elements (Glassmorphism & Neon Design)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local BtnCorner = Instance.new("UICorner")
local BtnStroke = Instance.new("UIStroke")
local StatusLabel = Instance.new("TextLabel")

-- Parent ScreenGui
ScreenGui.Name = "NinjaCyberHUD"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Card Frame (Glassmorphism Effect)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
MainFrame.BackgroundTransparency = 0.25 -- กระจกฝ้า
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true -- ลากลานหน้าจอได้

UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

-- Neon Cyber Border
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 242, 254)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.3

-- Title Label
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0.08, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "NINJA AUTO FARM VIP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- Status Label
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.28, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "สถานะ: 🔴 ปิดใช้งาน"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 12

-- Modern Cyber Button
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 45)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "⚡ เปิดใช้งาน AUTO FARM"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.AutoButtonColor = false

BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleBtn

BtnStroke.Parent = ToggleBtn
BtnStroke.Color = Color3.fromRGB(0, 242, 254)
BtnStroke.Thickness = 1.5

-- =================================================================
-- ⚡ LOGIC & HIGH-SPEED REMOTE AUTO FARM
-- =================================================================

local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local IsFarming = false

-- JS-Style Hover & Click Animations (Tweening)
local function animateButton(color, scale)
	TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
	TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = scale}):Play()
end

ToggleBtn.MouseEnter:Connect(function()
	if not IsFarming then
		TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
	end
end)

ToggleBtn.MouseLeave:Connect(function()
	if not IsFarming then
		TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
	end
end)

-- Toggle Switch Logic
ToggleBtn.MouseButton1Click:Connect(function()
	IsFarming = not IsFarming
	
	if IsFarming then
		-- เปลี่ยนเป็นสีแดง / Active State
		animateButton(Color3.fromRGB(255, 50, 80), UDim2.new(0, 255, 0, 205))
		ToggleBtn.Text = "🔴 กำลังฟาร์มรัวๆ (ACTIVE)"
		StatusLabel.Text = "สถานะ: 🟢 ฟาร์มอัตโนมัติทำงานอยู่"
		StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
		BtnStroke.Color = Color3.fromRGB(255, 50, 80)
		
		-- Loop ส่ง Remote Event แบบ Ultra Fast
		task.spawn(function()
			while IsFarming do
				-- ค้นหา ninjaEvent ทั้งในตัวผู้เล่นและตัวละครเพื่อป้องกันการหาไม่เจอ
				local character = Player.Character
				local ninjaEvent = Player:FindFirstChild("ninjaEvent") or (character and character:FindFirstChild("ninjaEvent"))
				
				if ninjaEvent then
					-- ย้ำส่งสัญญาณ 3 รอบใน 1 Loop (Turbo Fire)
					ninjaEvent:FireServer("swingKatana")
					ninjaEvent:FireServer("swingKatana")
					ninjaEvent:FireServer("swingKatana")
				end
				
				-- ใช้ task.wait ระดับ MS ที่เร็วและเสถียรที่สุด ไม่ทำให้เกมค้าง
				task.wait(0.001)
			end
		end)
	else
		-- คืนค่ากลับเป็นสีฟ้า / Normal State
		animateButton(Color3.fromRGB(0, 150, 255), UDim2.new(0, 250, 0, 200))
		ToggleBtn.Text = "⚡ เปิดใช้งาน AUTO FARM"
		StatusLabel.Text = "สถานะ: 🔴 ปิดใช้งาน"
		StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
		BtnStroke.Color = Color3.fromRGB(0, 242, 254)
	end
end)
