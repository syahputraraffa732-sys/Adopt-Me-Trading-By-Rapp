-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.1.6 - SMART DEBOUNCE]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.1.6
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.1.6", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI ANTI AUTO-CLICKER LIAR
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Mode Pengunci Jeda Akurat", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local camera = workspace.CurrentCamera
            local vInput = game:GetService("VirtualInputManager")
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    
                    if playerGui then
                        -- Cek apakah kita sudah sukses berada di dalam tab trade utama (tempat naruh pet)
                        local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI") or playerGui:FindFirstChild("Trade")
                        
                        -- [EKSEKUSI GERBANG AWAL]
                        -- Jika KITA BELUM masuk ke tab trade utama, lepaskan 2 ketukan berurutan dengan jeda aman
                        if not sedangTrade then
                            local screenWidth = camera.ViewportSize.X
                            local screenHeight = camera.ViewportSize.Y
                            
                            -- Koordinat tombol hijau "Accept" kamu (60% lebar, 78% tinggi)
                            local clickX = screenWidth * 0.60
                            local clickY = screenHeight * 0.78
                            
                            -- Klik 1: Menerima ajakan trade awal
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                            task.wait(0.05)
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                            
                            -- Jeda tenang setengah detik menunggu pop-up scam muncul
                            task.wait(0.5)
                            
                            -- Klik 2: Menerima peringatan scam / Okay
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                            task.wait(0.05)
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                            
                            -- [ANTI AUTO-CLICKER] Script dipaksa tidur 3 detik sebelum boleh mengeklik lagi
                            -- Ini mencegah script melakukan spam berlebihan yang bisa merusak UI lain
                            task.wait(3.0)
                        end
                        
                        -- ======================================================
                        -- [BYPASS REMOTE TAHAP TENGAH & AKHIR]
                        -- ======================================================
                        -- Jika sudah masuk trade, fungsi klik di atas MATI 100%, sisa trade diproses via data server
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
                task.wait(0.5) -- Pengecekan status berkala
            end
        end)
    end
end)
