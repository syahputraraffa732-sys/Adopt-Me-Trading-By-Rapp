-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.2.1 - TARGETED STRIKE]
-- =========================================================================

-- 1. SETUP UI UTAMA 
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.2.1", "DarkTheme")

-- 2. TOMBOL MINIMIZE HP
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

-- 3. MENU AUTOMATION TRADE - TARGETED STRIKE (DEX PATH)
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

-- Fungsi untuk mengeklik tepat di tengah sebuah objek UI
local function klikTepatDiObjek(guiObj)
    if guiObj and guiObj.Visible then
        local vInput = game:GetService("VirtualInputManager")
        local pos = guiObj.AbsolutePosition
        local size = guiObj.AbsoluteSize
        
        -- Hitung titik tengah dari objek tersebut
        local centerX = pos.X + (size.X / 2)
        local centerY = pos.Y + (size.Y / 2)
        
        -- Eksekusi klik simulasi persis di koordinat objek + offset toolbar atas (biasanya + 36px)
        vInput:SendMouseButtonEvent(centerX, centerY + 36, 0, true, game, 0)
        task.wait(0.05)
        vInput:SendMouseButtonEvent(centerX, centerY + 36, 0, false, game, 0)
    end
end

Section:NewToggle("Auto Accept (Targeted Strike)", "Status: Mendeteksi trade_requests", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local localPlayer = game:GetService("Players").LocalPlayer
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = localPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        
                        -- Cek apakah tab trade utama sudah terbuka
                        local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI") or playerGui:FindFirstChild("Trade")
                        
                        -- ======================================================
                        -- [TAHAP 1: MENCARI DAN MENG-KLIK POP-UP AWAL & SCAM]
                        -- ======================================================
                        if not sedangTrade then
                            
                            -- Misi Utama: Cari folder hasil temuan Dex (trade_requests)
                            for _, obj in pairs(playerGui:GetDescendants()) do
                                
                                -- Jika ketemu wadah 'trade_requests'
                                if obj.Name == "trade_requests" and obj.Visible then
                                    -- Cari tombol hijau/accept di dalamnya
                                    for _, btn in pairs(obj:GetDescendants()) do
                                        if btn:IsA("ImageButton") or btn:IsA("TextButton") then
                                            -- Biasanya tombol Accept Adopt Me punya warna hijau (G > R & B)
                                            local warna = btn.BackgroundColor3
                                            if warna.G > warna.R and warna.G > warna.B then
                                                klikTepatDiObjek(btn)
                                                task.wait(0.5) -- Jeda agar klik tidak tumpang tindih
                                            end
                                        end
                                    end
                                end
                                
                                -- Bypass untuk peringatan SCAM (Scam warning popup)
                                -- Peringatan scam biasanya menggunakan tombol teks berbunyi 'Okay', 'I Understand', atau 'Accept'
                                if (obj:IsA("TextButton") or obj:IsA("TextLabel")) and obj.Visible then
                                    local teks = string.lower(obj.Text or "")
                                    if teks:find("okay") or teks:find("understand") or teks:find("accept") then
                                        -- Jika targetnya adalah TextLabel (bukan tombol), kita klik parent-nya (tombol aslinya)
                                        local targetKlik = obj:IsA("TextButton") and obj or obj.Parent
                                        klikTepatDiObjek(targetKlik)
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                        
                        -- ======================================================
                        -- [TAHAP 2: BYPASS TAHAP TENGAH & AKHIR VIA SERVER]
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
                        
                    end
                end)
                task.wait(0.3) -- Scanning ringan setiap 0.3 detik
            end
        end)
    end
end)
