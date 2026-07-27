local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/>..."))()

local Window = Library.CreateLib("โปรฟาร์มอัตโนมัติ", "Ocean")

local Tab = Window:NewTab("ฟาร์ม")

local Section = Tab:NewSection("ฟาร์มดาบอัตโนมัติ")

Section:NewButton("เริ่มฟาร์ม", "จะเริ่มฟาร์มดาบอัตโนมัติ", function()
    while true do
        game:GetService("Players").LocalPlayer.ninjaEvent:FireServer()
        task.wait(0.01)
    end
end)
