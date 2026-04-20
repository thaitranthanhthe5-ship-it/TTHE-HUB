if child:IsA("Tool") and (child.Name:find("Fruit") or child:FindFirstChild("Handle")) then FastStore(child) end
    end)
    while task.wait(1) do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p:GetRankInGroup(2440505) > 1 then Player:Kick("Admin " .. p.Name .. " detected!") end
        end
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then FastStore(v) end
        end
    end
end)

-- 6. ANTI-BAN & CHỐNG AFK
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or tostring(self) == "CheckVerification" or (method == "FireServer" and {...}[1] == "TeleportCheck") then
        return nil
    end
    return old(self, unpack({...}))
end)
setreadonly(mt, true)

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

print("--- FULL SYSTEM: STEP 1-7 READY (V4 BUFF INCLUDED) ---")
