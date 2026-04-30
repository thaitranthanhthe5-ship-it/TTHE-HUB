_G.ThemeID = _G.ThemeID or nil
_G.AutoTranslate = (_G.AutoTranslate == nil) and true or _G.AutoTranslate
_G.SaveConfig = (_G.SaveConfig == nil) and true or _G.SaveConfig

local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local placeId = game.PlaceId

local UniverseID = HttpService:JSONDecode(
    game:HttpGet("https://apis.roblox.com/universes/v1/places/"..placeId.."/universe")
).universeId

if UniverseID == 994732206 then

    loadstring(game:HttpGet("https://raw.githubusercontent.com/thaitranthanhthe5-ship-it/TTHE-HUB/refs/heads/main/TTHE-HUB.lua"))()

    task.wait(1)

    StarterGui:SetCore("SendNotification",{
        Title = "THANHTHE HUB",
        Text = "Con Cặc",
        Duration = 3
    })

    task.wait(3)

    StarterGui:SetCore("SendNotification",{
        Title = "THANHTHE HUB",
        Text = "Bố Là Thế",
        Duration = 2
    })

    task.wait(2)

    StarterGui:SetCore("SendNotification",{
        Title = "TTHE HUB",
        Text = "Loader Success!",
        Duration = 5
    })

    task.wait(1)

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Graihub/Gay/refs/heads/main/bamia"))()

else
    StarterGui:SetCore("SendNotification",{
        Title = "THANHTHE HUB",
        Text = "Game Not Supported",
        Duration = 5
    })

    task.wait(1)

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Graihub/notsupport/refs/heads/main/Ui"))()
end
