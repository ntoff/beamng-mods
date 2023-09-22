--TO USE:
--add the "generic graph simple" ui app and enable this mod

local M = {}
log("I", "example_generic_graph_simple", "Loaded example mod for the generic graph (simple) ui app.")

local min, max, abs, sqrt = math.min, math.max, math.abs, math.sqrt
local maxRPM = 0
local maxGearIndex = 0
local function onExtensionLoaded()
end

local function onVehicleReset()
log("I","","reset")
end
--local maxGear = todo: this
local function updateGFX()
	if not electrics then return end --in case we're the snowman / walk mode
	if maxRPM <= 0 then
		maxRPM = electrics.values.maxrpm or 0
	end
	if maxGearIndex <= 0 then
		maxGearIndex = electrics.values.maxGearIndex or 0
	end
	guihooks.graph(false,
		--{ key, 	value, 							scale, unit, renderNegatives, color }
		{"throttle", electrics.values.throttle * 100, 100, "%", false, {181, 249, 135, 255 }},
		{"RPM", tonumber(string.format("%.0f", electrics.values.rpmTacho)), maxRPM, "x1", false, {255, 249, 135, 255 }},
        {"gear", electrics.values.gearIndex, maxGearIndex, "", false, {255, 111, 255, 255 }},
		{"brake", electrics.values.brake * 100, 100, "%", false, {255, 111, 111, 255}},
		{"clutch", electrics.values.clutch * 100, 100, "%", false, {135, 200, 249, 255}},
		{"steering", electrics.values.steering_input * 100, 100, "%", true, {255, 255, 255, 255}}
	)
end

M.onVehicleReset = onVehicleReset
M.onExtensionLoaded = onExtensionLoaded
M.updateGFX = updateGFX

return M
