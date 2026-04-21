local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local text = Instance.new("TextLabel")
text.Parent = gui
text.BackgroundTransparency = 1
text.Size = UDim2.new(0,1500,0,50)
text.Position = UDim2.new(1,0,0,0)
text.Text = "THANK FOR USING TTHE HUB"
text.TextColor3 = Color3.fromRGB(255,170,60)
text.TextStrokeTransparency = 0
text.TextScaled = true
text.Font = Enum.Font.Oswald

local tween = TweenService:Create(
    text,
    TweenInfo.new(10, Enum.EasingStyle.Linear),
    {Position = UDim2.new(-1,0,0,0)}
)

tween:Play()

tween.Completed:Connect(function()
    gui:Destroy()
end)
