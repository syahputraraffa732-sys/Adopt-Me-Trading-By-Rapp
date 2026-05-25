-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.2.2 - REMOTE STRIKE]
-- =========================================================================

-- 1. SETUP UI UTAMA
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.2.2", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VIA DATA REMOTESPY SIMPLESPY
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept (Remote Spy)", "Status: Menunggu Ajakan Trade", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            
            -- Pemicu Utama: Kita pantau sinyal dari server kalau ada trade masuk
            local koneksiSinyal = nil
            if API and API:FindFirstChild("TradeAPI/OnTradeRequestReceived") then
                koneksiSinyal = API["TradeAPI/OnTradeRequestReceived"].OnClientEvent:Connect(function(pemainYgNgajak)
                    -- Pastikan toggle menyala dan objek pemain yang mengajak itu valid
                    if _G.AutoAccept and pemainYgNgajak then
                        pcall(function()
                            -- [DATA DARI SIMPLESPY LU]
                            -- Langsung tembak remote server untuk menerima trade dari pemain tersebut!
                            if API:FindFirstChild("TradeAPI/AcceptOrDeclineTradeRequest") then
                                API["TradeAPI/AcceptOrDeclineTradeRequest"]:FireServer(pemainYgNgajak, true)
                                print("Berhasil memotong UI! Menerima trade dari: " .. tostring(pemainYgNgajak))
                            end
                        end)
                    end
                end)
            end
            
            -- LOOP UNTUK CONCURRENT ACCEPT DI TAHAP NEGOSIASI DAN KONFIRMASI AKHIR
            while _G.AutoAccept do
                pcall(function()
                    local localPlayer = game:GetService("Players").LocalPlayer
                    local playerGui = localPlayer:FindFirstChild("PlayerGui")
                    
                    if playerGui and API then
                        -- Cek apakah jendela transaksi utama sudah terbuka di layar
                        local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI") or playerGui:FindFirstChild("Trade")
                        
                        if sedangTrade then
                            -- 1. Terima tahap penawaran barang (Negotiation)
                            if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                                API["TradeAPI/AcceptNegotiation"]:FireServer()
                            end
                            
                            task.wait(0.5)
                            
                            -- 2. Terima tahap verifikasi akhir (Confirm / Penghitung Waktu Mundur)
                            if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                                API["TradeAPI/ConfirmTrade"]:FireServer()
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
            
            -- Matikan pemantau sinyal jika toggle dimatikan
            if koneksiSinyal then koneksiSinyal:Disconnect() end
        end)
    end
end)
