--// TTHE HUB VIP

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- Toggle Button
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0,110,0,40)
Toggle.Position = UDim2.new(0,20,0,200)
Toggle.Text = "TTHE HUB"
Toggle.BackgroundColor3 = Color3.fromRGB(25,25,25)
Toggle.TextColor3 = Color3.fromRGB(0,255,200)

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,430,0,330)
Main.Position = UDim2.new(0.5,-215,0.5,-165)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.Visible = false
Main.Active = true
Main.Draggable = true

-- Bo góc + viền
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0,255,200)

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,35)
Title.Text = "TTHE HUB VIP"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0,255,200)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

-- Animation mở menu
Toggle.MouseButton1Click:Connect(function()
	Main.Visible = true
	Main.Size = UDim2.new(0,0,0,0)
	TweenService:Create(Main, TweenInfo.new(0.3), {
		Size = UDim2.new(0,430,0,330)
	}):Play()
end)

-- Tabs
local function createTab(name, pos)
	local btn = Instance.new("TextButton", Main)
	btn.Text = name
	btn.Position = pos
	btn.Size = UDim2.new(0,140,0,30)
	return btn
end

local Tab1 = createTab("Server", UDim2.new(0,0,0,35))
local Tab2 = createTab("Movement", UDim2.new(0,140,0,35))
local Tab3 = createTab("Visual", UDim2.new(0,280,0,35))

-- Frames
local function createFrame()
	local f = Instance.new("Frame", Main)
	f.Size = UDim2.new(1,0,1,-65)
	f.Position = UDim2.new(0,0,0,65)
	f.BackgroundTransparency = 1
	return f
end

local F1 = createFrame()
local F2 = createFrame()
local F3 = createFrame()
F2.Visible = false
F3.Visible = false

-- Switch tab
local function show(f)
	F1.Visible=false F2.Visible=false F3.Visible=false
	f.Visible=true
end

Tab1.MouseButton1Click:Connect(function() show(F1) end)
Tab2.MouseButton1Click:Connect(function() show(F2) end)
Tab3.MouseButton1Click:Connect(function() show(F3) end)

-- =====================
-- AUTO SERVER HOP
-- =====================
local autoHop = false

local Hop = Instance.new("TextButton", F1)
Hop.Size = UDim2.new(0,200,0,40)
Hop.Position = UDim2.new(0,20,0,20)
Hop.Text = "Auto Hop: OFF"

Hop.MouseButton1Click:Connect(function()
	autoHop = not autoHop
	Hop.Text = "Auto Hop: "..(autoHop and "ON" or "OFF")

	while autoHop do
		wait(5)
		local Http = game:GetService("HttpService")
		local Teleport = game:GetService("TeleportService")

		local data = Http:JSONDecode(game:HttpGet(
			"https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
		))

		for _,v in pairs(data.data) do
			if v.playing < v.maxPlayers then
				Teleport:TeleportToPlaceInstance(game.PlaceId, v.id)
				break
			end
		end
	end
end)

-- =====================
-- MOVEMENT
-- =====================
local speedOn = false
local Speed = Instance.new("TextButton", F2)
Speed.Size = UDim2.new(0,200,0,40)
Speed.Position = UDim2.new(0,20,0,20)
Speed.Text = "Speed: OFF"

Speed.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	Speed.Text = "Speed: "..(speedOn and "ON" or "OFF")
	player.Character.Humanoid.WalkSpeed = speedOn and 32 or 16
end)

local jumpOn = false
local Jump = Instance.new("TextButton", F2)
Jump.Size = UDim2.new(0,200,0,40)
Jump.Position = UDim2.new(0,20,0,70)
Jump.Text = "Jump: OFF"

Jump.MouseButton1Click:Connect(function()
	jumpOn = not jumpOn
	Jump.Text = "Jump: "..(jumpOn and "ON" or "OFF")
	player.Character.Humanoid.JumpPower = jumpOn and 100 or 50
end)

-- =====================
-- VISUAL
-- =====================
-- FPS
local FPS = Instance.new("TextLabel", F3)
FPS.Size = UDim2.new(0,200,0,40)
FPS.Position = UDim2.new(0,20,0,20)
FPS.BackgroundTransparency = 1

game:GetService("RunService").RenderStepped:Connect(function(dt)
	FPS.Text = "FPS: "..math.floor(1/dt)
end)

-- ESP (Name + Distance)
local esp = false
local ESPBtn = Instance.new("TextButton", F3)
ESPBtn.Size = UDim2.new(0,200,0,40)
ESPBtn.Position = UDim2.new(0,20,0,70)
ESPBtn.Text = "ESP: OFF"

ESPBtn.MouseButton1Click:Connect(function()
	esp = not esp
	ESPBtn.Text = "ESP: "..(esp and "ON" or "OFF")
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if esp then
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
				if not p.Character:FindFirstChild("ESP") then
					local bill = Instance.new("BillboardGui", p.Character)
					bill.Name = "ESP"
					bill.Size = UDim2.new(0,120,0,40)
					bill.Adornee = p.Character.Head
					bill.AlwaysOnTop = true

					local txt = Instance.new("TextLabel", bill)
					txt.Size = UDim2.new(1,0,1,0)
					txt.BackgroundTransparency = 1
					txt.TextColor3 = Color3.fromRGB(0,255,200)
				end

				local dist = (player.Character.Head.Position - p.Character.Head.Position).Magnitude
				p.Character.ESP.TextLabel.Text = p.Name.." ["..math.floor(dist).."]"
			end
		end
	end
end)
