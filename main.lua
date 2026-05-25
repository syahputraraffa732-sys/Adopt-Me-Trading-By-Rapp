-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.0.2
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
-- Judul window v0.0.2
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.0.2", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI FULL BYPASS
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Total Bypass di Semua Tahap", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    
                    if API and playerGui then
                        -- ==========================================
                        -- [TAHAP 1: Menekan Pop-up Ajakan Awal secara Otomatis]
                        -- ==========================================
                        -- Kita memindai PlayerGui untuk mencari tombol "Accept" di Dialog awal
                        for _, obj in pairs(playerGui:GetDescendants()) do
                            if obj:IsA("TextButton") and obj.Visible and obj.AbsoluteSize.X > 0 then
                                -- Mencari tombol dengan nama "Accept" atau teks "Accept" (Dialog Adopt Me)
                                if obj.Name == "Accept" or obj.Text:lower():find("accept") then
                                    -- Memperintahkan sistem GuiService untuk memilih objek ini secara instan
                                    game:GetService("GuiService").SelectedObject = obj
                                    task.wait(0.05)
                                    -- Mensimulasikan penekanan tombol enter (Klik) pada objek yang terpilih
                                    local virtualInput = game:GetService("VirtualInputManager")
                                    virtualInput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                    task.wait(0.05)
                                    virtualInput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                    
                                    -- Reset seleksi
                                    game:GetService("GuiService").SelectedObject = nil
                                end
                            end
                        end
                        
                        -- ==========================================
                        -- [TAHAP 2 & 3: Bypass Remote untuk Konfirmasi Dalam Trade]
                        -- ==========================================
                        -- Jeda singkat agar tidak tabrakan dengan deteksi UI di atas
                        task.wait(0.5)
                        
                        -- Menembak Remote Konfirmasi Pertama (setelah pet dimasukkan)
                        if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                            API["TradeAPI/AcceptNegotiation"]:FireServer()
                        end
                        
                        -- Jeda 1 detik sebelum konfirmasi final
                        task.wait(1)
                        
                        -- Menembak Remote Konfirmasi Akhir (Hitung mundur 15 detik)
                        if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                            API["TradeAPI/ConfirmTrade"]:FireServer()
                        end
                    end
                end)
                task.wait(0.5) -- Cek berkala setiap 0.5 detik
            end
        end)
    end
end)
