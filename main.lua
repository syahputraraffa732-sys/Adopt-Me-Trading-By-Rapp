-- Menggunakan Kavo Library (Lebih stabil untuk executor mobile)
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("Adopt Me Trade By Rapp", "DarkTheme")

-- Membuat Tab Menu
local TabUtama = Window:NewTab("Fitur Trade")
local Section = TabUtama:NewSection("Automation")

-- Variabel status
_G.AutoAccept = false

-- Membuat Toggle ON/OFF
Section:NewToggle("Auto Accept Trade", "Menerima trade secara otomatis", function(Value)
    _G.AutoAccept = Value
    
    if _G.AutoAccept then
        task.spawn(function()
            while _G.AutoAccept do
                pcall(function()
                    local tradingWindow = game:GetService("Players").LocalPlayer.PlayerGui.TradeApp.Frame.AcceptDeclineFrame
                    if tradingWindow and tradingWindow.Visible then
                        local playerName = tradingWindow.PlayerNameLabel.Text 
                        game:GetService("ReplicatedStorage").API["TradeAPI/AcceptOrDeclineTradeRequest"]:FireServer(playerName, true)
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)
