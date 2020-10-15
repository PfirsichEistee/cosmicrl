
local dxele
local mouseDown = false
local mx = 0


local function mechDraw(obj, delta, plusX, plusY)
	if mouseDown then
		if (mouseX - mx) ~= 0 then
			mechanicCameraRotate(mouseX - mx)
			
			mx = mouseX
		end
	end
end


local function mechClick(obj, down, x, y)
	if not obj.enabled then
		mouseDown = false
		return
	end
	
	mouseDown = down
	
	if down then
		mx = mouseX
	end
end


function dxguiCreateMechanicRotator()
	if dxele then
		return
	end
	
	mouseDown = false
	
	dxele = dxgui_CreateCustom(0, 0, screenX, screenY, mechDraw, mechClick, nil, nil, false, nil)
	
	local obj = dxgui_GetElementTable(dxele)
	
	obj.stayInBackground = true
end


function dxguiRemoveMechanicRotator()
	mouseDown = false
	
	dxgui_Kill(dxele)
	
	dxele = nil
end