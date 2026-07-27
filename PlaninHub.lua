-- ===================== ระบบฟาร์ม ninjaEvent =====================
local autoFarm = false
local farmDelay = 0.05          -- ยิ่งน้อยยิ่งเร็ว
local farmThread = nil

-- หา Remote ให้ถูกต้อง (ดีกว่า LocalPlayer.ninjaEvent)
local function getNinjaEvent()
	local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ninjaEvent")
	
	if not remote then
		for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
			if v.Name == "ninjaEvent" and v:IsA("RemoteEvent") then
				return v
			end
		end
	end
	return remote
end

-- เริ่มฟาร์ม (ใช้รูปแบบ while เหมือนตัวอย่างคุณ)
local function startFarm()
	if farmThread then
		task.cancel(farmThread)
	end

	farmThread = task.spawn(function()
		while autoFarm do
			local remote = getNinjaEvent()
			if remote then
				pcall(function()
					remote:FireServer()   -- ตรงกับตัวอย่างของคุณ
				end)
			end
			task.wait(farmDelay)
		end
	end)
end

-- ปุ่มเปิด/ปิด Auto Farm
AutoFarmBtn.MouseButton1Click:Connect(function()
	autoFarm = not autoFarm

	if autoFarm then
		AutoFarmBtn.Text = "Auto Farm : ON"
		AutoFarmBtn.TextColor3 = Color3.fromRGB(140, 255, 180)
		AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(30, 70, 50)
		startFarm()
	else
		AutoFarmBtn.Text = "Auto Farm : OFF"
		AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 130, 150)
		AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 70)
		
		if farmThread then
			task.cancel(farmThread)
			farmThread = nil
		end
	end
end)
