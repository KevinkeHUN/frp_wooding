local WEBHOOK_LINK = "" ---- Discord Webhook
local DISCORD_NAME = "" ---- Szerver Név
local DISCORD_IMAGE = ""  ---- Kép

function sendToDiscord(name, message, color)
	local connect = {
		  {
			  ["color"] = color,
			  ["title"] = "**".. name .."**",
			  ["description"] = message,
			  ["footer"] = {
			  ["text"] = "", ---- Szerver Név
			  }, 
		  }
	  }
	PerformHttpRequest(WEBHOOK_LINK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatarrl = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end