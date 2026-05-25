-- 1. MEMBUAT TOMBOL MELAYANG UNTUK SEMBUNYIKAN/MUNCULKAN UI
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "MinimizeGui"

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0) -- Posisi tombol di kiri atas layar
ToggleButton.Size = UDim2.new(0, 80, 0, 35)
ToggleButton.Text = "Hide Menu"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14

-- Membuat sudut tombol melayang jadi bulat
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

-- 2. SETUP UI UTAMA (KAVO LIBRARY)
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp", "DarkTheme")

-- Fungsi sembunyikan/munculkan menu saat tombol melayang diklik
local uiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    -- Mencari nama UI bawaan Kavo untuk disembunyikan
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") and gui:FindFirstChild("MotherFrame") then
            gui.Enabled = uiVisible
        end
    end
    ToggleButton.Text = uiVisible and "Hide Menu" or "Show Menu"
end)

-- 3. MEMBUAT TAB DAN FITUR AUTO ACCEPT
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Menerima trade otomatis via Simulasi Klik", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            while _G.AutoAccept do
                pcall(function()
                    -- MENCARI TOMBOL "ACCEPT" DI LAYAR SECARA OTOMATIS
                    local localPlayer = game.Players.LocalPlayer
                    local playerGui = localPlayer:WaitForChild("PlayerGui")
                    
                    -- Script akan mengecek seluruh UI di layar untuk mencari tombol bernama "Accept"
                    for _, v in pairs(playerGui:GetDescendants()) do
                        if v:IsA("TextButton") and (v.Name == "Accept" or v.Text == "Accept") and v.IsDriven == false then
                            -- Jika tombol accept ketemu dan sedang muncul di layar, otomatis klik!
                            if v.AbsoluteSize.X > 0 and v.AbsolutePosition.Y > 0 then
                                -- Menjalankan fungsi klik bawaan Roblox
                                local virtualInput = game:GetService("VirtualInputManager")
                                virtualInput:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 36, 0, true, game, 0)
                                task.wait(0.1)
                                virtualInput:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 36, 0, false, game, 0)
                            end
                        end
                    end
                end)
                task.wait(0.3) -- Cek super cepat setiap 0.3 detik
            end
        end)
    end
end)
