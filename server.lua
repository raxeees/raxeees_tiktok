webhook = ""    --Here you need to enter your webhook.

local function hasAlreadyRedeemed(identifier)
    local row = MySQL.scalar.await('SELECT identifier FROM redeemed_users WHERE identifier = ?', { identifier })
    return row
end

local function redeem(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local playername = xPlayer.getName()
    
     for k, v in pairs (Config.item) do
     xPlayer.addInventoryItem(v.item, v.count)
    end

    
    local insertsql = MySQL.insert.await('INSERT INTO redeemed_users (identifier) VALUES (?)', { identifier })
    webhook2(webhook, identifier, "Ein Spieler hat den TikTok Command redeemed!", "Munra Roleplay Logs", playername)
end



ESX = exports["es_extended"]:getSharedObject()

RegisterCommand("tiktok", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    if hasAlreadyRedeemed(identifier) then
        print("TikTok-Gift wurde bereits eingelöst!")
    else
        redeem(source)
        print("TikTok-Gift wurde erfolgreich eingelöst!")
    end
end, false)

function webhook2(url, identifier, text, username, playername)
    if url = "" then return end
        local embed = {
            {
                ["color"] = 1127128,                   -- Here you can change the Color for the Webhook
                ["title"] = "TikTok Command Webhook",  -- Here you can change the title for the webhook
                ["description"] = text, 
                ["footer"] = {
                    ["text"] = "Wurde ausgeführt am: " .. os.date("%y/%m/%d %X") .. " von " .. playername .. " | " .. identifier
                },
            }
        }
        PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = username, embeds = embed}), { ['Content-Type'] = 'application/json' })
        end