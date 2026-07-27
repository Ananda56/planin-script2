-- =================================================================
-- 🐟 PlaninHub - Speed, Fly, Invisible & Money Spawner
-- UI Library: Rayfield (Modern Dark Theme)
-- =================================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ตัวแปรควบคุมระบบ
local States = {
    WalkSpeedEnabled = false,
    WalkSpeed = 16,
    FlyEnabled = false,
    FlySpeed = 50,
    Invisible = false,
    SpawnAmount = 1 -- จำนวนเงินที่จะเสก (ค่าเริ่มต้น)
}

-- =================================================================
-- 1. สร้างปุ่มลอยสำหรับ เปิด/ปิด UI
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

local UIVisible = true
ToggleUIBtn.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
end)

-- =================================================================
-- 2. สร้างหน้าต่างหลัก (Main Window)
-- =================================================================
local Window = Rayfield:CreateWindow({
    Name = "PlaninHub",
    LoadingTitle = "กำลังโหลดสคริปต์...",
    LoadingSubtitle = "ความเร็ว, บิน, ล่องหน, ฟาร์มเงิน",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- สร้างแถบเมนู (Tabs)
local MoneyTab = Window:CreateTab("ฟาร์มเงิน", "bank")
local MainTab = Window:CreateTab("เมนูหลัก", "home")
local PlayerTab = Window:CreateTab("ตัวละคร", "user")

-- =================================================================
-- 3. ระบบเสกเงินตามจำนวนที่พิมพ์ (ระบบใหม่ของคุณ)
-- =================================================================
MoneyTab:CreateSection("เสกเหรียญ / กล่อง (Chi Crate)")

MoneyTab:CreateInput({
    Name = "ระบุจำนวนที่ต้องการเสก",
    PlaceholderText = "พิมพ์ตัวเลขที่นี่ (เช่น 100)",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        -- แปลงข้อความที่พิมพ์เป็นตัวเลข ถ้าพิมพ์ผิดจะตั้งค่าเป็น 1
        States.SpawnAmount = tonumber(Text) or 1
    end,
})

MoneyTab:CreateButton({
    Name = "💰 กดเสกเงิน",
    Callback = function()
        -- ค้นหา ninjaEvent
        local Event = LocalPlayer:FindFirstChild("ninjaEvent") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("ninjaEvent"))
        
        if Event then
            -- ฟังก์ชัน GetNil ที่ปรับปรุงแล้ว
            local function GetNil(Name, DebugId)
                for _, Object in getnilinstances() do
                    -- หาด้วยชื่ออย่างเดียวเผื่อ DebugId เปลี่ยนแปลงเมื่อย้ายเซิร์ฟเวอร์
                    if Object.Name == Name then
                        return Object
                    end
                end
                return nil
            end
            
            local targetCrate = GetNil("Chi Crate", "1_1368040")
            
            if targetCrate then
                -- วนลูปเสกตามจำนวนที่กรอกไว้
                for i = 1, States.SpawnAmount do
                    -- โค้ดดั้งเดิมของคุณ: ใช้ firesignal (Visual Client-Side)
                    firesignal(Event.OnClientEvent, "collectCoin", targetCrate)
                    
                    -- หากต้องการให้เงินเพิ่มจริงๆ ในเซิร์ฟเวอร์ ให้ลองเปลี่ยนบรรทัดด้านบนเป็น:
                    -- Event:FireServer("collectCoin", targetCrate)
                end
                
                Rayfield:Notify({
                    Title = "เสร็จสิ้น!",
                    Content = "ส่งคำสั่งเสกเงินจำนวน " .. tostring(States.SpawnAmount) .. " ครั้งแล้ว",
                    Duration = 3,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "เกิดข้อผิดพลาด",
                    Content = "ไม่พบ 'Chi Crate' ใน Nil Instances",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        else
            Rayfield:Notify({
                Title = "ข้อผิดพลาด",
                Content = "ไม่พบ ninjaEvent!",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- =================================================================
-- 4. ระบบวิ่งเร็ว (WalkSpeed)
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

RunService.RenderStepped:Connect(function()
    if States.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = States.WalkSpeed
    end
end)

-- =================================================================
-- 5. ระบบบิน (Fly System)
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
-- 6. ระบบล่องหน (Local Invisibility)
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
                        if not part:GetAttribute("OriginalTransparency") then
                            part:SetAttribute("OriginalTransparency", part.Transparency)
                        end
                        part.Transparency = 1
                    else
                        if part:GetAttribute("OriginalTransparency") then
                            part.Transparency = part:GetAttribute("OriginalTransparency")
                        end
                    end
                elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                    part.Handle.Transparency = States.Invisible and 1 or 0
                end
            end
        end
    end,
})
