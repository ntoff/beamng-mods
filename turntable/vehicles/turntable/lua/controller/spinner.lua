-- This Source Code Form is subject to the terms of the bCDDL, v. 1.1.
-- If a copy of the bCDDL was not distributed with this
-- file, You can obtain one at http://beamng.com/bCDDL-1.1.txt

local M = {}
--Mandatory controller parameters
M.type = "main"
M.relevantDevice = nil
M.engineInfo = {}
M.fireEngineTemperature = 0
M.throttle = 0
M.brake = 0
M.clutchRatio = 0

local min = math.min
local max = math.max
local abs = math.abs

local avToRPM = 9.549296596425384

local motor = nil
local targetRPMRatio = 0
local invMotorMaxAV = 0
local maxRPM = 0
local spinner = nil
local rpmErrorIntegral = 0

local function updateGFX(dt)
  targetRPMRatio = min(max(targetRPMRatio + (electrics.values.targetRPMRatioIncrease * dt * 0.5) - (electrics.values.targetRPMRatioDecrease * dt * 0.5), 0), 1)

  local motorAV = abs(motor.outputAV1)
  local rpmRatio = min(max(motorAV * invMotorMaxAV, 0), 1)
  local isWrongDirection = motor.outputAV1 * motor.motorDirection < 0

  local rpmError = targetRPMRatio - rpmRatio
  rpmErrorIntegral = min(max(rpmErrorIntegral + rpmError * dt, -2), 1)
  local rpmErrorDerivative = rpmError / dt

  local throttle = isWrongDirection and 0 or min(max(rpmError * 0.1 + rpmErrorIntegral * 0.3 + rpmErrorDerivative * 0.02, 0), 1)
  local brake = isWrongDirection and 1 or min(max(-(rpmError * 0.3 + rpmErrorIntegral * 0.1 + rpmErrorDerivative * 0.01), 0), 1)

  if targetRPMRatio == 0 and rpmError < 0.05 then
    brake = 1
    throttle = 0
  end

  spinner.desiredBrakingTorque = brake * spinner.brakeTorque
  electrics.values.throttle = throttle

  electrics.values.brake = brake
  electrics.values.clutch = 0
  electrics.values.clutchRatio = 1
  electrics.values.gear = string.format("%d%%", targetRPMRatio * 100)
  electrics.values.gearIndex = 0
  electrics.values.rpm = motorAV * avToRPM
  electrics.values.oiltemp = 0
  electrics.values.watertemp = 0

  M.engineInfo = {
    electrics.values.rpm,
    maxRPM,
    0,
    0,
    electrics.values.rpm,
    electrics.values.gear,
    0,
    0,
    0,
    0,
    obj:getVelocity():length(), -- airspeed
    0,
    0,
    --, v.data.engine.transmissionType
    "manual",
    obj:getID(),
    0,
    0,
    1
  }
end

local function toggleDirection()
  motor.motorDirection = motor.motorDirection * -1
end

local function setEngineIgnition(enabled)
  if motor then
    motor:setIgnition(enabled and 1 or 0)
  end
end

local function init(jbeamData)
  motor = powertrain.getDevice("motor")
  invMotorMaxAV = 1 / motor.maxAV
  maxRPM = motor.maxAV * avToRPM
  targetRPMRatio = 0
  rpmErrorIntegral = 0
  electrics.values.targetRPMRatioIncrease = 0
  electrics.values.targetRPMRatioDecrease = 0

  for k, v in pairs(wheels.wheelRotators) do
    if v.name == "spin_motor" then
      spinner = wheels.wheelRotators[k]
    end
  end
end

local function sendTorqueData()
  if not playerInfo.firstPlayerSeated then
    return
  end
  if motor then
    motor:sendTorqueData()
  end
end

M.init = init
M.updateGFX = updateGFX

--Mandatory main controller API
M.shiftUp = nop
M.shiftDown = nop
M.shiftToGearIndex = nop
M.cycleGearboxModes = nop
M.setGearboxMode = nop
M.setStarter = nop
M.setEngineIgnition = setEngineIgnition
M.setFreeze = nop
M.vehicleActivated = nop
M.sendTorqueData = sendTorqueData
-------------------------------

M.toggleDirection = toggleDirection

return M
