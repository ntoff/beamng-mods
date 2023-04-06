local M = {}
local state = 0
local function toggleFov()
    state = settings.getValue('cameraDriverFov')
    if state == 75 then
        settings.setValue('cameraDriverFov', 55)
        ui_message("FOV = 55", 10, 'Camera', "")
    elseif state == 55 then
        settings.setValue('cameraDriverFov', 65)
        ui_message("FOV = 65", 10, 'Camera', "")
    elseif state == 65 then
        settings.setValue('cameraDriverFov', 75)
        ui_message("FOV = 75", 10, 'Camera', "")
    end
end

M.toggleFov = toggleFov
return M