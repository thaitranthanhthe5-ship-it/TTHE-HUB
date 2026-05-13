repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
spawn(function()
    while task.wait() do
        pcall(function()
            local target = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") -- Giả định script chính đã tìm target
            -- Nếu bạn đang hunt, script Banana sẽ tự tìm target, đoạn này hỗ trợ Aim
            if getgenv().config.autoClick then
                local combat = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
                if combat.activeController then
                    combat.activeController:attack()
                end
            end
        end)
    end
end)

    while task.wait(0.1) do -- Delay nhẹ để không bị kẹt chiêu
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            local char = game.Players.LocalPlayer.Character
            
            -- Chỉ spam chiêu khi máu đối thủ hoặc khoảng cách hợp lý (logic này Banana đã lo)
            -- Ở đây mình ép phím giả lập để Aim chuẩn theo chuột/target
            if getgenv().config.useZ then VIM:SendKeyEvent(true, "Z", false, game) end
            if getgenv().config.useX then VIM:SendKeyEvent(true, "X", false, game) end
            if getgenv().config.useC then VIM:SendKeyEvent(true, "C", false, game) end
            if getgenv().config.useV then VIM:SendKeyEvent(true, "V", false, game) end
            if getgenv().config.useF then VIM:SendKeyEvent(true, "F", false, game) end
        end)
    end
end)
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Key = "7a4b659bc7d29d699ebbeeed"
getgenv().config =  {
    team = "Pirates", -- "Pirates" "Marines"
    hpTimeout = 15,
    targetTimeout = 20,
    lowHealth = 4000,
    safeHealth = 4500,
    blackScreen = false,
    useSkill = false, -- only x f gas fruit
    equipPaleScarf = false,
    webhookurl = "",
    webhookEnable = false,
    webhookSendMinutes = 5,
    attackSpeed = 0.000000000001,
    mode = 1, -- 2 or 1 
    sea = 3,
    region = "Singapore",
    trans = false, -- auto press V t rex 
    bltween = true, -- bypass may thang di chuyen toc do cao lien tuc > 7s - kho gay dame 
    bpsit = true, -- khong hunt may thang ngoi thuyen - kho gay dame 
    autoEatFruit = false, 
    autoEatFruitNames = "", -- T-Rex-T-Rex", "Gas-Gas", "Dragon-Dragon", "Kitsune-Kitsune", "Pain-Pain", "Blade-Blade"
    boostfps = false,
    autoV4 = true,    
    autoClick = true,   -- Tự động cào T-Rex
    useZ = true,        -- Bật/Tắt chiêu Z
    useX = true,        -- Bật/Tắt chiêu X
    useC = true,        -- Bật/Tắt chiêu C
    useV = false,        -- Bật/Tắt chiêu V (Biến hình)
    useF = false,        -- Bật/Tắt chiêu F
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/Bountynew.lua"))()
