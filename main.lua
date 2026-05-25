-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.1.3 - TRIGGER PAD]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.1.3
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.1.3", "DarkTheme")

-- 2. TOMBOL MINIMIZE HP (BULAT MERAH)
local ScreenGui = Instance.new("ScreenGui")
local MinButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "RappMinimizeSystem"

MinButton.Parent = ScreenGui
MinButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
MinButton.Position = UDim2.new(0, 15, 0, 15) -- Pojok kiri atas
MinButton.Size = UDim2.new(0, 45, 0, 45)
MinButton.Text = "R"
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.Font = Enum.Font.SourceSansBold
MinButton.TextSize = 20

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MinButton

MinButton.MouseButton1Click:Connect(function()
    KavoLib:ToggleUI()
end)

-- [BARU] 3. TOMBOL TRIGGER GERBANG AWAL (BULAT HIJAU)
local AcceptTrigger = Instance.new("TextButton")
local UICorner2 = Instance.new("UICorner")

AcceptTrigger.Parent = ScreenGui
AcceptTrigger.BackgroundColor3 = Color3.fromRGB(40, 180, 40) -- Warna Hijau
AcceptTrigger.Position = UDim2.new(0, 70, 0, 15) -- Di sebelah tombol merah
AcceptTrigger.Size = UDim2.new(0, 45, 0, 45)
AcceptTrigger.Text = "A"
AcceptTrigger.TextColor3 = Color3.fromRGB(255, 255, 255)
AcceptTrigger.Font = Enum.Font.SourceSansBold
AcceptTrigger.TextSize = 20

UICorner2.CornerRadius = UDim.new(1, 0)
UICorner2.Parent = AcceptTrigger

-- Logika 2x Klik Berurutan saat Tombol Hijau "A" ditekan manual
AcceptTrigger.MouseButton1Click:Connect(function()
    pcall(function()
        local camera = workspace.CurrentCamera
        local vInput = game:GetService("VirtualInputManager")
        
        local screenWidth = camera.ViewportSize.X
        local screenHeight = camera.ViewportSize.Y
        
        -- Koordinat tombol hijau "Accept" asli Adopt Me (60% lebar, 78% tinggi)
        local clickX = screenWidth * 0.60
        local clickY = screenHeight * 0.78
        
        -- [KLIK 1: TERIMA AJAKAN TRADE]
        vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
        task.wait(0.05)
        vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
        
        -- Jeda setengah detik menunggu pop-up scam muncul
        task.wait(0.5)
        
        -- [KLIK 2: TERIMA PERINGATAN SCAM]
        vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
        task.wait(0.05)
        vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
    end)
end)

-- 4. MENU AUTOMATION TRADE - SISA BYPASS REMOTE TAHAP AKHIR
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Aktifkan Remote Bypass", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        -- Cek apakah kita sudah berhasil masuk ke tab trade utama
                        local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI") or playerGui:FindFirstChild("Trade")
                        
                        -- Jika sudah masuk trade, Remote langsung otomatis mengeklik Accept tengah & final via server
                        if sedangTrade and API then
                            if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                                API["TradeAPI/AcceptNegotiation"]:FireServer()
                            end
                            
                            task.wait(0.8)
                            
                            if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                                API["TradeAPI/ConfirmTrade"]:FireServer()
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)
