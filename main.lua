-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.0.3 - MOBILE BYPASS]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.0.3
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
-- Judul window v0.0.3 agar kita bisa cek cache
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.0.3", "DarkTheme")

-- 2. TOMBOL MINIMIZE HP (BULAT MERAH) - Berfungsi 100%
local ScreenGui = Instance.new("ScreenGui")
local MinButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "RappMinimizeSystem"

MinButton.Parent = ScreenGui
MinButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50) -- Merah
MinButton.Position = UDim2.new(0, 15, 0, 15) -- Pojok kiri atas
MinButton.Size = UDim2.new(0, 50, 0, 50) -- Ukuran bulat pas di mobile
MinButton.Text = "R"
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.Font = Enum.Font.SourceSansBold
MinButton.TextSize = 22

UICorner.CornerRadius = UDim.new(1, 0) -- Membuatnya bulat sempurna
UICorner.Parent = MinButton

MinButton.MouseButton1Click:Connect(function()
    KavoLib:ToggleUI()
end)

-- 3. MENU AUTOMATION TRADE - REKAYASA SISTEM TRADE API
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

-- Variabel internal untuk menyimpan data player pengajak
local targetPlayerName = nil

Section:NewToggle("Auto Accept Trade", "Bypass server untuk konfirmasi trade", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    
                    if API and playerGui then
                        -- ======================================================
                        -- [TAHAP 1: Menangkap Nama Player Pengajak Trade dari Pop-up]
                        -- ======================================================
                        -- Kita scan PlayerGui secara menyeluruh untuk mencari Label Teks Nama
                        for _, obj in pairs(playerGui:GetDescendants()) do
                            if obj:IsA("TextLabel") and obj.Visible and obj.AbsoluteSize.X > 0 then
                                local text = obj.Text:lower()
                                
                                -- Mencari kata kunci "sent you a trade request"
                                if text:find("trade request") and text:find("sent") then
                                    -- Menarik nama player yang ada di bagian atas pop-up tersebut
                                    local lines = string.split(obj.Text, "\n")
                                    if #lines > 0 then
                                        -- Mengambil nama dari baris pertama teks, lalu bersihkan dari whitespace
                                        targetPlayerName = string.gsub(lines[1], "%s+", "")
                                    end
                                end
                            end
                        end
                        
                        -- ======================================================
                        -- [TAHAP 2: Mengirim Data Valid ke Server untuk Bypass Tombol Accept]
                        -- ======================================================
                        -- Jika nama player sudah ditangkap dari pop-up
                        if targetPlayerName and API:FindFirstChild("TradeAPI/AcceptOrDeclineTradeRequest") then
                            -- Menembak RemoteFunction dengan mengirimkan argumen data target player-nya!
                            local success = API["TradeAPI/AcceptOrDeclineTradeRequest"]:InvokeServer(targetPlayerName, true)
                            -- Jika sukses, reset variabel agar siap untuk trade berikutnya
                            if success then
                                targetPlayerName = nil
                                -- Jeda singkat biar jendela trade terbuka dulu
                                task.wait(1)
                            end
                        end
                        
                        -- ======================================================
                        -- [TAHAP 3 & 4: Bypass Konfirmasi Dalam Trade - 100% Berhasil]
                        -- ======================================================
                        -- Menembak Remote Konfirmasi Pertama (setelah item dimasukkan)
                        if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                            API["TradeAPI/AcceptNegotiation"]:FireServer()
                        end
                        
                        -- Jeda sebelum konfirmasi final
                        task.wait(1)
                        
                        -- Menembak Remote Konfirmasi Akhir (Hitung mundur 15 detik)
                        if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                            API["TradeAPI/ConfirmTrade"]:FireServer()
                        end
                    end
                end)
                task.wait(1) -- Jeda pemindaian setiap 1 detik
            end
        end)
    end
end)
