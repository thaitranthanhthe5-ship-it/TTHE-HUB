--// =========================
--// GLOBAL SETTINGS
--// =========================
_G.KaitunSettings = {
    AutoFarm = false,
    WhiteScreen = true,
    FastMode = true,
    SelectWeapon = "Melee",
    SafeHealthMode = true
}

--// =========================
--// SERVICES
--// =========================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

--// =========================
--// OPTIMIZER
--// =========================
local function OptimizeGame()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CastShadow = false
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end

task.spawn(function()
    while task.wait(60) do
        collectgarbage("collect")
    end
end)

--// =========================
--// MOVEMENT
--// =========================
local CurrentTween

local function StopTween()
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
end

local function MoveTo(cf, speed)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local dist = (hrp.Position - cf.Position).Magnitude

    if dist > 5000 then
        StopTween()
        hrp.CFrame = cf
        return
    end

    local t = dist / speed
    StopTween()

    CurrentTween = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = cf})
    CurrentTween:Play()
end

--// =========================
--// SAFETY
--// =========================
task.spawn(function()
    while task.wait(1) do
        if not _G.KaitunSettings.SafeHealthMode then continue end

        local char = LocalPlayer.Character
        if not char then continue end

        local hum = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if hum and hrp then
            if hum.Health / hum.MaxHealth <= 0.25 then
                StopTween()
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 300, 0)
            end
        end
    end
end)

--// =========================
--// MOB CACHE
--// =========================
local CachedMobs = {}

task.spawn(function()
    while task.wait(3) do
        table.clear(CachedMobs)

        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            local root = mob:FindFirstChild("HumanoidRootPart")
            local hum = mob:FindFirstChild("Humanoid")

            if root and hum and hum.Health > 0 then
                if (hrp.Position - root.Position).Magnitude < 300 then
                    table.insert(CachedMobs, mob)
                end
            end
        end
    end
end)

local function GetClosestMob(name)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local closest, dist = nil, math.huge

    for _, mob in ipairs(CachedMobs) do
        if mob.Name == name then
            local root = mob:FindFirstChild("HumanoidRootPart")
            local hum = mob:FindFirstChild("Humanoid")

            if root and hum and hum.Health > 0 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = mob
                end
            end
        end
    end

    return closest
end

--// =========================
--// COMBAT
--// =========================
local Skills = {Z=true,X=true,C=true,V=false}

local function Attack()
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end

local function BringMob(target)
    if not _G.KaitunSettings.AutoFarm then return end
    if not target then return end

    local hrp = LocalPlayer.Character.HumanoidRootPart

    for _, mob in ipairs(CachedMobs) do
        if mob.Name == target.Name then
            local root = mob:FindFirstChild("HumanoidRootPart")
            local hum = mob:FindFirstChild("Humanoid")

            if root and hum and hum.Health > 0 then
                root.CFrame = hrp.CFrame * CFrame.new(0,0,-7)
            end
        end
    end

    task.wait(0.3)
end

local function UseSkills(mob)
    local hum = mob and mob:FindFirstChild("Humanoid")
    if not hum then return end

    if hum.Health / hum.MaxHealth > 0.5 then return end

    for k,v in pairs(Skills) do
        if v then
            VIM:SendKeyEvent(true,k,false,game)
            task.wait(0.05)
            VIM:SendKeyEvent(false,k,false,game)
            task.wait(0.2)
        end
    end
end

--// =========================
--// QUEST DATA
--// =========================
local QuestData = {
    {Min=1,Max=9,Mob="Bandit",QuestPos=CFrame.new(1060,16,1547),Spawn=CFrame.new(1150,17,1630)},
    {Min=10,Max=29,Mob="Monkey",QuestPos=CFrame.new(-1600,36,153),Spawn=CFrame.new(-1440,67,11)}
}

local function GetQuest()
    local lv = LocalPlayer.Data.Level.Value
    for _,q in ipairs(QuestData) do
        if lv>=q.Min and lv<=q.Max then return q end
    end
end

local lastQuestCheck = 0

local function HasQuest()
    local gui = LocalPlayer.PlayerGui:FindFirstChild("Main")
    return gui and gui:FindFirstChild("Quest") and gui.Quest.Visible
end

local function CheckQuest()
    if tick()-lastQuestCheck < 7 then return end
    lastQuestCheck = tick()

    if HasQuest() then return end
    local q = GetQuest()
    if not q then return end

    MoveTo(q.QuestPos,300)
    task.wait(1.5)

    VIM:SendKeyEvent(true,"E",false,game)
    task.wait(0.2)
    VIM:SendKeyEvent(false,"E",false,game)
end

--// =========================
--// BLACK SCREEN
--// =========================
local function EnableBlackScreen()
    if not _G.KaitunSettings.WhiteScreen then return end

    local gui = Instance.new("ScreenGui",LocalPlayer.PlayerGui)
    gui.Name = "Black"

    local f = Instance.new("Frame",gui)
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundColor3 = Color3.new(0,0,0)

    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end

--// =========================
--// MAIN LOOP
--// =========================
task.spawn(function()
    while task.wait(0.2) do
        if not _G.KaitunSettings.AutoFarm then continue end

        local q = GetQuest()
        if not q then continue end

        CheckQuest()
        MoveTo(q.Spawn,350)

        local mob = GetClosestMob(q.Mob)
        if mob then
            local root = mob:FindFirstChild("HumanoidRootPart")
            if root then
                MoveTo(root.CFrame * CFrame.new(0,0,5),300)
                BringMob(mob)
                Attack()
                UseSkills(mob)
            end
        end
    end
end)

--// =========================
--// UI (ORION)
--// =========================
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:MakeWindow({Name = "Kaitun Blox Fruits", HidePremium = false})

local Tab = Window:MakeTab({Name = "Main"})

Tab:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(v)
        _G.KaitunSettings.AutoFarm = v
    end
})

Tab:AddToggle({
    Name = "White Screen",
    Default = true,
    Callback = function(v)
        _G.KaitunSettings.WhiteScreen = v
        if v then
            EnableBlackScreen()
        end
    end
})

Tab:AddDropdown({
    Name = "Select Weapon",
    Default = "Melee",
    Options = {"Melee","Sword"},
    Callback = function(v)
        _G.KaitunSettings.SelectWeapon = v
    end
})

OrionLib:Init()
