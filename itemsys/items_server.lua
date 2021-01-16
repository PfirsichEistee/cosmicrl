

function createItemPickup(x, y, z, id, amount, modelID)
	if not modelID then
		modelID = 1279
	end
	
	local ph = createPickup(x, y, z, 3, modelID, 100)
	cosmicSetElementData(ph, "item_id", id)
	cosmicSetElementData(ph, "item_amount", amount)
end



local function enterItemPickup(player)
	if cosmicGetElementData(source, "item_id") then
		local success = cosmicAddPlayerItem(player, cosmicGetElementData(source, "item_id"), cosmicGetElementData(source, "item_amount"))
		
		if success then
			destroyElement(source)
			
			playSoundFrontEnd(player, 0)
		end
	end
end
addEventHandler("onPickupHit", getRootElement(), enterItemPickup)