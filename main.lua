-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.1.5 - LIGHT BYPASS]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.1.5
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.1.5", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI FULL AUTO BYPASS LIGHTING
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Full Otomatis v0.1.5", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local camera = workspace.CurrentCamera
            local vInput = game:GetService("VirtualInputManager")
            local lighting = game:GetService("Lighting")
            local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            
            -- Pengunci anti-auto-clicker hantu
            local lagiProsesKlik = false
            
            -- Fungsi menembak 2 klik berurutan tepat sasaran
            local function eksekusiDuaKlikOtomatis()
                if lagiProsesKlik then return end
                lagiProsesKlik = true -- Kunci aktif!
                
                local screenWidth = camera.ViewportSize.X
                local screenHeight = camera.ViewportSize.Y
                
                -- Koordinat tombol hijau "Accept" kamu (60% lebar, 78% tinggi)
                local clickX = screenWidth * 0.60
                local clickY = screenHeight * 0.78
                
                -- [KLIK 1: TERIMA AJAKAN TRADE]
                vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                task.wait(0.05)
                vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                
                -- Jeda pendek 0.4 detik menunggu pop-up peringatan scam berganti di layar
                task.wait(0.4)
                
                -- [KLIK 2: TERIMA PERINGATAN SCAM / OKAY]
                vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                task.wait(0.05)
                vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
            end
            
            -- LOOP UTAMA PENGECEKAN SISTEM
            while _G.AutoAccept do
                pcall(function()
                    -- A. DETEKSI ATMOSFER LAYAR (Mendeteksi bayangan hitam pop-up Adopt Me)
                    -- Biasanya Adopt Me menurunkan kecerahan/mengubah tone saat pop-up penting muncul
                    local adaEfekDialog = lighting:FindFirstChild("ColorCorrection") or lighting.Ambient.R < 0.5
                    
                    -- B. CEK APAKAH SUDAH MASUK KE TAB TRADE UTAMA
                    local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI") or playerGui:FindFirstChild("Trade")
                    
                    -- [EKSEKUSI OTOMATIS GERBANG AWAL]
                    -- Jika atmosfer layar berubah menggelap dan kita belum masuk tab trade utama
                    if adaEfekDialog and not sedangTrade and not lagiProsesKlik then
                        task.wait(0.2) -- Jeda render pop-up surat kertas
                        eksekusiDuaKlikOtomatis()
                    end
                    
                    -- ======================================================
                    -- [BYPASS REMOTE TAHAP TENGAH & AKHIR]
                    -- ======================================================
                    -- Sisi ini berjalan aman 100% di background server tanpa klik layar
                    if sedangTrade and API then
                        if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                            API["TradeAPI/AcceptNegotiation"]:FireServer()
                        end
                        
                        task.wait(0.8)
                        
                        if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                            API["TradeAPI/ConfirmTrade"]:FireServer()
                        end
                    end
                    
                    -- RESET PENGUNCI JIKA TRANSAKSI SUDAH BERES DAN LAYAR NORMAL KEMBALI
                    if not sedangTrade and not adaEfekDialog then
                        lagiProsesKlik = false
                    end
                end)
                task.wait(0.4) -- Durasi scan berkala yang ramah baterai HP
            end
        end)
    end
end)
