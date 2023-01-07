local M = {}

local playerPos = nil

local rock = nil
local rockJbeam = nil
local rockVel = nil

--todo: make these control from the ui app maybe probably not
local minHeight = 4.5 --min and
local maxHeight = 10 --max randomized height above the player to teleport the rocks to
local distXY = 10 --distance from player in X and Y to spawn the cloud. 10 is a pretty good value for most speeds

local lastQuery = 0 --don't touch this
local enabled = false --Don't set this to true. Use a lua trigger to start / stop the teleporting or the enableRocks() function
local paused = false

--spawns the number of rocks specified.
--extensions.rockMadness.spawnRocks(30)
local function spawnRocks(numRocks)
    if not numRocks then numRocks = 30 end
    playerPos = be:getPlayerVehicle(0):getPosition();
    local rockSpawn = vec3(playerPos.x + 50, playerPos.y + 50, playerPos.z + 5)
    local rocks = {}
    for i=1,numRocks do
        rocks[i] = core_vehicles.spawnNewVehicle("rocks", {config='vehicles/rocks/rock5.pc',pos=rockSpawn,autoEnterVehicle=false})
        rocks[i]:setField('name','','rock' .. i)
        rocks[i].playerUsable = false
    end
end

--use to remove the rocks, in case you tab to a rock, or just want them all gone
--this may end up removing other rocks that are manually placed, needs more testing
local function removeRocks()
    for i = be:getObjectCount()-1, 0, -1 do
        rock = be:getObject(i);
        rockJbeam = rock:getField('Jbeam', '')
        if rockJbeam == "rocks" then
            rock:delete()
        end
    end
end

--this is what teleports the rocks to the player
local function teleportRocks(dt)
    if enabled and not paused then
        if not dt then dt = 0.1 end
        local objCount = be:getObjectCount()
        lastQuery = lastQuery  - dt
        if lastQuery <= 0 then
            for i = objCount-1, 0, -1 do
                rock = be:getObject(i)
                rockVel = rock:getVelocity()
                rockJbeam = rock:getField('Jbeam', '')
                playerPos = be:getPlayerVehicle(0):getPosition();
                if rockJbeam == "rocks" then
                    if rockVel.z > -1 then
                        rock:setPosition(vec3(playerPos.x + math.random(-distXY, distXY), playerPos.y + math.random(-distXY, distXY), playerPos.z + math.random(minHeight, maxHeight)));
                        --log('D', 'rocks', 'Teleporting a rock to the player')
                    end
                else
                    return
                end
                lastQuery = 0.25 --adds a delay between the teleportation cycle. Set it to 0, I dare you.
            end
        end
    end
end

local function enableRocks()
    enabled = true
end

local function disableRocks()
    enabled = false
end

local function toggleRocks()
    enabled = not enabled
end

--internal use only
local function onUpdate(dt)
    teleportRocks(dt)
end
--internal use only
local function onPhysicsUnpaused()
    paused = false
end
--internal use only
local function onPhysicsPaused()
    paused = true
end

M.onUpdate = onUpdate
M.onPhysicsPaused = onPhysicsPaused
M.onPhysicsUnpaused = onPhysicsUnpaused
M.spawnRocks = spawnRocks
M.teleportRocks = teleportRocks
M.enableRocks = enableRocks
M.disableRocks = disableRocks
M.toggleRocks = toggleRocks
M.removeRocks = removeRocks

return M