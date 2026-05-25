-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.0.8 - SMART EVENT]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.0.8
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.0.8", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI TARGET UTK TOMBOL SPESIFIK
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

-- Fungsi pembantu untuk mensimulasikan klik asli pada objek tombol Roblox tanpa pakai koordinat layar
local function klikTombolRoblox(tombol)
    if tombol and tombol:IsA("TextButton") or tombol:IsA("ImageButton") then
        pcall(function()
            -- Metode 1: Mengaktifkan fungsi klik bawaan tombol secara internal
            tombol:Activate()
            
            -- Metode 2: Simulasi pemilihan via GuiService (Bypass paling aman untuk mobile)
            game:GetService("GuiService").SelectedObject = tombol
            task.wait(0.05)
            local vInput = game:GetService("VirtualInputManager")
            vInput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.05)
            vInput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            game:GetService("GuiService").SelectedObject = nil
        end)
    end
end

Section:NewToggle("Auto Accept Trade", "Status: Deteksi Tombol UI Langsung", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    
                    if playerGui then
                        -- Memindai seluruh UI yang sedang aktif di layar HP kamu
                        for _, obj in pairs(playerGui:GetDescendants()) do
                            if obj:IsA("TextButton") and obj.Visible and obj.AbsoluteSize.X > 0 then
                                
                                -- [KLIK 1: TOMBOL ACCEPT DI POP-UP AJAKAN TRADE]
                                -- Mencari tombol yang teksnya "Accept" atau namanya "AcceptButton" / "Accept"
                                if obj.Text == "Accept" or obj.Name == "Accept" then
                                    klikTombolRoblox(obj)
                                    task.wait(0.2) -- Jeda sangat singkat agar sistem memproses perpindahan UI
                                end
                                
                                -- [KLIK 2: TOMBOL PERINGATAN SCAM / OKAY]
                                -- Mencari tombol dialog peringatan dari Adopt Me yang biasanya bertuliskan "Okay" atau "Agree"
                                if obj.Text == "Okay" or obj.Name == "Okay" or obj.Text:lower():find("agree") then
                                    klikTombolRoblox(obj)
                                    task.wait(0.2)
                                end
                                
                            end
                        end
                        
                        -- ======================================================
                        -- [BYPASS REMOTE TAHAP TENGAH & AKHIR]
                        -- ======================================================
                        -- Ini tetap dipertahankan karena berjalan di latar belakang (tanpa menyentuh/mengklik layar)
                        if API then
                            if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                                API["TradeAPI/AcceptNegotiation"]:FireServer()
                            end
                            
                            task.wait(0.5)
                            
                            if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                                API["TradeAPI/ConfirmTrade"]:FireServer()
                            end
                        end
                    end
                end)
                task.wait(0.3) -- Kecepatan scanning UI
            end
        end)
    end
end)
