-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.1.1 - INSTANT DETECT]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.1.1
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.1.1", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI DETEKSI JALUR UI ABSOLUT
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Deteksi Komponen TradeRequest", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local camera = workspace.CurrentCamera
            local vInput = game:GetService("VirtualInputManager")
            
            -- Pengunci anti-spam biar tidak bertingkah seperti auto-clicker biasa
            local prosesKlikSelesai = false
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    
                    if playerGui then
                        -- [DETEKSI JALUR UI ABSOLUT]
                        -- Kita cari foldernya langsung berdasarkan nama sistem Adopt Me
                        local adaPopupAwal = false
                        
                        -- Cara 1: Scan folder khusus TradeRequestApp
                        if playerGui:FindFirstChild("TradeRequestApp") or playerGui:FindFirstChild("TradeRequest") then
                            adaPopupAwal = true
                        else
                            -- Cara 2: Backup scan jika nama foldernya berada di dalam folder Dialog/Notification
                            for _, obj in pairs(playerGui:GetDescendants()) do
                                if obj.Name == "TradeRequestApp" or obj.Name == "TradeRequest" or (obj:IsA("Frame") and obj.Visible and obj.Name:find("Trade")) then
                                    -- Memastikan ini adalah pop-up surat kertas yang sedang terbuka
                                    if obj:FindFirstChild("Accept") or obj:FindFirstChild("AcceptButton") or obj:FindFirstChild("Decline") then
                                        adaPopupAwal = true
                                        break
                                    end
                                end
                            end
                        end
                        
                        -- EKSEKUSI KLIK JIKA POP-UP CONFIRMED TERBUKA DI SISTEM
                        if adaPopupAwal and not prosesKlikSelesai then
                            prosesKlikSelesai = true -- Kunci klik diaktifkan!
                            
                            local screenWidth = camera.ViewportSize.X
                            local screenHeight = camera.ViewportSize.Y
                            
                            -- Koordinat tombol hijau "Accept" kamu (60% lebar, 78% tinggi)
                            local clickX = screenWidth * 0.60
                            local clickY = screenHeight * 0.78
                            
                            -- [KLIK 1: TERIMA AJAKAN TRADE]
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                            task.wait(0.05)
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                            
                            -- Jeda setengah detik agar pop-up scam/peringatan muncul menggantikan posisi pop-up awal
                            task.wait(0.5)
                            
                            -- [KLIK 2: TERIMA PERINGATAN SCAM]
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                            task.wait(0.05)
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                        end
                        
                        -- RESET PENGUNCI HANYA JIKA KEDUA PLAYER SUDAH BERSIH DARI WINDOW TRADE
                        local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI")
                        if not adaPopupAwal and not sedangTrade then
                            prosesKlikSelesai = false
                        end
                        
                        -- ======================================================
                        -- [BYPASS REMOTE TAHAP TENGAH & AKHIR]
                        -- ======================================================
                        -- Berjalan super lancar langsung via data server (tanpa klik layar lagi)
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
                task.wait(0.3)
            end
        end)
    end
end)
