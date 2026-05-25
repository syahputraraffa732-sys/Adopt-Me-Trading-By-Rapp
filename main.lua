-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.2.0 - OVERDRIVE]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.2.0
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.2.0 OVERDRIVE", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - BRUTE-FORCE GHOST PROTOCOL
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept (Overdrive)", "Status: Brute-Force Aktif", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local camera = workspace.CurrentCamera
            local vInput = game:GetService("VirtualInputManager")
            
            while _G.AutoAccept do
                -- Gunakan pcall agar script kebal dari error pemblokiran game
                pcall(function()
                    local screenWidth = camera.ViewportSize.X
                    local screenHeight = camera.ViewportSize.Y
                    
                    -- Koordinat pasti dari tombol hijau pop-up (60% Lebar, 78% Tinggi)
                    local clickX = screenWidth * 0.60
                    local clickY = screenHeight * 0.78
                    
                    -- [AKSI 1: TABRAK LAYAR BUTA]
                    -- Terus mengetuk area Accept. Jika koordinat ini mengenai area hijau di tab trade utama, itu bonus!
                    vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                    task.wait(0.05)
                    vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                    
                    -- [AKSI 2: TABRAK SERVER BUTA]
                    -- Memaksa server memproses konfirmasi tahap tengah dan akhir tanpa peduli UI
                    if API then
                        if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                            API["TradeAPI/AcceptNegotiation"]:FireServer()
                        end
                        
                        -- Jeda sangat singkat antara dua remote
                        task.wait(0.3)
                        
                        if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                            API["TradeAPI/ConfirmTrade"]:FireServer()
                        end
                    end
                end)
                
                -- Jeda 1.5 detik: Menjaga performa perangkat agar tidak lag, tapi cukup cepat untuk melibas pop-up
                task.wait(1.5)
            end
        end)
    end
end)
