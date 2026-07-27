-- =================================================================
-- 🐟 PlaninHub - FIXED VERSION (Safe Mode)
-- =================================================================

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("ไม่สามารถโหลด Rayfield UI ได้ โปรดตรวจสอบอินเทอร์เน็ตหรือตัวรันของคุณ")
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local States = {
    WalkSpeedEnabled = false,
    WalkSpeed = 16,
    FlyEnabled = false,
    FlySpeed = 50,
    Invisible = false,
    SpawnAmount = 1
}

-- =================================================================
-- 1. สร้างปุ่มลอยเปิด/ปิดแบบปลอดภัย (ป้องกัน CoreGui Error)
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlaninHubToggleSafe"

-- ใช้ pcall เพื่อป้องกัน Error หากตัวรันไม่มีสิทธิ์เข้าถึง CoreGui
local guiSuccess, _ = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not guiSuccess then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

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

ToggleUIBtn.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
end)

-- =================================================================
-- 2. สร้างหน้าต่างหลัก
-- =================================================================
local Window = Rayfield:CreateWindow({
    Name = "PlaninHub",
    LoadingTitle = "กำลังโหลด PlaninHub...",
    LoadingSubtitle = "ความเร็ว, บิน, ล่องหน, ฟาร์มเงิน",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- ลบ Icon แบบ String ออก เพื่อป้องกันหน้าต่างบัคว่างเปล่า
local MoneyTab = Window:CreateTab("ฟาร์มเงิน")
local MainTab = Window:CreateTab("เมนูหลัก")
local PlayerTab = Window:CreateTab("ตัวละคร")

-- =================================================================
-- 3. ระบบเสกเงิน
-- =================================================================
MoneyTab:CreateSection("เสกเหรียญ / กล่อง")

MoneyTab:CreateInput({
    Name = "ระบุจำนวนที่ต้องการเสก",
    PlaceholderText = "พิมพ์ตัวเลข...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        States.SpawnAmount = tonumber(Text) or 1
    end,
})

MoneyTab:CreateButton({
    Name = "💰 กดเสกเงิน",
    Callback = function()
        pcall(function()
            local Event = LocalPlayer:FindFirstChild("ninjaEvent") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("ninjaEvent"))
            if Event then
                local function GetNil(Name)
                    for _, Object in getnilinstances() do
                        if Object.Name == Name then return Object end
                    end
                    return nil
                end
                
                local targetCrate = GetNil("Chi Crate")
                
                if targetCrate then
                    for i = 1, States.SpawnAmount do
                        firesignal(Event.OnClientEvent, "collectCoin", targetCrate)
                    end
                    Rayfield:Notify({Title = "สำเร็จ", Content = "เสกเงิน " .. States.SpawnAmount .. " ครั้ง", Duration = 3})
                else
                    Rayfield:Notify({Title = "ผิดพลาด", Content = "ไม่พบกล่อง Chi Crate", Duration = 3})
                end
            end
        end)
    end,
})

-- =================================================================
-- 4. ระบบวิ่งเร็ว
-- =================================================================
MainTab:CreateSection("ตั้งค่าความเร็ว")

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

RunService.RenderStepped:Connect(function()
    pcall(function()
        if States.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = States.WalkSpeed
        end
    end)
end)

-- =================================================================
-- 5. ระบบบิน
-- =================================================================
MainTab:CreateSection("ตั้งค่าการบิน")
local FlyBodyVelocity = nil
local FlyBodyGyro = nil

MainTab:CreateToggle({
    Name = "เปิดใช้งาน บิน",
    CurrentValue = false,
    Flag = "ToggleFly",
    Callback = function(Value)
        States.FlyEnabled = Value
        pcall(function()
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
        end)
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

RunService.RenderStepped:Connect(function()
    pcall(function()
        if States.FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local camera = workspace.CurrentCamera
            local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
            
            if FlyBodyVelocity and FlyBodyGyro then
                FlyBodyGyro.CFrame = camera.CFrame
                if moveDir.Magnitude > 0 then
                    FlyBodyVelocity.Velocity = camera.CFrame.LookVector * (moveDir.Z * -States.FlySpeed) + camera.CFrame.RightVector * (moveDir.X * States.FlySpeed)
                else
                    FlyBodyVelocity.Velocity = Vector3.zero
                end
            end
        end
    end)
end)

-- =================================================================
-- 6. ระบบล่องหน
-- =================================================================
PlayerTab:CreateSection("สถานะตัวละคร")

PlayerTab:CreateToggle({
    Name = "ล่องหน (Client-Side)",
    CurrentValue = false,
    Flag = "ToggleInvisible",
    Callback = function(Value)
        States.Invisible = Value
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("Decal") then
                        if States.Invisible then
                            if not part:GetAttribute("OrigTrans") then part:SetAttribute("OrigTrans", part.Transparency) end
                            part.Transparency = 1
                        else
                            if part:GetAttribute("OrigTrans") then part.Transparency = part:GetAttribute("OrigTrans") end
                        end
                    elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                        part.Handle.Transparency = States.Invisible and 1 or 0
                    end
                end
            end
        end)
    end,
})
