local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CẤU HÌNH TỔNG HỢP
local Config = {
    KillVisibleOnly = true, -- Chỉ giết khi địch ló ra (không xuyên tường)
    HeadshotChance = 100,  -- 100% trúng đầu
    SpeedMultiplier = 10,    -- Tốc độ x2
    JumpMultiplier = 10      -- Nhảy cao x2
}

-- 1. TỰ ĐỘNG CẬP NHẬT TỐC ĐỘ & NHẢY
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        hum.WalkSpeed = 50 * Config.SpeedMultiplier
        hum.JumpPower = 80 * Config.JumpMultiplier
    end
end)

-- 2. HÀM KIỂM TRA TẦM NHÌN (CHỐNG BẮN XUYÊN TƯỜNG)
local function IsVisible(part)
    local ignoreList = {LocalPlayer.Character, Camera}
    local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    return hit and hit:IsDescendantOf(part.Parent)
end

-- 3. TÌM ĐỐI THỦ ĐANG LỘ DIỆN
local function GetKillTarget()
    local target = nil
    local shortestDist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            if Config.KillVisibleOnly and not IsVisible(head) then continue end
            
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < shortestDist then
                    target = head
                    shortestDist = dist
                end
            end
        end
    end
    return target
end

-- 4. CƠ CHẾ TỰ ĐỘNG GIẾT (SILENT AIM & AUTO KILL)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    -- Khi bạn bắn, script sẽ tự tìm mục tiêu và "gán" viên đạn vào đó
    if method == "FindPartOnRayWithIgnoreList" or method == "Raycast" or method == "FireServer" then
        local target = GetKillTarget()
        if target then
            -- Bẻ cong đường đạn hoặc gửi lệnh sát thương thẳng tới đầu địch
            if method == "FireServer" and tostring(self) == "HitPart" then -- Thay "HitPart" bằng Remote của game
                args[1] = target -- Ép mục tiêu là đối thủ
                args[2] = target.Position
            end
            return target, target.Position, target.CFrame.LookVector, target.Material
        end
    end
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)

-- 5. ESP X-RAY & LÀM BỰ ĐỐI THỦ X3
local function ApplyVisuals(p)
    p.CharacterAdded:Connect(function(char)
        if p.Team ~= LocalPlayer.Team then
            task.wait(0.5)
            -- Làm bự đối thủ
            char.Humanoid.BodyHeightScale.Value = 10
            char.Humanoid.BodyWidthScale.Value = 10
            -- X-Ray
            local hl = Instance.new("Highlight", char)
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then ApplyVisuals(p) end end
Players.PlayerAdded:Connect(ApplyVisuals)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- BIẾN KIỂM SOÁT
local isFlying = false
local lastJumpTime = 0
local doubleTapThreshold = 0.3 -- Thời gian tối đa giữa 2 lần bấm để tính là Double Tap
local flySpeed = 50
local bodyVelocity = nil

-- HÀM BẮT ĐẦU BAY
local function StartFlying()
    isFlying = true
    humanoid.PlatformStand = true -- Vô hiệu hóa trạng thái đi bộ để bay tự do
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
end

-- HÀM DỪNG BAY
local function StopFlying()
    isFlying = false
    humanoid.PlatformStand = false
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

-- XỬ LÝ SỰ KIỆN NHẢY
UserInputService.JumpRequest:Connect(function()
    local currentTime = tick()
    
    -- Kiểm tra bấm 2 lần (Double Tap)
    if (currentTime - lastJumpTime) < doubleTapThreshold then
        if isFlying then
            StopFlying()
        else
            StartFlying()
        end
        lastJumpTime = 0 -- Reset để tránh nhận diện nhầm lần thứ 3
    else
        lastJumpTime = currentTime
    end
end)

-- XỬ LÝ KHI ĐÈ NÚT NHẢY (BAY LÊN)
RunService.RenderStepped:Connect(function()
    if isFlying and bodyVelocity then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService.TouchEnabled then
            -- Nếu đang đè nút nhảy (Space hoặc nút nhảy Mobile)
            bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
        else
            -- Đứng yên trên không khi không đè
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- Đồng bộ hướng bay theo camera (tùy chọn)
        rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + workspace.CurrentCamera.CFrame.LookVector)
    end
end)
