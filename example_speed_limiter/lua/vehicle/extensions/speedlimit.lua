--PID limiter code shamelessly stolen from lua/vehicle/controller/vehicleController - line: 456 (as of 0.29)
--some vehicles have a topSpeedLimit vehicle controller value settable via vehicle tuning but I can't find a way to interact with that variable via lua dynamically
--This is essentially some of the same code that topSpeedLimit uses.

local M = {}

local speedLimit = 80/3.6 --math coz I cbf. divide km/h by 3.6 to get the value beam wants
local topSpeedLimitPID = newPIDParallel(0.2, 0.9, 0, 0, 1, 1, 1, 0, 1) --may need tuning to suit a particular vehicle.
local limitEnabled = false

local function updateGFX(dt)
	if limitEnabled then

		local vehicleSpeed = electrics.values.wheelspeed or 0
		
		if vehicleSpeed >= speedLimit then
			local speedError = vehicleSpeed - speedLimit
			local throttleCoef = 1 - topSpeedLimitPID:get(-speedError, 0, dt)
			topSpeedLimitPID:setConfig(0.2, 0.9, throttleCoef, 0, 1, 1, 1, 0, 1)
			electrics.values.throttle = electrics.values.throttle * throttleCoef
		end
	--I don't like that there's no else here. I don't know if this'll result in some weird timing issues where it gets turned on / off mid update and the throttle input gets blocked.
	end
end

local function toggleNotifier()
	guihooks.message("Temporary speed limiter " .. ((limitEnabled) and "enabled" or "disabled"), 5, "")
end

local function toggleLimiter(state)
	--sometimes enables/disables in rapid succession, needs debounce perhaps (my controller is broken)
	if state == nil then
		limitEnabled = not limitEnabled
	else
		limitEnabled = state
	end
	toggleNotifier()
end

local function onReset()
	toggleLimiter(false)
end

local function onVehicleSwitched() --because loading a new config would leave the limiter on, not entirely sure this is the right function? callback? thing! to call but it works
	toggleLimiter(false)
end

M.onReset = onReset
M.onVehicleSwitched = onVehicleSwitched
M.toggleLimiter = toggleLimiter
M.toggleNotifier = toggleNotifier
M.updateGFX = updateGFX

return M