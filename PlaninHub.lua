-- =================================================================
-- 🐟 PlaninHub - Speed, Fly & Invisible
-- UI Library: Rayfield (Modern Dark Theme)
-- =================================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ตัวแปรควบคุมระบบ
local States = {
    WalkSpeedEnabled = false,
    WalkSpeed = 16,
    FlyEnabled = false,
    FlySpeed = 50,
    Invisible = false
}

-- =================================================================
-- 1. สร้างปุ่มลอยสำหรับ เปิด/ปิด UI (Toggle Button)
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlaninHubToggle"
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

local ToggleUIBtn = Instance.new("TextButton")
ToggleUIBtn.Size = UDim2.new(0, 120, 0, 40)
ToggleUIBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ToggleUIBtn.Text = "PlaninHub"
ToggleUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUIBtn.Font = Enum.Font.GothamBold
ToggleUIBtn.TextSize = 14
ToggleUIBtn.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleUIBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(150, 100, 255)
UIStroke.Thickness = 2
UIStroke.Parent = ToggleUIBtn

-- ระบบซ่อน/แสดง หน้าต่าง Rayfield
local UIVisible = true
ToggleUIBtn.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    -- Rayfield ไม่มีฟังก์ชัน Toggle แบบตรงๆ แต่ใช้การกดปุ่ม RightControl เป็นค่าเริ่มต้น
    -- เราจึงจำลองการกดปุ่มเพื่อเปิด/ปิดหน้าต่าง
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
end)

-- =================================================================
-- 2. สร้างหน้าต่างหลัก (Main Window)
-- =================================================================
local Window = Rayfield:CreateWindow({
    Name = "PlaninHub",
    LoadingTitle = "กำลังโหลดสคริปต์...",
    LoadingSubtitle = "ความเร็ว, บิน, ล่องหน",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- สร้างแถบเมนู (Tabs)
local MainTab = Window:CreateTab("เมนูหลัก", "home")
local PlayerTab = Window:CreateTab("ตัวละคร", "user")

-- =================================================================
-- 3. ระบบวิ่งเร็ว (WalkSpeed)
-- =================================================================
MainTab:CreateSection("ตั้งค่าความเร็ว (WalkSpeed)")

MainTab:CreateToggle({
    Name = "เปิดใช้งาน วิ่งเร็ว",
    CurrentValue = false,
    Flag = "ToggleWalkSpeed",
    Callback = function(Value)
        States.WalkSpeedEnabled = Value
    end,
})

MainTab:CreateSlider({
    Name = "ระดับความเร็ว",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "SliderWalkSpeed",
    Callback = function(Value)
        States.WalkSpeed = Value
    end,
})

-- ลูปบังคับความเร็ว (ป้องกันเกมรีเซ็ตค่า)
RunService.RenderStepped:Connect(function()
    if States.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = States.WalkSpeed
    end
end)

-- =================================================================
-- 4. ระบบบิน (Fly System)
-- =================================================================
MainTab:CreateSection("ตั้งค่าการบิน (Fly)")

local FlyBodyVelocity = nil
local FlyBodyGyro = nil

MainTab:CreateToggle({
    Name = "เปิดใช้งาน บิน",
    CurrentValue = false,
    Flag = "ToggleFly",
    Callback = function(Value)
        States.FlyEnabled = Value
        local char = LocalPlayer.Character
        
        if States.FlyEnabled and char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            
            FlyBodyVelocity = Instance.new("BodyVelocity")
            FlyBodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            FlyBodyVelocity.Velocity = Vector3.zero
            FlyBodyVelocity.Parent = hrp
            
            FlyBodyGyro = Instance.new("BodyGyro")
            FlyBodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
            FlyBodyGyro.P = 10000
            FlyBodyGyro.CFrame = hrp.CFrame
            FlyBodyGyro.Parent = hrp
            
            char.Humanoid.PlatformStand = true
        else
            if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
            if FlyBodyGyro then FlyBodyGyro:Destroy() end
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = false
            end
        end
    end,
})

MainTab:CreateSlider({
    Name = "ความเร็วการบิน",
    Range = {10, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "SliderFlySpeed",
    Callback = function(Value)
        States.FlySpeed = Value
    end,
})

-- ลูปควบคุมทิศทางการบินตามมุมกล้อง
RunService.RenderStepped:Connect(function()
    if States.FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
        
        if FlyBodyVelocity and FlyBodyGyro then
            FlyBodyGyro.CFrame = camera.CFrame
            if moveDir.Magnitude > 0 then
                FlyBodyVelocity.Velocity = camera.CFrame.LookVector * (moveDir.Z * -States.FlySpeed) 
                                         + camera.CFrame.RightVector * (moveDir.X * States.FlySpeed)
            else
                FlyBodyVelocity.Velocity = Vector3.zero
            end
        end
    end
end)

-- =================================================================
-- 5. ระบบล่องหน (Local Invisibility)
-- =================================================================
PlayerTab:CreateSection("สถานะอวตาร (Avatar Status)")

PlayerTab:CreateToggle({
    Name = "เปิดใช้งาน ล่องหน (Client-Side)",
    CurrentValue = false,
    Flag = "ToggleInvisible",
    Callback = function(Value)
        States.Invisible = Value
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    if States.Invisible then
                        -- เก็บค่าโปร่งใสเดิมไว้ (ถ้ายังไม่มี)
                        if not part:GetAttribute("OriginalTransparency") then
                            part:SetAttribute("OriginalTransparency", part.Transparency)
                        end
                        part.Transparency = 1
                    else
                        -- คืนค่าโปร่งใสเดิม
                        if part:GetAttribute("OriginalTransparency") then
                            part.Transparency = part:GetAttribute("OriginalTransparency")
                        end
                    end
                elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                    if States.Invisible then
                        part.Handle.Transparency = 1
                    else
                        part.Handle.Transparency = 0
                    end
                end
            end
        end
    end,
})

-- แจ้งเตือนเสร็จสิ้น
Rayfield:Notify({
    Title = "พร้อมใช้งาน!",
    Content = "PlaninHub โหลดสำเร็จแล้ว ขอให้สนุกครับ",
    Duration = 5,
    Image = 4483362458,
})
