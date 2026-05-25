-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.0.4 - MOBILE BYPASS]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.0.4
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.0.4", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI DETEKSI PLAYER
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Perbaikan Deteksi Gerbang Awal", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local localPlayer = game:GetService("Players").LocalPlayer
            
            while _G.AutoAccept do
                pcall(function()
                    if API then
                        -- ======================================================
                        -- [TAHAP 1: Deteksi Semua Player di Server untuk Gerbang Awal]
                        -- ======================================================
                        -- Kita looping semua player aktif untuk menembak Remote Function secara massal
                        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                            if player ~= localPlayer then
                                -- Menembak remote secara langsung menggunakan nama player yang ada di server
                                -- Jika player tersebut memang sedang mengajak kita trade, server akan langsung menerimanya
                                task.spawn(function()
                                    pcall(function()
                                        API["TradeAPI/AcceptOrDeclineTradeRequest"]:InvokeServer(player.Name, true)
                                    end)
                                end)
                            end
                        end
                        
                        -- ======================================================
                        -- [TAHAP 2 & 3: Bypass Konfirmasi Dalam Trade - Sudah Berhasil]
                        -- ======================================================
                        task.wait(0.5)
                        
                        -- Menembak Remote Konfirmasi Tahap 1
                        if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                            API["TradeAPI/AcceptNegotiation"]:FireServer()
                        end
                        
                        -- Jeda menuju tahap final
                        task.wait(1)
                        
                        -- Menembak Remote Konfirmasi Akhir (Hitung mundur)
                        if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                            API["TradeAPI/ConfirmTrade"]:FireServer()
                        end
                    end
                end)
                task.wait(0.8) -- Cek berkala agar tidak lag di HP
            end
        end)
    end
end)
