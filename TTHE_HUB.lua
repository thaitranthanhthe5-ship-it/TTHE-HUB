repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Key = "7a4b659bc7d29d699ebbeeed"
getgenv().config =  {
    team = "Pirates", -- "Pirates" "Marines"
    hpTimeout = 15,
    targetTimeout = 20,
    lowHealth = 4000,
    safeHealth = 5000,
    blackScreen = false,
    useSkill = true, -- only x f gas fruit
    equipPaleScarf = false,
    webhookurl = "",
    webhookEnable = false,
    webhookSendMinutes = 5,
    attackSpeed = 0.0001,
    mode = 1, -- 2 or 1 
    sea = 3,
    region = "Singapore",
    trans = false, -- auto press V t rex 
    bltween = true, -- bypass may thang di chuyen toc do cao lien tuc > 7s - kho gay dame 
    bpsit = true, -- khong hunt may thang ngoi thuyen - kho gay dame 
    autoEatFruit = false, 
    autoEatFruitNames = "", -- T-Rex-T-Rex", "Gas-Gas", "Dragon-Dragon", "Kitsune-Kitsune", "Pain-Pain", "Blade-Blade"
    boostfps = false,
    autoV4 = true, 
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/Bountynew.lua"))()
