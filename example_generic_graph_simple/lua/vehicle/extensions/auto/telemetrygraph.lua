--TO USE:
--add the "generic graph simple" ui app and enable this mod

local M = {}
log("I", "example_generic_graph_simple", "Loaded example mod for the generic graph (simple) ui app.")
local function updateGFX()
	guihooks.graph(false,
		{"throttle", electrics.values.throttle * 100, 100, "%", false, {181, 249, 135, 255 }},
		{"brake", electrics.values.brake * 100, 100, "%", false, {255, 111, 111, 255}},
		{"clutch", electrics.values.clutch * 100, 100, "%", false, {135, 200, 249, 255}},
		{"steering", electrics.values.steering_input * 100, 100, "%", true, {255, 255, 255, 255}}
	)
end

M.updateGFX = updateGFX

return M