-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.0.9 - TWO-STEP EVENT]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.0.9
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.0.9", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI 2 KLIK TEPAT TARGET
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

-- Fungsi klik yang aman langsung menyasar elemen GUI Roblox
local function tekanTombolRoblox(tombol)
    if tombol then
        pcall(function()
            -- Klik internal via engine Roblox
            tombol:Activate()
            
            -- Jalur alternatif simulasi klik keyboard/enter via GuiService agar sinkron di mobile
            game:GetService("GuiService").SelectedObject = tombol
            task.wait(0.02)
            local vInput = game:GetService("VirtualInputManager")
            vInput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.02)
            vInput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            game:GetService("GuiService").SelectedObject = nil
        end)
    end
end

Section:NewToggle("Auto Accept Trade", "Status: Deteksi 2-Tahap Gerbang Awal", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    
                    if playerGui then
                        -- Loop mencari tombol spesifik di seluruh PlayerGui
                        for _, obj in pairs(playerGui:GetDescendants()) do
                            if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Visible and obj.AbsoluteSize.X > 0 then
                                local namaObjek = obj.Name:lower()
                                local teksObjek = ""
                                
                                if obj:IsA("TextButton") then
                                    teksObjek = obj.Text:lower()
                                end
                                
                                -- [KLIK 1: MENERIMA POP-UP AJAKAN TRADE AWAL]
                                -- Mencari tombol hijau bertuliskan Accept / bernama Accept
                                if namaObjek == "accept" or namaObjek == "acceptbutton" or teksObjek:find("accept") or teksObjek:find("terima") then
                                    tekanTombolRoblox(obj)
                                    task.wait(0.3) -- Kasih jeda sedikit agar sistem memproses pop-up berikutnya
                                end
                                
                                -- [KLIK 2: MENERIMA PERINGATAN SCAM / POP-UP KONFIRMASI TAMBAHAN]
                                -- Mencari tombol konfirmasi seperti "Okay", "Agree", "Confirm", atau tombol utama bermotif hijau
                                if namaObjek == "okay" or namaObjek == "confirm" or teksObjek:find("okay") or teksObjek:find("agree") or teksObjek:find("confirm") then
                                    tekanTombolRoblox(obj)
                                    task.wait(0.3)
                                end
                            end
                        end
                        
                        -- ======================================================
                        -- [BYPASS REMOTE TAHAP TENGAH & AKHIR]
                        -- ======================================================
                        -- Berjalan aman di background tanpa mengacaukan layar trade utama kamu
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
                task.wait(0.4) -- Deteksi ulang berkala
            end
        end)
    end
end)
