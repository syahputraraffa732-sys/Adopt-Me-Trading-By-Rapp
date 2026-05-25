-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.1.7 - STATE SYSTEM]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.1.7
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.1.7", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - LOGIKA STATE MANAGEMENT (SARAN CHATGPT)
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

-- Variabel State untuk mengontrol langkah klik agar tidak jadi auto-clicker liar
local tradeState = {
    step = 0,      -- 0 = Menunggu trade, 1 = Menunggu scam pop-up, 2 = Locked (masuk trade utama)
    locked = false  -- Pengunci total klik layar
}

Section:NewToggle("Auto Accept Trade", "Status: Polling Ringan + State Lock", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local camera = workspace.CurrentCamera
            local vInput = game:GetService("VirtualInputManager")
            local player = game:GetService("Players").LocalPlayer
            
            -- Reset state saat awal dinyalakan
            tradeState.step = 0
            tradeState.locked = false
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = player:FindFirstChild("PlayerGui")
                    local coreGui = game:GetService("CoreGui")
                    
                    if playerGui then
                        -- Ambil ukuran resolusi layar HP kamu
                        local screenWidth = camera.ViewportSize.X
                        local screenHeight = camera.ViewportSize.Y
                        local clickX = screenWidth * 0.60
                        local clickY = screenHeight * 0.78
                        
                        -- Cek apakah tab trade utama (tempat naruh pet) sudah terbuka
                        local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI") or playerGui:FindFirstChild("Trade")
                        
                        -- JIKA SUDAH MASUK TRADE UTAMA -> KUNCI MATI SEMUA PROSES KLIK LAYAR
                        if sedangTrade then
                            tradeState.step = 2
                            tradeState.locked = true
                        end
                        
                        -- ======================================================
                        -- FLOW AUTOMATION GERBANG AWAL (ANTI-SPAM)
                        -- ======================================================
                        if not tradeState.locked then
                            
                            -- [STEP 0: DETEKSI AJAKAN TRADE AWAL]
                            if tradeState.step == 0 then
                                local ketemuTradeRequest = false
                                -- Scan menyeluruh termasuk mengantisipasi nested container (saran ChatGPT)
                                for _, obj in pairs(playerGui:GetDescendants()) do
                                    if obj:IsA("TextLabel") and obj.Visible and obj.Text:lower():find("trade request") then
                                        ketemuTradeRequest = true
                                        break
                                    end
                                end
                                
                                if ketemuTradeRequest then
                                    tradeState.step = 1 -- Naikkan ke step 1 agar tidak bisa mengeklik area ini lagi
                                    
                                    -- Eksekusi KLIK 1 (Terima Ajakan)
                                    vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                                    task.wait(0.05)
                                    vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                                    
                                    task.wait(0.5) -- Jeda setengah detik sesuai flow game
                                end
                                
                            -- [STEP 1: DETEKSI PERINGATAN SCAM / POP-UP KEDUA]
                            elseif tradeState.step == 1 then
                                -- Langsung eksekusi Klik 2 untuk bypass scam warning yang muncul menggantikan pop-up awal
                                vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                                task.wait(0.05)
                                vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                                
                                tradeState.step = 2
                                tradeState.locked = true -- SISTEM KLIK DIKUNCI MATI TOTAL!
                            end
                        end
                        
                        -- ======================================================
                        -- [BYPASS REMOTE TAHAP TENGAH & AKHIR VIA SERVER]
                        -- ======================================================
                        if sedangTrade and API then
                            if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                                API["TradeAPI/AcceptNegotiation"]:FireServer()
                            end
                            
                            task.wait(0.8)
                            
                            if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                                API["TradeAPI/ConfirmTrade"]:FireServer()
                            end
                        end
                        
                        -- RESET STATE JIKA TRANSAKSI SUDAH SELESAI / BATAL (KEMBALI KE LOBI)
                        if not sedangTrade and tradeState.locked then
                            -- Pastikan pop-up trade request sudah benar-benar hilang dari layar sebelum reset
                            local masihAdaPopup = false
                            for _, obj in pairs(playerGui:GetDescendants()) do
                                if obj:IsA("TextLabel") and obj.Visible and obj.Text:lower():find("trade request") then
                                    masihAdaPopup = true
                                    break
                                end
                            end
                            
                            if not masihAdaPopup then
                                tradeState.step = 0
                                tradeState.locked = false
                            end
                        end
                        
                    end
                end)
                task.wait(0.2) -- Polling ringan berkala (ramah baterai HP dan anti-lag)
            end
        end)
    end
end)
