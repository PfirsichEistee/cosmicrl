
--[[
Item-usage is handled by many different scripts. Only a few general items can be found here.
Example: If you use a job-specific item, the according job-script will catch the event and do something
On the other hand, if you use "general" items, such as hamburgers, the event is handled in here
]]

addEvent("playerUseItem", true) -- ^^^ read above ^^^
addEvent("playerDropItem", true)
addEvent("playerTrashItem", true)


local inv = {}
-- inv[USER ID] = { ..... }


local unusable = { 8, 9, 10, 11, 12, }
local undroppable = { 8, 9, 10, 11, 12, }



function cosmicGetPlayerItem(player, itemID)
	local userID = NameToID(getPlayerName(player))
	
	if userID then
		for a, b in ipairs(inv[userID]) do
			if b.id == itemID then
				return b.amount
			end
		end
		
		return 0
	end
end


function cosmicSetPlayerItem(player, itemID, itemAmount)
	local userID = NameToID(getPlayerName(player))
	
	if userID then
		for a, b in ipairs(inv[userID]) do
			if b.id == itemID then
				b.amount = itemAmount
				triggerClientEvent(player, "clientSyncInventory", player, b, false)
				
				if b.amount == 0 then
					table.remove(inv[userID], a)
				end
				
				return
			end
		end
		
		if itemAmount > 0 then
			local new = {
				id = itemID,
				amount = itemAmount,
			}
			
			table.insert(inv[userID], new)
			triggerClientEvent(player, "clientSyncInventory", player, new, false)
		end
	end
end


function cosmicAddPlayerItem(player, itemID, itemAmount)
	-- RETURNS: True IF SUCCESS; False OTHERWISE
	
	local userID = NameToID(getPlayerName(player))
	
	if userID then
		for a, b in ipairs(inv[userID]) do
			if b.id == itemID then
				if (b.amount + itemAmount) >= 0 then
					b.amount = b.amount + itemAmount
					triggerClientEvent(player, "clientSyncInventory", player, b, false)
					
					if b.amount == 0 then
						table.remove(inv[userID], a)
					end
					
					return true
				else
					return false
				end
			end
		end
		
		if itemAmount > 0 then
			local new = {
				id = itemID,
				amount = itemAmount,
			}
			
			table.insert(inv[userID], new)
			triggerClientEvent(player, "clientSyncInventory", player, new, false)
			
			return true
		end
	end
	return false
end


function cosmicLoadPlayerInventory(userID)
	if not inv[userID] then
		local result = dbPoll(dbQuery(dbHandler, "SELECT Items, Weapons FROM inventory WHERE ID=?", userID), -1)
		
		if result and result[1] then
			-- example: 1-5|4-2|.....
			-- ID-AMOUNT|ID-AMOUNT|.......
			
			local new = {}
			
			for i = 1, 999, 1 do
				local ph = gettok(result[1]["Items"], i, "|")
				
				if ph then
					local item = {
						id = tonumber(gettok(ph, 1, "-")),
						amount = tonumber(gettok(ph, 2, "-")),
					}
					
					table.insert(new, item)
				else
					break
				end
			end
			
			table.insert(inv, new) -- this may be wrong?? inv is a dictionary
			
			local player = getPlayerFromName(IDToName(userID))
			triggerClientEvent(player, "clientSyncInventory", player, new, true)
			
			
			-- load weapons
			for i = 1, 999, 1 do
				local ph = gettok(result[1]["Weapons"], i, "|")
				
				if ph then
					local id = tonumber(gettok(ph, 1, "-"))
					local amount = tonumber(gettok(ph, 2, "-"))
					
					local idk = giveWeapon(player, id, amount)
				else
					break
				end
			end
		end
	else
		local player = getPlayerFromName(IDToName(userID))
		triggerClientEvent(player, "clientSyncInventory", player, inv[userID], true)
	end
end


function cosmicUnloadAndSavePlayerInventory(player)
	local id = NameToID(getPlayerName(player))
	
	if inv[id] then
		local str = ""
		for i = 1, #inv[id], 1 do
			str = str .. inv[id][i].id .. "-" .. inv[id][i].amount
			
			if i ~= #inv[id] then
				str = str .. "|"
			end
		end
		
		
		local gunStr = ""
		for i = 0, 12, 1 do
			local id = getPedWeapon(player, i)
			local amount = getPedTotalAmmo(player, i)
			
			if id ~= 0 and amount > 0 then
				if string.len(gunStr) > 0 then
					gunStr = gunStr .. "|"
				end
				
				gunStr = gunStr .. id .. "-" .. amount
			end
		end
		
		
		dbExec(dbHandler, "UPDATE inventory SET Items=?, Weapons=? WHERE ID=?", str, gunStr, id)
		
		
		inv[id] = nil
	end
end
