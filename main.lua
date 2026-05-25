-- SETUP UI UTAMA (KAVO LIBRARY)
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp", "DarkTheme")

-- MEMBUAT TAB UTAMA
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

-- 1. TOMBOL SEMBUNYIKAN MENU
-- Kamu bisa klik tombol ini di dalam menu untuk menyembunyikan/memunculkan tab besarnya!
Section:NewKeybind("Sembunyikan Menu", "Klik untuk menyembunyikan menu", Enum.KeyCode.RightControl, function()
    KavoLib:ToggleUI()
end)

-- 2. FITUR AUTO ACCEPT TRADE (Menggunakan Remote Hasil Temuanmu)
_G.AutoAccept = false

Section:NewToggle("Auto Accept Trade", "Menerima semua tahap trade otomatis", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            while _G.AutoAccept do
                pcall(function()
                    local replicatedStorage = game:GetService("ReplicatedStorage")
                    local apiFolder = replicatedStorage:WaitForChild("API")
                    
                    -- [TAHAP 1: Menerima Ajakan Trade]
                    -- Memanggil RemoteFunction dengan InvokeServer
                    apiFolder["TradeAPI/AcceptOrDeclineTradeRequest"]:InvokeServer()
                    
                    -- [TAHAP 2: Konfirmasi Jendela Trade Pertama]
                    -- Memanggil RemoteEvent dengan FireServer
                    apiFolder["TradeAPI/AcceptNegotiation"]:FireServer()
                    
                    -- [TAHAP 3: Konfirmasi Final Hitung Mundur 15 Detik]
                    -- Memanggil RemoteEvent dengan FireServer
                    apiFolder["TradeAPI/ConfirmTrade"]:FireServer()
                end)
                task.wait(0.5) -- Mengulang pengecekan setiap 0.5 detik agar tidak lag
            end
        end)
    end
end)
