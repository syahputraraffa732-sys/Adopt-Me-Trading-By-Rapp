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

-- 3. MENU AUTOMATION TRADE VIA REMOTE BYPASS
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Bypass server langsung untuk terima trade", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            
            while _G.AutoAccept do
                pcall(function()
                    if API then
                        -- 1. Menerima ajakan trade di awal secara paksa
                        if API:FindFirstChild("TradeAPI/AcceptOrDeclineTradeRequest") then
                            API["TradeAPI/AcceptOrDeclineTradeRequest"]:InvokeServer()
                        end
                        
                        -- Jeda 1 detik biar sistem gamenya gak bingung
                        task.wait(1)
                        
                        -- 2. Menembak Remote Konfirmasi Pertama
                        if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                            API["TradeAPI/AcceptNegotiation"]:FireServer()
                        end
                        
                        -- Jeda lagi sebelum konfirmasi final
                        task.wait(1)
                        
                        -- 3. Menembak Remote Konfirmasi Akhir (Hitung mundur 15 detik)
                        if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                            API["TradeAPI/ConfirmTrade"]:FireServer()
                        end
                    end
                end)
                task.wait(1) -- Cek dan tembak ulang setiap 1 detik jika trade masih berlangsung
            end
        end)
    end
end)
