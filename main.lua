-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.1.0 - DOUBLE TAP]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.1.0
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.1.0", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - VERSI SMART DOUBLE TAP
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Status: Mode 2x Ketukan Berurutan", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local camera = workspace.CurrentCamera
            local vInput = game:GetService("VirtualInputManager")
            
            -- Pengunci agar tidak ngeklik terus-menerus (Anti Auto-Clicker)
            local prosesKlikSelesai = false
            
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    
                    if playerGui then
                        -- Cek keberadaan pop-up ajakan awal di layar
                        local adaPopupAwal = false
                        for _, obj in pairs(playerGui:GetDescendants()) do
                            if obj:IsA("TextLabel") and obj.Visible and obj.Text:lower():find("trade request") then
                                adaPopupAwal = true
                                break
                            end
                        end
                        
                        -- JIKA POP-UP MUNCUL DAN SCRIPT BELUM MELAKUKAN PROSES KLIK
                        if adaPopupAwal and not prosesKlikSelesai then
                            prosesKlikSelesai = true -- Langsung kunci sistem!
                            
                            local screenWidth = camera.ViewportSize.X
                            local screenHeight = camera.ViewportSize.Y
                            
                            -- Koordinat tombol hijau "Accept" kamu (60% lebar, 78% tinggi)
                            local clickX = screenWidth * 0.60
                            local clickY = screenHeight * 0.78
                            
                            -- [KLIK 1: TERIMA AJAKAN TRADE]
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                            task.wait(0.05)
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                            
                            -- Jeda setengah detik menunggu pop-up scam muncul menggantikan pop-up awal
                            task.wait(0.5)
                            
                            -- [KLIK 2: TERIMA PERINGATAN SCAM / OKAY]
                            -- Mengetuk area tengah/bawah lagi untuk bypass peringatan scam
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                            task.wait(0.05)
                            vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                        end
                        
                        -- RESET PENGUNCI HANYA JIKA KEDUA PLAYER SUDAH TIDAK DALAM PROSES TRADE
                        -- Kita cek jika folder 'TradeApp' atau jendela transaksi sudah menutup total, baru siap untuk trade berikutnya
                        local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI")
                        if not adaPopupAwal and not sedangTrade then
                            prosesKlikSelesai = false
                        end
                        
                        -- ======================================================
                        -- [BYPASS REMOTE TAHAP TENGAH & AKHIR]
                        -- ======================================================
                        -- Bagian ini murni berjalan di background server, aman dari tabrakan layar!
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
                task.wait(0.4)
            end
        end)
    end
end)
