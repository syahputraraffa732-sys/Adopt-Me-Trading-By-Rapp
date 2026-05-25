-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.0.6 - SMART BYPASS]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.0.6
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.0.6", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI ANTI-TABRAKAN
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Anti Auto-Clicker Lock", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local camera = workspace.CurrentCamera
            local vInput = game:GetService("VirtualInputManager")
            
            -- Variabel pengunci agar tidak nge-klik terus menerus
            local sudahKlikGerbangAwal = false
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    
                    if playerGui then
                        -- 1. CEK APAKAH POP-UP AWAL ADA DI LAYAR
                        local adaPopup = false
                        for _, obj in pairs(playerGui:GetDescendants()) do
                            if obj:IsA("TextLabel") and obj.Visible and obj.Text:lower():find("trade request") then
                                adaPopup = true
                                break
                            end
                        end
                        
                        -- 2. CEK APAKAH TAB TRADE UTAMA SUDAH TERBUKA
                        -- Di Adopt Me, jika TradeApp/DialogAPI aktif, berarti kita sudah di dalam tab transaksi
                        local sudahMasukTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI")
                        
                        -- [EKSEKUSI GERBANG AWAL]
                        -- Hanya nge-klik JIKA ada pop-up DAN kita BELUM masuk ke tab trade utamanya
                        if adaPopup and not sudahMasukTrade and not sudahKlikGerbangAwal then
                            sudahKlikGerbangAwal = true -- Kunci aktif! Gak bakal nge-klik lagi sampai trade reset
                            
                            local screenWidth = camera.ViewportSize.X
                            local screenHeight = camera.ViewportSize.Y
                            
                            -- Posisi tombol hijau Accept kamu
                            local clickX = screenWidth * 0.60
                            local clickY = screenHeight * 0.78
                            
                            -- Sentuh sekali saja!
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                            task.wait(0.05)
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                        end
                        
                        -- [RESET PENGUNCI]
                        -- Jika pop-up hilang dan kita tidak sedang di dalam trade, reset status biar bisa terima trade baru nanti
                        if not adaPopup and not sudahMasukTrade then
                            sudahKlikGerbangAwal = false
                        end
                        
                        -- ======================================================
                        -- [BYPASS REMOTE TAHAP TENGAH & AKHIR]
                        -- ======================================================
                        -- Bagian ini berjalan aman lewat internet, tanpa menyentuh layar sama sekali!
                        if sudahMasukTrade and API then
                            -- Menembak Remote Konfirmasi Tahap 1 (Accept hijau pertama)
                            if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                                API["TradeAPI/AcceptNegotiation"]:FireServer()
                            end
                            
                            -- Jeda 0.8 detik menuju hitung mundur 15 detik
                            task.wait(0.8)
                            
                            -- Menembak Remote Konfirmasi Final
                            if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                                API["TradeAPI/ConfirmTrade"]:FireServer()
                            end
                        end
                    end
                end)
                task.wait(0.4) -- Pengecekan sistem berkala
            end
        end)
    end
end)
