
addEvent("clicksysClicked", true)
-- Parameters: worldX, worldY, worldZ, Element


function clicksysPreClick(button, state, x, y, wx, wy, wz, element)
	-- if button is keyuse then function was called by keyuse_client
	-- Example: pressing 'F' next to an ATM will call this function, which will then open the ATM after a few checks
	
	if button == "left" and state == "up" or button == "keyuse" then
		-- "Cancel" server click if needed here
		-- ...
		-- ...
		
		
		-- If it didnt return then let the server know about the click
		if element then
			if isElementLocal(element) then
				element = nil
			end
		end
		
		if element then
			triggerServerEvent("clicksysClicked", getLocalPlayer(), wx, wy, wz, element)
		end
		
		
		-- ... if server doesnt cancel then "clicksysClicked" will be triggered CLIENTSIDE (-> client knows 2x of the click, preclick (here) and event trigger)
	end
end
addEventHandler("dxgui_OnClick", getRootElement(), clicksysPreClick)


local function toggleCursor()
	showCursor(not isCursorShowing())
end
bindKey("m", "down", toggleCursor)