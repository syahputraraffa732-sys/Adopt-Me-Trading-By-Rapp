-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.1.2 - COLOR DETECT]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.1.2
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.1.2", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI DETEKSI WARNA HIJAU TOMBOL
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Deteksi Warna Tombol Hijau", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local camera = workspace.CurrentCamera
            local vInput = game:GetService("VirtualInputManager")
            
            -- Pengunci agar tidak terjadi spam klik hantu (Anti Auto-Clicker)
            local prosesKlikSelesai = false
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    
                    if playerGui then
                        -- [DETEKSI WARNA TOMBOL POP-UP]
                        local adaTombolHijauAktif = false
                        
                        -- Kita scan seluruh objek UI di dalam PlayerGui
                        for _, obj in pairs(playerGui:GetDescendants()) do
                            if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Visible and obj.AbsoluteSize.X > 0 then
                                -- Mengecek warna latar belakang objek (mencari elemen berwarna hijau khas Adopt Me)
                                local warna = obj.BackgroundColor3
                                -- Kisaran warna hijau (R rendah, G tinggi, B rendah)
                                if warna.G > 0.5 and warna.R < 0.5 and warna.B < 0.5 then
                                    -- Memastikan ini bukan tombol di dalam menu utama script kita sendiri
                                    if not obj:IsDescendantOf(game:GetService("CoreGui")) then
                                        adaTombolHijauAktif = true
                                        break
                                    end
                                end
                            end
                        end
                        
                        -- JIKA TOMBOL HIJAU POP-UP TERDETEKSI DAN SCRIPT BELUM MENGUNCI KLIK
                        if adaTombolHijauAktif and not prosesKlikSelesai then
                            prosesKlikSelesai = true -- Langsung kunci sistem klik layar!
                            
                            local screenWidth = camera.ViewportSize.X
                            local screenHeight = camera.ViewportSize.Y
                            
                            -- Koordinat tombol hijau "Accept" kamu (60% lebar, 78% tinggi)
                            local clickX = screenWidth * 0.60
                            local clickY = screenHeight * 0.78
                            
                            -- [KLIK 1: TERIMA AJAKAN TRADE AWAL]
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                            task.wait(0.05)
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                            
                            -- Jeda setengah detik agar pop-up scam muncul menggantikan pop-up awal
                            task.wait(0.5)
                            
                            -- [KLIK 2: TERIMA PERINGATAN SCAM / OKAY]
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                            task.wait(0.05)
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                        end
                        
                        -- RESET PENGUNCI HANYA JIKA KEDUA LAYAR DI SANA SUDAH BERSIH DARI WINDOW TRADE
                        local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI")
                        if not adaTombolHijauAktif and not sedangTrade then
                            prosesKlikSelesai = false
                        end
                        
                        -- ======================================================
                        -- [BYPASS REMOTE TAHAP TENGAH & AKHIR]
                        -- ======================================================
                        -- Bagian ini murni berjalan via data server (tanpa mengganggu layar trade utama)
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
