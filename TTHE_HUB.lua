repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- // HỆ THỐNG SPAM CHIÊU & AUTO CLICK //
spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().config.autoClick then
                local combat = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
                if combat.activeController then combat.activeController:attack() end
            end
            local VIM = game:GetService("VirtualInputManager")
            if getgenv().config.useZ then VIM:SendKeyEvent(true, "Z", false, game) end
            if getgenv().config.useX then VIM:SendKeyEvent(true, "X", false, game) end
            if getgenv().config.useC then VIM:SendKeyEvent(true, "C", false, game) end
            if getgenv().config.useV then VIM:SendKeyEvent(true, "V", false, game) end
            if getgenv().config.useF then VIM:SendKeyEvent(true, "F", false, game) end
        end)
    end
end)

-- // FULL CONFIG (KHÔNG THIẾU DÒNG NÀO) //
getgenv().Key = "7a4b659bc7d29d699ebbeeed"
getgenv().config = {
    -- Cài đặt gốc của bạn
    team = "Pirates",
    hpTimeout = 15,
    targetTimeout = 20,
    lowHealth = 4000,
    safeHealth = 5000,
    blackScreen = false,
    useSkill = false, -- Skill riêng của Banana
    equipPaleScarf = false,
    webhookurl = "",
    webhookEnable = false,
    webhookSendMinutes = 5,
    attackSpeed = 0.000001,
    mode = 1,
    sea = 3,
    region = "Singapore",
    trans = false, 
    bltween = true,
    bpsit = true,
    autoEatFruit = false, 
    autoEatFruitNames = "",
    boostfps = false,
    autoV4 = true,

    -- Tùy chọn spam chiêu bạn yêu cầu (Tự chỉnh True/False)
    autoClick = true, -- Tự động đánh thường T-Rex
    useZ = true,
    useX = true,
    useC = true,
    useV = false, -- Nên để false nếu đã bật 'trans = true' ở trên
    useF = false
}

-- CHẠY SCRIPT
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/Bountynew.lua"))()
