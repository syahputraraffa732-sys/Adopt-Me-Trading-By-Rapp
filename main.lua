-- =========================================================================
-- [SCRIPT ADOPT ME AUTO ACCEPT TRADE BY RAPP - VERSI v0.1.8 - REVISI FIX]
-- =========================================================================

-- 1. SETUP UI UTAMA DENGAN VERSI TERBARU v0.1.8
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp | v0.1.8", "DarkTheme")

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

-- 3. MENU AUTOMATION TRADE - BYPASS VIA SINYAL SERVER ADOPT ME
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false
local sistemSedangMengunci = false

Section:NewToggle("Auto Accept Trade", "Status: Deteksi Sinyal Event Server", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            local API = game:GetService("ReplicatedStorage"):WaitForChild("API", 5)
            local camera = workspace.CurrentCamera
            local vInput = game:GetService("VirtualInputManager")
            local localPlayer = game:GetService("Players").LocalPlayer
            
            sistemSedangMengunci = false
            
            -- Fungsi menembak 2 klik berurutan tepat pada koordinat tombol hijau
            local function eksekusiKlikGerbangAwal()
                if sistemSedangMengunci then return end
                sistemSedangMengunci = true -- Kunci dinyalakan seketika!
                
                local screenWidth = camera.ViewportSize.X
                local screenHeight = camera.ViewportSize.Y
                local clickX = screenWidth * 0.60
                local clickY = screenHeight * 0.78
                
                -- [KLIK 1: TERIMA AJAKAN TRADE]
                vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                task.wait(0.05)
                vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                
                -- Jeda pendek 0.4 detik menunggu pop-up peringatan scam berganti di layar
                task.wait(0.4)
                
                -- [KLIK 2: TERIMA PERINGATAN SCAM / OKAY]
                vInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                task.wait(0.05)
                vInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
            end
            
            -- [SISTEM UTAMA] Memantau sinyal ajakan trade yang masuk dari server ke HP kamu
            local koneksiSinyal = nil
            if API and API:FindFirstChild("TradeAPI/OnTradeRequestReceived") then
                koneksiSinyal = API["TradeAPI/OnTradeRequestReceived"].OnClientEvent:Connect(function(pemainYgNgajak)
                    if _G.AutoAccept and not sistemSedangMengunci then
                        task.wait(0.2) -- Jeda render animasi pop-up kertas surat
                        eksekusiKlikGerbangAwal()
                    end
                end)
            end
            
            -- LOOP UTAMA UNTUK BYPASS TAHAP TENGAH & AKHIR
            while _G.AutoAccept do
                pcall(function()
                    local playerGui = localPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        local sedangTrade = playerGui:FindFirstChild("TradeApp") or playerGui:FindFirstChild("DialogAPI") or playerGui:FindFirstChild("Trade")
                        
                        -- Jika masuk tab trade utama, Remote langsung konfirmasi otomatis via server tanpa klik layar
                        if sedangTrade and API then
                            sistemSedangMengunci = true -- Tetap kunci klik layar agar tombol Decline aman!
                            
                            if API:FindFirstChild("TradeAPI/AcceptNegotiation") then
                                API["TradeAPI/AcceptNegotiation"]:FireServer()
                            end
                            
                            task.wait(0.8)
                            
                            if API:FindFirstChild("TradeAPI/ConfirmTrade") then
                                API["TradeAPI/ConfirmTrade"]:FireServer()
                            end
                        end
                        
                        -- RESET PENGUNCI JIKA SUDAH KELUAR DARI TRADE (KEMBALI KE LOBI)
                        if not sedangTrade and sistemSedangMengunci then
                            -- Beri jeda 2 detik sebelum sistem siap menerima ajakan trade berikutnya
                            task.wait(2.0)
                            sistemSedangMengunci = false
                        end
                    end
                end)
                task.wait(0.5)
            end
            
            -- Putus koneksi sinyal jika toggle dimatikan
            if koneksiSinyal then koneksiSinyal:Disconnect() end
        end)
    end
end)
