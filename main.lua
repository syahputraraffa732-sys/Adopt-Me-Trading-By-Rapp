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

-- Fungsi alternatif menggunakan VirtualUser untuk menyimulasikan klik langsung pada koordinat tombol
local function klikTombolSistem(tombol)
    if tombol and tombol:IsA("TextButton") and tombol.AbsoluteSize.X > 0 then
        pcall(function()
            -- Menghitung titik tengah posisi tombol di layar HP
            local posX = tombol.AbsolutePosition.X + (tombol.AbsoluteSize.X / 2)
            local posY = tombol.AbsolutePosition.Y + (tombol.AbsoluteSize.Y / 2) + 36 -- Offset topbar Roblox
            
            -- Menggunakan VirtualUser untuk melakukan klik/ketukan pada koordinat tersebut
            local virtualUser = game:GetService("VirtualUser")
            virtualUser:Button1Down(Vector2.new(posX, posY))
            task.wait(0.05)
            virtualUser:Button1Up(Vector2.new(posX, posY))
        end)
    end
end

Section:NewToggle("Auto Accept Trade", "Klik otomatis semua tombol Accept", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            -- Memastikan LocalPlayer bypass deteksi idle (opsional agar tidak ke-kick saat AFK)
            pcall(function()
                game:GetService("Players").LocalPlayer.Idled:Connect(function()
                    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end)
            end)

            while _G.AutoAccept do
                pcall(function()
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        -- Memindai seluruh komponen UI di dalam PlayerGui secara menyeluruh
                        for _, obj in pairs(playerGui:GetDescendants()) do
                            if obj:IsA("TextButton") and obj.Visible and obj.AbsoluteSize.X > 0 then
                                local name = obj.Name:lower()
                                local text = obj.Text:lower()
                                
                                -- Pola pencarian nama/teks tombol konfirmasi trade Adopt Me (Tahap 1, Tahap 2, dan Dialog awal)
                                if name == "accept" or name == "confirm" or name == "acceptbutton" or 
                                   text:find("accept") or text:find("terima") or text:find("confirm") then
                                    
                                    klikTombolSistem(obj)
                                    task.wait(0.1) -- Jeda singkat antar klik agar tidak dideteksi spam spamming oleh game
                                end
                            end
                        end
                    end
                end)
                task.wait(0.3) -- Mengulang pemindaian setiap 0.3 detik
            end
        end)
    end
end)
