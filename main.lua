-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.1.4 - FULL AUTO EVENT]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.1.4
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.1.4", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI FULL AUTOMATIC EVENT
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Full Otomatis 2-Klik Berurutan", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local camera = workspace.CurrentCamera
            local vInput = game:GetService("VirtualInputManager")
            local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            
            -- Pengunci cerdas agar tidak terjadi spam klik hantu (Anti Auto-Clicker)
            local lagiProsesKlik = false
            
            -- Fungsi utama untuk menembak 2 klik berurutan secara instan tepat sasaran
            local function eksekusiDuaKlikGerbangAwal()
                if lagiProsesKlik then return end
                lagiProsesKlik = true -- Kunci dinyalakan!
                
                local screenWidth = camera.ViewportSize.X
                local screenHeight = camera.ViewportSize.Y
                
                -- Koordinat tombol hijau "Accept" kamu (60% lebar, 78% tinggi)
                local clickX = screenWidth * 0.60
                local clickY = screenHeight * 0.78
                
                -- [KLIK 1: TERIMA AJAKAN TRADE]
                vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                task.wait(0.05)
                vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                
                -- Jeda pendek 0.4 detik menunggu pop-up peringatan scam muncul di layar
                task.wait(0.4)
                
                -- [KLIK 2: TERIMA PERINGATAN SCAM / BYPASS WARNING]
                vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                task.wait(0.05)
                vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
            end
            
            -- [SISTEM DETEKSI OTOMATIS: CHILD ADDED EVENT]
            -- Mendeteksi detik itu juga saat ada objek UI baru dari Adopt Me yang muncul di layar
            local koneksiUI = playerGui.ChildAdded:Connect(function(child)
                if not _G.AutoAccept then return end
                
                -- Jika ada folder dialog/pop-up transaksi baru yang lahir di PlayerGui
                if child.Name:find("Trade") or child.Name:find("App") or child.Name:find("Dialog") then
                    task.wait(0.1) -- Jeda super singkat agar UI ter-render sempurna
                    eksekusiDuaKlikGerbangAwal()
                end
            end)
            
            -- LOOP UTAMA UNTUK BYPASS REMOTE TAHAP TENGAH & AKHIR VIA SERVER
            while _G.AutoAccept do
                pcall(function()
                    -- Mengecek apakah kita sudah sukses berada di dalam tab trade utama
                    local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI") or playerGui:FindFirstChild("Trade")
                    
                    if sedangTrade and API then
                        -- Menembak Remote Konfirmasi Tahap 1 (Accept hijau tengah)
                        if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                            API["TradeAPI/AcceptNegotiation"]:FireServer()
                        end
                        
                        task.wait(0.8)
                        
                        -- Menembak Remote Konfirmasi Final (Hitung mundur 15 detik)
                        if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                            API["TradeAPI/ConfirmTrade"]:FireServer()
                        end
                    end
                    
                    -- RESET PENGUNCI JIKA SUDAH BERSIH DARI AKTIVITAS TRADE
                    if not sedangTrade then
                        lagiProsesKlik = false
                    end
                end)
                task.wait(0.5)
            end
            
            -- Matikan koneksi event jika toggle dimatikan agar hemat RAM HP
            if koneksiUI then koneksiUI:Disconnect() end
        end)
    end
end)
