addEvent("openJobWindow", true)
addEvent("onClientJobStart", true)


local function openJobWindow(id)
	if id == 1 then
		openWindowConstructionWorker()
	end
end
addEventHandler("openJobWindow", getRootElement(), openJobWindow)