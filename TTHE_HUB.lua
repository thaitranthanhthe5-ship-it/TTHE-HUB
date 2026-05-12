repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
spawn(function()
    local setup = true
    while setup do
        task.wait()
        pcall(function()
            local combat = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
            local old_attack = combat.activeController.attack
            combat.activeController.attack = function(self)
                self.attackInterval = 0.000000000001
                self.readyToAttack = true
                for i = 1, 999999 do 
                    old_attack(self)
                end
            end
            setup = true
        end)
    end
end)
getgenv().Key = "7a4b659bc7d29d699ebbeeed"
getgenv().config =  {
    team = "Pirates",
    hpTimeout = 15,
    targetTimeout = 20,
    lowHealth = 4000,
    safeHealth = 5000,
    blackScreen = false,
    useSkill = false,
    attackSpeed = 0,
    mode = 1,
    sea = 3,
    region = "Singapore",
    trans = false,
    bltween = true,
    bpsit = true,
    autoEatFruit = false,
    autoEatFruitNames = "",
    boostfps = false,
    autoV4 = true,    
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/Bountynew.lua"))()
