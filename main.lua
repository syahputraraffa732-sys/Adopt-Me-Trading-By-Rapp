-- 1. SETUP UI UTAMA (KAVO LIBRARY)
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp", "DarkTheme")

-- 2. MEMBUAT TOMBOL MINIMIZE KHUSUS HP (BULAT MERAH)
local ScreenGui = Instance.new("ScreenGui")
local MinButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "RappMinimizeSystem"

MinButton.Parent = ScreenGui
MinButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50) -- Warna Merah
MinButton.Position = UDim2.new(0, 15, 0, 15) -- Posisi di layar
MinButton.Size = UDim2.new(0, 50, 0, 50) -- Ukuran bulat pas untuk jempol
MinButton.Text = "R"
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.Font = Enum.Font.SourceSansBold
MinButton.TextSize = 22

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MinButton

-- Fungsi khusus Kavo untuk menyembunyikan/memunculkan menu via tombol merah
MinButton.MouseButton1Click:Connect(function()
    KavoLib:ToggleUI()
end)

-- 3. MEMBUAT MENU TAB & REKAYASA FITUR
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Klik otomatis semua tombol Accept", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            while _G.AutoAccept do
                pcall(function()
                    -- Mencari semua objek di PlayerGui secara menyeluruh
                    for _, button in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
                        -- Mendeteksi jika objek tersebut adalah tombol yang bisa diklik dan sedang aktif di layar
                        if button:IsA("TextButton") and button.Visible and button.AbsoluteSize.X > 0 then
                            local text = button.Text:lower()
                            local name = button.Name:lower()
                            
                            -- Memastikan teks atau nama tombol mengandung unsur "Accept", "Terima", atau "Confirm"
                            if text:find("accept") or text:find("terima") or text:find("confirm") or name:find("accept") then
                                -- Menggunakan metode 'GuiService' untuk menyimulasikan pemilihan objek secara langsung (sangat ampuh di mobile)
                                game:GetService("GuiService").SelectedObject = button
                                task.wait(0.05)
                                -- Menyimulasikan penekanan tombol enter/klik pada objek yang terpilih
                                local virtualInput = game:GetService("VirtualInputManager")
                                virtualInput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                task.wait(0.05)
                                virtualInput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                
                                -- Reset kembali seleksi objek agar tidak mengganggu layar
                                game:GetService("GuiService").SelectedObject = nil
                            end
                        end
                    end
                end)
                task.wait(0.5) -- Jeda pengecekan setengah detik
            end
        end)
    end
end)
