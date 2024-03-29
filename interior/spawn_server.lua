
-- [spawnID] = { x, y, z, r, interior, dimension, }
local spawnPoint = {
	[0] = cmath.List(-1967.2296142578, 116.44674682617, 27.6875, 0, 0, 0 ), -- Noobspawn (Bahnhof SF)
}


function cosmicSpawnPlayer(player, id)
	if not id then
		id = cosmicGetElementData(player, "Spawn")
	end
	
	spawnPlayer(player, spawnPoint[id][1], spawnPoint[id][2], spawnPoint[id][3], spawnPoint[id][4], cosmicGetElementData(player, "Skin"), spawnPoint[id][5], spawnPoint[id][6])
	--setElementInterior(player, spawnPoint[id][5])
	--setElementDimension(player, spawnPoint[id][6])
	--setElementPosition(player, spawnPoint[id][1], spawnPoint[id][2], spawnPoint[id][3])
	
	setElementAlpha(player, 255)
	
	setCameraTarget(player, player)
	
	setGhostMode(player, 5000, true)
	
	toggleAllControls(player, true)
end


function cosmicGetSpawnPosition(id)
	return spawnPoint[id][1], spawnPoint[id][2], spawnPoint[id][3]
end
