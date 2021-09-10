
local groupName = {}

local groupList = { -- X, Y, W, H (x,y == bottom-left)
	[1] = {
		groupID = nil,
		pickup = createPickup(-2567.8999023438, 957.79998779297, 71.599998474121, 3, 1272, 50),
		gate = {
			createObject(987, -2572.5, 922.40002441406, 64, 0, 0, 0),
			createObject(987, -2562, 989.59997558594, 77.300003051758, 0, 0, 180),
		},
		chest = createObject(3577, -2557, 929.20001220703, 64.800003051758, 0, 0, 30),
		spawn = Vector3(-2547.3999023438, 930.29998779297, 65),
	},
}

for a, b in ipairs(groupList) do
	for c, d in ipairs(b.gate) do
		local x, y, z = getElementPosition(d)
		cosmicSetElementData(d, "ClosedZ", z)
	end
	
	createBlipAttachedTo(b.pickup, 32, 2, 255, 255, 255, 255, 0, 10, getRootElement())
	
	local x, y, z = getElementPosition(b.chest)
	local chestMarker = createMarker(x, y, z, "corona", 4, 255, 0, 0, 255, getRootElement())
	attachElements(b.chest, chestMarker)
end


local function initGroups()
	--local result = dbPoll(dbQuery("SELECT * FROM Groups"), -1)
end
addEventHandler("onResourceStart", resourceRoot, initGroups)


function getGroupName(id)
	return groupName[id]
end


local function openGate(player)
	for a, b in ipairs(groupList) do
		for c, d in ipairs(b.gate) do
			if cmath.distElements(player, d) < 30 then
				local x, y, z = getElementPosition(d)
				
				if z >= (cosmicGetElementData(d, "ClosedZ") - 0.1) then -- its closed
					moveObject(d, 1500, x, y, cosmicGetElementData(d, "ClosedZ") - 6.5)
				else
					local t = (1500 / 6.5) * (cosmicGetElementData(d, "ClosedZ") - z)
					moveObject(d, t, x, y, cosmicGetElementData(d, "ClosedZ"))
				end
			end
		end
	end
end
addCommandHandler("move", openGate)






local function cmd(player)
	setElementPosition(player, -2565.8525390625, 944.29162597656, 67.103088378906)
end
addCommandHandler("ok", cmd)