
addEvent("townhallBuy", true)

createBlip(-2764.6374511719, 375.53051757813, 6.3418121337891, 56, 2, 255, 255, 255, 255, 0, 10, getRootElement())
local enterMarker = createMarker(-2766, 375.53051757813, 7, "arrow", 1, 255, 255, 0, 255, getRootElement())
local exitMarker = createMarker(389.39999389648, 173.69999694824, 1009, "arrow", 1, 255, 255, 0, 255, getRootElement())
setElementInterior(exitMarker, 3, 389.39999389648, 173.69999694824, 1009)

local npc = createPed(194, 359.71246337891, 173.51145935059, 1008.3828125, 270, false)
setElementFrozen(npc, true)
setElementData(npc, "InvincibleNPC", true)
setElementInterior(npc, 3, 359.71246337891, 173.51145935059, 1008.3828125)


local function enterTownhall(player, matchingDimension)
	if getElementType(player) == "player" and matchingDimension and not getPedOccupiedVehicle(player) then
		setElementFrozen(player, true)
		fadeCamera(player, false)
		
		setTimer(function()
			setElementFrozen(player, false)
			fadeCamera(player, true)
			
			setElementInterior(player, 3, 386.3662109375, 173.8264465332, 1008.3828125)
			setElementRotation(player, 0, 0, 90)
			
			toggleControl(player, "action", false)
			toggleControl(player, "fire", false)
			toggleControl(player, "aim_weapon", false)
			toggleControl(player, "previous_weapon", false)
			toggleControl(player, "sprint", false)
			toggleControl(player, "jump", false)
			toggleControl(player, "crouch", false)
			
			setPedWeaponSlot(player, 0)
		end, 1000, 1)
	end
end
addEventHandler("onMarkerHit", enterMarker, enterTownhall)


local function townhallBuy(license)
	if cosmicGetPlayerItem(client, getItemID(license)) > 0 then
		triggerClientEvent(client, "infobox", client, "Diesen Schein hast du bereits!", 5, 255, 100, 100)
		return
	end
	
	if license == "Personalausweis" and cosmicGetElementData(client, "Money") >= 60 then
		cosmicSetElementData(client, "Money", cosmicGetElementData(client, "Money") - 60)
		triggerClientEvent(client, "infobox", client, "Gekauft!", 5, 100, 255, 100)
		cosmicSetPlayerItem(client, getItemID(license), 1)
	elseif license == "Waffenschein (leicht)" and cosmicGetElementData(client, "Money") >= 6000 then
		cosmicSetElementData(client, "Money", cosmicGetElementData(client, "Money") - 6000)
		triggerClientEvent(client, "infobox", client, "Gekauft!", 5, 100, 255, 100)
		cosmicSetPlayerItem(client, getItemID(license), 1)
	elseif license == "Waffenschein (schwer)" and cosmicGetElementData(client, "Money") >= 32000 then
		cosmicSetElementData(client, "Money", cosmicGetElementData(client, "Money") - 32000)
		triggerClientEvent(client, "infobox", client, "Gekauft!", 5, 100, 255, 100)
		cosmicSetPlayerItem(client, getItemID(license), 1)
	elseif license == "Angelschein" and cosmicGetElementData(client, "Money") >= 800 then
		triggerClientEvent(client, "infomsg", client, "Dieses Item existiert noch nicht", 255, 100, 100)
		--[[cosmicSetElementData(client, "Money", cosmicGetElementData(client, "Money") - 800)
		triggerClientEvent(client, "infobox", client, "Gekauft!", 5, 100, 255, 100)
		cosmicSetPlayerItem(client, getItemID(license), 1)]]
	elseif license == "Fahrzeugslots (10x)" and cosmicGetElementData(client, "Money") >= 15000000 then
		triggerClientEvent(client, "infomsg", client, "Dieses Upgrade existiert noch nicht", 255, 100, 100)
	else
		triggerClientEvent(client, "infobox", client, "Du hast nicht genug Geld!", 5, 255, 100, 100)
	end
end
addEventHandler("townhallBuy", getRootElement(), townhallBuy)




local function cmd(player)
	setElementPosition(player, -2763.01171875, 371.04675292969, 5.8670043945313)
end
addCommandHandler("ok", cmd)