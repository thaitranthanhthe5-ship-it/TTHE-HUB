repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Key = "7a4b659bc7d29d699ebbeeed"
getgenv().Config = {
    Team = "Pirates",
    HideUI = true,
    HuntConfig = {
        ["Earned Notification Enabled"] = true,
        ["Reset Farm (New)"] = true,
        ["Farm Delay"] = 0.22, -- 0.15 - Super Fast(Risk - Kick) | 0.22 Fast | 0.35 Medium | Max 0.5
        ["Webhook"] = {
            Enabled = false,
            Url = ""
        }
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/Bountynew.lua"))()
