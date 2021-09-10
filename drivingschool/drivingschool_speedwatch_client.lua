
addEvent("drivingExamStartSpeedWatch", true)


local brake = false
local warns = 0
local speedlimit = 85

local function watchVehicleSpeed()
	local veh = getPedOccupiedVehicle(getLocalPlayer())
	
	if not veh then
		removeEventHandler("onClientRender", getRootElement(), watchVehicleSpeed)
		return
	end
	
	local kmh = (cmath.getElementSpeed(veh) / 1000) * 60 * 60
	
	local vehForward = Matrix(Vector3(getElementPosition(veh)), Vector3(getElementRotation(veh))):getForward()
	local vx, vy, vz = getElementVelocity(veh)
	local angle = cmath.getAngle3D(vehForward.x, vehForward.y, vehForward.z, vx, vy, vz)
	
	
	if not brake and kmh > speedlimit then
		brake = true
		toggleControl("accelerate", false)
		toggleControl("brake_reverse", false)
		
		warns = warns + 1
		triggerServerEvent("drivingExamSyncWarns", getLocalPlayer(), warns)
		outputChatBox("#FFFFFFFahrlehrer#FFFFDD: Du faehrst zu schnell! Das gibt eine Verwarnung!", 255, 255, 255, true)
	end
	
	if brake then
		if angle < (math.pi / 2) then -- driving forwards
			setAnalogControlState("accelerate", 0)
			setAnalogControlState("brake_reverse", 1)
		else -- driving backwards
			setAnalogControlState("accelerate", 1)
			setAnalogControlState("brake_reverse", 0)
		end
		
		if kmh <= 0.1 then
			setAnalogControlState("accelerate", 0)
			setAnalogControlState("brake_reverse", 0)
			
			toggleControl("accelerate", true)
			toggleControl("brake_reverse", true)
			
			brake = false
		end
	end
end



local function drivingExamStartSpeedWatch(start, limit)
	speedlimit = limit
	warns = 0
	if start then
		addEventHandler("onClientRender", getRootElement(), watchVehicleSpeed)
	else
		removeEventHandler("onClientRender", getRootElement(), watchVehicleSpeed)
	end
end
addEventHandler("drivingExamStartSpeedWatch", getRootElement(), drivingExamStartSpeedWatch)