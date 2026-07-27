-- =================================================================
-- 🐟 PlaninHub - Orion Library Edition (รองรับทุกตัวรัน 100%)
-- =================================================================

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
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
-- 1. สร้างหน้าต่างหลัก Orion
-- =================================================================
local Window = OrionLib:MakeWindow({
    Name = "🐟 PlaninHub",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "PlaninHub"
})

-- =================================================================
-- 2. สร้างปุ่มลอยเปิด/ปิดแบบปลอดภัย
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlaninHubToggleUI"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

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
    -- ค้นหาและปิด/เปิดหน้าต่าง Orion
    local orionGui = nil
    pcall(function() orionGui = game:GetService("CoreGui"):FindFirstChild("Orion") end)
    if not orionGui then orionGui = LocalPlayer.PlayerGui:FindFirstChild("Orion") end
    
    if orionGui then
        orionGui.Enabled = not orionGui.Enabled
    end
end)

-- =================================================================
-- 3. แท็บ: ฟาร์มเงิน
-- =================================================================
local MoneyTab = Window:MakeTab({Name = "ฟาร์มเงิน", Icon = "rbxassetid://4483345998", PremiumOnly = false})

MoneyTab:AddTextbox({
    Name = "ระบุจำนวนที่ต้องการเสก",
    Default = "1",
    TextDisappear = false,
    Callback = function(Value)
        States.SpawnAmount = tonumber(Value) or 1
    end      
})

MoneyTab:AddButton({
    Name = "💰 กดเสกเงิน",
    Callback = function()
        pcall(function()
            local Event = LocalPlayer:FindFirstChild("ninjaEvent") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("ninjaEvent"))
            if Event then
                local function GetNil(Name)
                    for _, Object in pairs(getnilinstances()) do
                        if Object.Name == Name then return Object end
                    end
                    return nil
                end
                
                local targetCrate = GetNil("Chi Crate")
                
                if targetCrate then
                    for i = 1, States.SpawnAmount do
                        firesignal(Event.OnClientEvent, "collectCoin", targetCrate)
                    end
                    OrionLib:MakeNotification({Name = "สำเร็จ", Content = "เสกเงินจำนวน " .. States.SpawnAmount .. " ครั้ง", Image = "rbxassetid://4483345998", Time = 3})
                else
                    OrionLib:MakeNotification({Name = "ผิดพลาด", Content = "ไม่พบกล่อง Chi Crate ในด่านนี้", Image = "rbxassetid://4483345998", Time = 3})
                end
            else
                OrionLib:MakeNotification({Name = "ผิดพลาด", Content = "ไม่พบ Event ของเกมนี้", Image = "rbxassetid://4483345998", Time = 3})
            end
        end)
    end    
})

-- =================================================================
-- 4. แท็บ: เมนูหลัก (ความเร็ว & บิน)
-- =================================================================
local MainTab = Window:MakeTab({Name = "เมนูหลัก", Icon = "rbxassetid://4483345998", PremiumOnly = false})

MainTab:AddToggle({
    Name = "เปิดใช้งาน วิ่งเร็ว",
    Default = false,
    Callback = function(Value)
        States.WalkSpeedEnabled = Value
    end    
})

MainTab:AddSlider({
    Name = "ระดับความเร็ว",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        States.WalkSpeed = Value
    end    
})

local FlyBodyVelocity = nil
local FlyBodyGyro = nil

MainTab:AddToggle({
    Name = "เปิดใช้งาน บิน",
    Default = false,
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
    end    
})

MainTab:AddSlider({
    Name = "ความเร็วการบิน",
    Min = 10,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        States.FlySpeed = Value
    end    
})

-- ลูปอัปเดตความเร็ว & บิน
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            -- วิ่ง
            if States.WalkSpeedEnabled and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = States.WalkSpeed
            end
            
            -- บิน
            if States.FlyEnabled and char:FindFirstChild("HumanoidRootPart") and FlyBodyVelocity and FlyBodyGyro then
                local camera = workspace.CurrentCamera
                local moveDir = char.Humanoid.MoveDirection
                
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
-- 5. แท็บ: ตัวละคร (ล่องหน)
-- =================================================================
local PlayerTab = Window:MakeTab({Name = "ตัวละคร", Icon = "rbxassetid://4483345998", PremiumOnly = false})

PlayerTab:AddToggle({
    Name = "เปิดใช้งาน ล่องหน (Client-Side)",
    Default = false,
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
    end    
})

OrionLib:Init()
