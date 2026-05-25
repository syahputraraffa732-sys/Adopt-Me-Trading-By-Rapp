-- 1. SETUP UI UTAMA (KAVO LIBRARY)
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

-- Fungsi bantu untuk mensimulasikan klik jari pada tombol UI di HP
local function klikTombolMobile(tombol)
    if tombol and tombol:IsA("TextButton") and tombol.AbsoluteSize.X > 0 then
        local vInput = game:GetService("VirtualInputManager")
        -- Menghitung titik tengah tombol secara akurat di layar HP
        local posX = tombol.AbsolutePosition.X + (tombol.AbsoluteSize.X / 2)
        local posY = tombol.AbsolutePosition.Y + (tombol.AbsoluteSize.Y / 2) + 36 -- +36 untuk kompensasi top bar Roblox
        
        -- Simulasi ketukan jari (Touch/Click)
        vInput:SendMouseButtonEvent(posX, posY, 0, true, game, 0)
        task.wait(0.05)
        vInput:SendMouseButtonEvent(posX, posY, 0, false, game, 0)
    end
end

Section:NewToggle("Auto Accept Trade", "Klik otomatis semua tombol Accept", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            while _G.AutoAccept do
                pcall(function()
                    local localPlayer = game:GetService("Players").LocalPlayer
                    local playerGui = localPlayer:FindFirstChild("PlayerGui")
                    
                    if playerGui then
                        -- Metode 1: Mencari Dialog Ajakan Trade Awal (Pop-up "X mengajak kamu trade")
                        for _, obj in pairs(playerGui:GetDescendants()) do
                            if obj:IsA("TextButton") and obj.Visible then
                                local namaTombol = obj.Name:lower()
                                local teksTombol = obj.Text:lower()
                                
                                -- Deteksi tombol terima ajakan di awal
                                if namaTombol == "acceptbutton" or teksTombol:find("accept") or teksTombol:find("terima") then
                                    klikTombolMobile(obj)
                                end
                            end
                        end
                        
                        -- Metode 2: Mencari Jendela Transaksi Utama (Tempat pasang pet)
                        -- Kita scan folder 'Dialogs' atau 'Trade' bawaan UI Adopt Me
                        local dialogs = playerGui:FindFirstChild("DialogAPI") or playerGui:FindFirstChild("TradeApp")
                        if dialogs then
                            for _, btn in pairs(dialogs:GetDescendants()) do
                                if btn:IsA("TextButton") and btn.Visible then
                                    -- Mencari tombol konfirmasi hijau ("Accept" / "Confirm")
                                    if btn.Name == "Accept" or btn.Name == "Confirm" or btn.Text:lower():find("accept") then
                                        klikTombolMobile(btn)
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.3) -- Pengecekan cepat setiap 0.3 detik sekali
            end
        end)
    end
end)
