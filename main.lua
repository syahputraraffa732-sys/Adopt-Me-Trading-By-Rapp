-- HAPUS SEMUA KODE LAMA DAN GANTI DENGAN INI

-- 1. SETUP UI UTAMA (KAVO LIBRARY)
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp", "DarkTheme")

-- 2. MEMBUAT TOMBOL MINIMIZE KHUSUS HP (BULAT MERAH)
local ScreenGui = Instance.new("ScreenGui")
local MinButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "RappMinimizeSystem"

MinButton.Parent = ScreenGui
MinButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50) -- Warna Merah
MinButton.Position = UDim2.new(0, 10, 0, 10) -- Pojok kiri atas layar
MinButton.Size = UDim2.new(0, 45, 0, 45) -- Bentuk bulat pas buat jempol
MinButton.Text = "R"
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.Font = Enum.Font.SourceSansBold
MinButton.TextSize = 20

UICorner.CornerRadius = UDim.new(1, 0) -- Membuatnya bulat sempurna
UICorner.Parent = MinButton

-- Fungsi Klik Tombol Merah untuk Menyembunyikan Tab Gede
local uiVisible = true
MinButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") and gui:FindFirstChild("MotherFrame") then
            gui.Enabled = uiVisible
        end
    end
end)

-- 3. MEMBUAT MENU TAB
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Klik otomatis semua tombol Accept", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local virtualInput = game:GetService("VirtualInputManager")
            
            while _G.AutoAccept do
                pcall(function()
                    -- Mencari semua jenis UI tombol di layar HP-mu
                    for _, button in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
                        if button:IsA("TextButton") and button.Visible then
                            -- Jika menemukan tombol bertuliskan "Accept", "Menerima", atau "Confirm"
                            local text = button.Text:lower()
                            if text:find("accept") or text:find("terima") or button.Name:lower():find("accept") then
                                -- Pastikan posisinya muncul di layar
                                if button.AbsoluteSize.X > 0 then
                                    -- Menghitung titik tengah tombol untuk diklik oleh jari virtual
                                    local clickX = button.AbsolutePosition.X + (button.AbsoluteSize.X / 2)
                                    local clickY = button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2) + 36
                                    
                                    -- Eksekusi simulasi ketukan layar
                                    virtualInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                                    task.wait(0.05)
                                    virtualInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.4) -- Cek layar setiap 0.4 detik
            end
        end)
    end
end)
