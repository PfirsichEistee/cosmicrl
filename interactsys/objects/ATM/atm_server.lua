
addEvent("atmPlayerOperation", true)


local function atmPlayerOperation(op, money, receiver, reason)
	local atm = getNearestModelTo(client, 2942)
	if atm and cmath.distElements(client, atm) <= 6 then
		money = tonumber(money)
		
		if money and money > 0 then
			if op == 1 then -- Auszahlen
				if cosmicGetElementData(client, "Bankmoney") >= money then
					cosmicSetElementData(client, "Bankmoney", cosmicGetElementData(client, "Bankmoney") - money)
					cosmicSetElementData(client, "Money", cosmicGetElementData(client, "Money") + money)
					
					triggerClientEvent(client, "infomsg", client, "Du hast $" .. money .. " ausgezahlt.", 75, 75, 255)
					
					
					triggerClientEvent(client, "atmClientGetReceipt", client, -money, "Auszahlung")
				else
					triggerClientEvent(client, "infobox", client, "So viel Geld hast du nicht auf der Bank!", 3, 255, 75, 75)
				end
			elseif op == 2 then -- Einzahlen
				if cosmicGetElementData(client, "Money") >= money then
					cosmicSetElementData(client, "Bankmoney", cosmicGetElementData(client, "Bankmoney") + money)
					cosmicSetElementData(client, "Money", cosmicGetElementData(client, "Money") - money)
					
					triggerClientEvent(client, "infomsg", client, "Du hast $" .. money .. " eingezahlt", 75, 75, 255)
					
					
					triggerClientEvent(client, "atmClientGetReceipt", client, money, "Einzahlung")
				else
					triggerClientEvent(client, "infobox", client, "So viel Geld hast du nicht!", 3, 255, 75, 75)
				end
			elseif op == 3 then -- Ueberweisen
				receiver = getPlayerFromName(receiver)
				
				if receiver then
					if cosmicGetElementData(client, "Bankmoney") >= money then
						cosmicSetElementData(client, "Bankmoney", cosmicGetElementData(client, "Bankmoney") - money)
						cosmicSetElementData(receiver, "Bankmoney", cosmicGetElementData(receiver, "Bankmoney") + money)
						
						triggerClientEvent(client, "infomsg", client, "Du hast $" .. money .. " an " .. getPlayerName(receiver) .. " ueberwiesen", 75, 75, 255)
						triggerClientEvent(receiver, "infomsg", receiver, getPlayerName(client) .. " hat $" .. money .. " auf dein Konto ueberwiesen\n(" .. reason .. ")", 75, 75, 255)
						
						
						triggerClientEvent(client, "atmClientGetReceipt", client, -money, "Ueberweisung")
						triggerClientEvent(receiver, "atmClientGetReceipt", receiver, money, "Ueberweisung")
					else
						triggerClientEvent(client, "infobox", client, "So viel Geld hast du nicht auf der Bank!", 3, 255, 75, 75)
					end
				else
					triggerClientEvent(client, "infobox", client, "Der angegebene Spieler ist nicht online!", 3, 255, 75, 75)
				end
			end
		else
			triggerClientEvent(client, "infobox", client, "Deine Angaben sind fehlerhaft!", 3, 255, 75, 75)
		end
	else
		triggerClientEvent(client, "infobox", client, "Du befindest dich an keinem Geldautomaten!", 3, 255, 75, 75)
	end
end
addEventHandler("atmPlayerOperation", getRootElement(), atmPlayerOperation)