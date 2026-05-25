-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.2.3 - INVOKE FIX]
-- =========================================================================

-- 1. SETUP UI UTAMA
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.2.3", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - MENEMBAK REMOTE FUNCTION DENGAN AKURAT
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept (Remote Invoke)", "Status: Menunggu Ajakan Trade", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            
            -- Pemicu Utama: Kita pantau sinyal OnTradeRequestReceived dari server
            local koneksiSinyal = nil
            if API and API:FindFirstChild("TradeAPI/OnTradeRequestReceived") then
                koneksiSinyal = API["TradeAPI/OnTradeRequestReceived"].OnClientEvent:Connect(function(pemainYgNgajak)
                    -- Pastikan toggle menyala dan objek pemain yang mengajak trade terdeteksi
                    if _G.AutoAccept and pemainYgNgajak then
                        pcall(function()
                            -- [DATA AKURAT DARI SIMPLESPY LU]
                            -- Menggunakan InvokeServer sesuai dengan struktur sistem Adopt Me aslinya!
                            if API:FindFirstChild("TradeAPI/AcceptOrDeclineTradeRequest") then
                                API["TradeAPI/AcceptOrDeclineTradeRequest"]:InvokeServer(pemainYgNgajak, true)
                                print("Sukses melakukan bypass gerbang awal untuk pemain: " .. tostring(pemainYgNgajak))
                            end
                        end)
                    end
                end)
            end
            
            -- LOOP UTAMA UNTUK BYPASS TAHAP TENGAH (NEGOSIASI) DAN AKHIR (KONFIRMASI LAMA)
            while _G.AutoAccept do
                pcall(function()
                    local localPlayer = game:GetService("Players").LocalPlayer
                    local playerGui = localPlayer:FindFirstChild("PlayerGui")
                    
                    if playerGui and API then
                        -- Cek status apakah tab transaksi utama sudah aktif di HP kamu
                        local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI") or playerGui:FindFirstChild("Trade")
                        
                        if sedangTrade then
                            -- 1. Jalankan konfirmasi penawaran item pengorbanan (Negotiation)
                            if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                                API["TradeAPI/AcceptNegotiation"]:FireServer()
                            end
                            
                            task.wait(0.5)
                            
                            -- 2. Jalankan konfirmasi penghitung waktu mundur 15 detik terakhir (Confirm)
                            if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                                API["TradeAPI/ConfirmTrade"]:FireServer()
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
            
            -- Putus jalur pemantauan sinyal jika fitur dinonaktifkan
            if koneksiSinyal then koneksiSinyal:Disconnect() end
        end)
    end
end)
