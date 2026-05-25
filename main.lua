-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.0.7 - DELAY BYPASS]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.0.7
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.0.7", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI JEDA AMAN
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Jeda Klik 5 Detik", function(Value)
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
                        -- 1. DETEKSI APAKAH POP-UP NYA MUNCUL DI LAYAR
                        local adaPopup = false
                        for _, obj in pairs(playerGui:GetDescendants()) do
                            if obj:IsA("TextLabel") and obj.Visible and obj.Text:lower():find("trade request") then
                                adaPopup = true
                                break
                            end
                        end
                        
                        -- 2. EKSEKUSI KLIK LAYAR JIKA POP-UP TERDETEKSI
                        if adaPopup then
                            local screenWidth = camera.ViewportSize.X
                            local screenHeight = camera.ViewportSize.Y
                            
                            -- Koordinat tombol hijau Accept kamu
                            local clickX = screenWidth * 0.60
                            local clickY = screenHeight * 0.78
                            
                            -- Ketuk sekali saja
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                            task.wait(0.05)
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                            
                            -- [KUNCI JEDA] Paksa script tidur selama 5 detik agar tidak terjadi spam klik hantu
                            task.wait(5)
                        end
                        
                        -- ======================================================
                        -- [BYPASS REMOTE TAHAP TENGAH & AKHIR]
                        -- ======================================================
                        -- Bagian ini berjalan aman via server tanpa mengganggu layar
                        if API then
                            -- Menembak Remote Konfirmasi Tahap 1 (Accept hijau pertama)
                            if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                                API["TradeAPI/AcceptNegotiation"]:FireServer()
                            end
                            
                            -- Jeda singkat menuju hitung mundur final
                            task.wait(0.5)
                            
                            -- Menembak Remote Konfirmasi Akhir
                            if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                                API["TradeAPI/ConfirmTrade"]:FireServer()
                            end
                        end
                    end
                end)
                task.wait(0.5) -- Cek berkala setiap 0.5 detik
            end
        end)
    end
end)
