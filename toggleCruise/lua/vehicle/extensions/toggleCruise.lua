local M = {}
local on = nil
local function toggleCruise()
    on = extensions.cruiseControl.getConfiguration().isEnabled
    extensions.cruiseControl.setEnabled(not on)
end
M.toggleCruise = toggleCruise
return M