repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- // PHẦN 1: ÉP SPAM ĐÁNH THƯỜNG & CHIÊU (CẤP ĐỘ CAO) //
spawn(function()
    while task.wait() do
        pcall(function()
            -- 1. Ép tự động đánh thường (M1)
            if getgenv().config.autoClick then
                local combat = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
                if combat.activeController then
                    combat.activeController:attack() -- Lệnh đánh trực tiếp từ hệ thống
                end
            end
            
            -- 2. Ép spam chiêu bằng RemoteEvent (Nhanh và chuẩn hơn nhấn phím)
            local character = game.Players.LocalPlayer.Character
            local root = character:FindFirstChild("HumanoidRootPart")
            
            if character and character:FindFirstChildOfClass("Tool") then
                local tool = character:FindFirstChildOfClass("Tool")
                
                -- Hàm thực thi chiêu thức
                local function FireSkill(skillName)
                    local remote = tool:FindFirstChild(skillName) or tool:FindFirstChild(skillName:lower())
                    if remote and remote:IsA("RemoteEvent") then
                        remote:FireServer(root.Position) -- Aim thẳng vào vị trí của mình/đối thủ
                    end
                end

                if getgenv().config.useZ then FireSkill("Z") end
                if getgenv().config.useX then FireSkill("X") end
                if getgenv().config.useC then FireSkill("C") end
                if getgenv().config.useF then FireSkill("F") end
                -- Chiêu V thường là biến hình, dùng Remote đôi khi lỗi nên dùng phím
                if getgenv().config.useV then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "V", false, game)
                end
            end
        end)
    end
end)

-- // PHẦN 2: FULL CONFIG CỦA BẠN //
getgenv().Key = "7a4b659bc7d29d699ebbeeed"
getgenv().config =  {
    team = "Pirates", 
    hpTimeout = 15,
    targetTimeout = 20,
    lowHealth = 4000,
    safeHealth = 5000,
    blackScreen = false,
    useSkill = false, -- Tắt cái này của Banana để tránh xung đột với bộ spam mới
    equipPaleScarf = false,
    webhookurl = "",
    webhookEnable = false,
    webhookSendMinutes = 5,
    attackSpeed = 0,
    mode = 1, 
    sea = 3,
    region = "Singapore",
    trans = true, 
    bltween = true, 
    bpsit = true, 
    autoEatFruit = false, 
    autoEatFruitNames = "", 
    boostfps = false,
    autoV4 = true,
    
    -- Tùy chỉnh spam mới
    autoClick = true,
    useZ = true,
    useX = true,
    useC = true,
    useV = false, 
    useF = false,
}

-- // PHẦN 3: CHẠY SCRIPT //
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/Bountynew.lua"))()
