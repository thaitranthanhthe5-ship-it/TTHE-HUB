local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CẤU HÌNH
local AimSettings = {
    TeamCheck = true,
    TargetPart = "Head", -- Ưu tiên bắn vào đầu
    KillRange = 1000,    -- Khoảng cách tối đa
}

-- HÀM KIỂM TRA TẦM NHÌN (CHECK WALL)
local function IsVisible(targetPart)
    local character = LocalPlayer.Character
    if not character then return false end
    
    -- Tạo một tia Ray từ mắt bạn đến mục tiêu
    local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * AimSettings.KillRange)
    -- Bỏ qua bản thân bạn để tia không bị chặn bởi chính mình
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {character, Camera})
    
    -- Nếu vật thể trúng phải là một phần của đối thủ, nghĩa là KHÔNG có tường chắn
    if hit and hit:IsDescendantOf(targetPart.Parent) then
        return true
    end
    return false
end

-- HÀM TÌM ĐỐI THỦ HỢP LỆ
local function GetValidTarget()
    local bestTarget = nil
    local minDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimSettings.TargetPart) then
            -- 1. Kiểm tra đồng đội
            if AimSettings.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            -- 2. Kiểm tra máu
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local part = player.Character[AimSettings.TargetPart]
                
                -- 3. KIỂM TRA LỘ DIỆN (CHỐNG XUYÊN TƯỜNG)
                if IsVisible(part) then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if dist < minDistance then
                            bestTarget = part
                            minDistance = dist
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

-- THỰC THI AIM KILL
RunService.RenderStepped:Connect(function()
    local target = GetValidTarget()
    if target then
        -- Khóa tâm siêu tốc vào mục tiêu đang lộ diện
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        
        -- Ở đây bạn có thể thêm lệnh tự động bắn (Mouse1 Click) 
        -- hoặc gọi Remote Event gây sát thương nếu đã tìm được tên Remote của game
    end
end)
