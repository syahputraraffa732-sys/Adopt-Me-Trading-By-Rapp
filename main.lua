-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.0.5 - SCREEN TOUCH]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.0.5
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.0.5", "DarkTheme")

-- 2. TOMBOL MINIMIZE HP (BULAT MERAH)
local ScreenGui = Instance.new("ScreenGui")
local MinButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "RappMinimizeSystem"

MinButton.Parent = ScreenGui
MinButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
MinButton.Position = UDim2.new(0, 15, 0, 15)
MinButton.Size = UDim2.new(0, 50, 0, 50)
MinButton.Text = "R"
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.Font = Enum.Font.SourceSansBold
MinButton.TextSize = 22

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MinButton

MinButton.MouseButton1Click:Connect(function()
    KavoLib:ToggleUI()
end)

-- 3. MENU AUTOMATION TRADE - VERSI KOORDINAT PERSENTASE LAYAR HP
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Kalibrasi Sentuhan Layar HP", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local camera = workspace.CurrentCamera
            local vInput = game:GetService("VirtualInputManager")
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    
                    if playerGui then
                        -- [KONDISI A: JIKA POP-UP AWAL MUNCUL DI LAYAR]
                        -- Kita cek apakah ada dialog trade request yang sedang aktif terbuka
                        local adaPopup = false
                        for _, obj in pairs(playerGui:GetDescendants()) do
                            if obj:IsA("TextLabel") and obj.Visible and obj.Text:lower():find("trade request") then
                                adaPopup = true
                                break
                            end
                        end
                        
                        -- Jika pop-up terdeteksi aktif di layar HP
                        if adaPopup then
                            -- Menghitung ukuran resolusi asli layar HP kamu saat ini
                            local screenWidth = camera.ViewportSize.X
                            local screenHeight = camera.ViewportSize.Y
                            
                            -- KALIBRASI PERSENTASE: Menghitung posisi tombol hijau "Accept" di HP Poco M7 Pro
                            local clickX = screenWidth * 0.60  -- 60% dari lebar layar ke kanan
                            local clickY = screenHeight * 0.78 -- 78% dari tinggi layar ke bawah
                            
                            -- Melakukan simulasi ketukan jari tepat di atas tombol hijau tersebut
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                            task.wait(0.05)
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                        end
                        
                        -- ======================================================
                        -- [KONDISI B: BYPASS REMOTE UNTUK TAHAP TENGAH & AKHIR]
                        -- ======================================================
                        -- (Bagian ini tetap dipertahankan karena sudah terbukti berhasil 100%)
                        if API then
                            -- Menembak Remote Konfirmasi Tahap 1
                            if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                                API["TradeAPI/AcceptNegotiation"]:FireServer()
                            end
                            
                            -- Jeda menuju tahap konfirmasi final 15 detik
                            task.wait(0.5)
                            
                            -- Menembak Remote Konfirmasi Akhir
                            if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                                API["TradeAPI/ConfirmTrade"]:FireServer()
                            end
                        end
                    end
                end)
                task.wait(0.4) -- Kecepatan ketukan jari otomatis (tiap 0.4 detik)
            end
        end)
    end
end)
