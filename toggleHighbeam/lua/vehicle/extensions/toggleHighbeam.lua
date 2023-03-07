local M = {}
local state = 0

local function toggleHighbeam()
    state = electrics.values.lights_state
    if state == 1 then
        electrics.setLightsState(2)
    elseif state == 2 then
        electrics.setLightsState(1)
    end
end

M.toggleHighbeam = toggleHighbeam
return M