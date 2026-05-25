-- Mengambil UI Library Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Membuat Window Utama
local Window = OrionLib:MakeWindow({
    Name = "Adopt Me Auto Trade", 
    HidePremium = false, 
    SaveConfig = false, 
    ConfigFolder = "AdoptMeHub"
})

-- Membuat Tab Menu
local TabUtama = Window:MakeTab({
    Name = "Fitur Trade",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Variabel status (Default: Mati)
_G.AutoAccept = false

-- Membuat Toggle ON/OFF di dalam Tab
TabUtama:AddToggle({
    Name = "Auto Accept Trade",
    Default = false,
    Callback = function(Value)
        _G.AutoAccept = Value
        
        -- Jika Toggle dinyalakan (True), jalankan fungsi pendeteksi trade
        if _G.AutoAccept then
            task.spawn(function()
                while _G.AutoAccept do
                    pcall(function()
                        -- Mencari tahu siapa player yang sedang mengajak trade di layar
                        local tradingWindow = game:GetService("Players").LocalPlayer.PlayerGui.TradeApp.Frame.AcceptDeclineFrame
                        
                        -- Jika jendela/pop-up trade muncul di layar kamu
                        if tradingWindow and tradingWindow.Visible then
                            -- Mengambil nama player yang mengajak trade
                            local playerName = tradingWindow.PlayerNameLabel.Text 
                            
                            -- Menjalankan code path milikmu untuk menerima trade dari player tersebut
                            -- Argumen 1: Nama Player, Argumen 2: true (artinya Menerima/Accept)
                            game:GetService("ReplicatedStorage").API["TradeAPI/AcceptOrDeclineTradeRequest"]:FireServer(playerName, true)
                        end
                    end)
                    task.wait(0.5) -- Cek setiap 0.5 detik agar tidak lag
                end
            end)
        end
    end    
})

-- Memunculkan UI
OrionLib:Init()
