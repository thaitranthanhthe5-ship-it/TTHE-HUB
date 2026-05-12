repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- // PHẦN 1: SIÊU TỐC ĐỘ CÀO T-REX (FAST ATTACK MULTI-HIT) //
-- Đoạn này chạy song song để ép game gửi nhiều sát thương cùng lúc
spawn(function()
    while task.wait() do
        pcall(function()
            -- Kiểm tra nếu đang cầm vũ khí/trái ác quỷ
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Tool") then
                local combatScript = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("CombatFramework")
                if combatScript then
                    local CombatFramework = require(combatScript)
                    local Controller = CombatFramework.activeController
                    
                    if Controller and Controller.active then
                        -- Loại bỏ độ trễ giữa các lần cào
                        Controller.attackInterval = 0
                        Controller.readyToAttack = true
                        
                        -- Vòng lặp này ép ra nhiều đòn đánh trong 1 lần click (Số 15 là mức an toàn cao)
                        -- Nếu muốn nhanh hơn nữa bạn có thể nâng lên 20-25, nhưng 30 dễ bị Kick
                        for i = 1, 25 do 
                            Controller:attack()
                        end
                    end
                end
            end
        end)
    end
end)

-- // PHẦN 2: CONFIG BANANA PREMIUM CỦA BẠN //
getgenv().Key = "7a4b659bc7d29d699ebbeeed"
getgenv().config =  {
    team = "Pirates", 
    hpTimeout = 15,
    targetTimeout = 20,
    lowHealth = 4000,
    safeHealth = 5000,
    blackScreen = false,
    useSkill = false, 
    equipPaleScarf = false,
    webhookurl = "",
    webhookEnable = false,
    webhookSendMinutes = 5,
    attackSpeed = 0, -- Để 0 để phối hợp với phần Multi-hit ở trên
    mode = 1, 
    sea = 3,
    region = "Singapore",
    trans = true, -- BẬT cái này để tự hóa T-Rex (rất quan trọng)
    bltween = true, 
    bpsit = true, 
    autoEatFruit = false, 
    autoEatFruitNames = "", 
    boostfps = false,
    autoV4 = true,    
}

-- // PHẦN 3: CHẠY SCRIPT CHÍNH //
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/Bountynew.lua"))()
