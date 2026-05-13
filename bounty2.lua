-- // SUPREME T-REX INDEPENDENT SCRIPT //
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local VIM = game:GetService("VirtualInputManager")

-- BẢNG ĐIỀU KHIỂN (Bạn có thể sửa true/false ở đây)
local T_Rex_Settings = {
    AutoClick = true,       -- Tự động đánh thường
    SilentAim = true,       -- Tự ngắm chiêu vào mục tiêu
    SpamSkills = true,      -- Tự tung chiêu Z, X, C
    Skills = {"Z", "X", "C"},
    ScanDistance = 1000     -- Khoảng cách quét mục tiêu
}

-- Hàm tìm mục tiêu gần nhất (Ưu tiên người chơi)
local function GetClosestTarget()
    local target = nil
    local shortestDistance = T_Rex_Settings.ScanDistance

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local distance = (v.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                target = v.Character.HumanoidRootPart
            end
        end
    end
    return target
end

-- Vòng lặp chính xử lý độc lập
spawn(function()
    while task.wait() do
        pcall(function()
            local target = GetClosestTarget()
            local char = LP.Character
            local tool = char and char:FindFirstChildOfClass("Tool")

            if char and tool then
                -- 1. AUTO CLICK (Đánh thường)
                if T_Rex_Settings.AutoClick then
                    local combat = require(LP.PlayerScripts.CombatFramework)
                    if combat.activeController then
                        combat.activeController.attackInterval = 0
                        combat.activeController:attack()
                    end
                end

                -- 2. SILENT AIM & SPAM SKILL
                if T_Rex_Settings.SpamSkills and target then
                    for _, key in pairs(T_Rex_Settings.Skills) do
                        local remote = tool:FindFirstChild(key) or tool:FindFirstChild(key:lower())
                        if remote and remote:IsA("RemoteEvent") then
                            -- Gửi lệnh gây sát thương thẳng vào vị trí mục tiêu
                            remote:FireServer(target.Position)
                        end
                    end
                end
            end
        end)
    end
end)

-- Hiển thị thông báo khi chạy thành công
print("T-REX INDEPENDENT SCRIPT LOADED!")
