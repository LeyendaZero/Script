warn("Loaded Turret Auto Aim (Head Prediction + Toggle)")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local BulletSpeed = 800
local AimbotEnabled = false

-- Tecla para activar/desactivar (F)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        AimbotEnabled = not AimbotEnabled
        warn("Aimbot " .. (AimbotEnabled and "ON" or "OFF"))
    end
end)

local function getClosestEnemy()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = myChar.HumanoidRootPart.Position

    local closest, shortestDistance = nil, math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
            local char = player.Character
            if char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local dist = (char.Head.Position - myPos).Magnitude
                    if dist < shortestDistance then
                        closest = player
                        shortestDistance = dist
                    end
                end
            end
        end
    end

    return closest
end

local function getTravelTime(targetPosition)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return 0 end
    local origin = char.HumanoidRootPart.Position
    local distance = (targetPosition - origin).Magnitude
    return distance / BulletSpeed
end

local function predictPosition(part, travelTime)
    local velocity = part and part.Velocity or Vector3.zero
    return part.Position + velocity * travelTime
end

RunService.Heartbeat:Connect(function()
    if not AimbotEnabled then return end

    local target = getClosestEnemy()
    if target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        if head then
            local travelTime = getTravelTime(head.Position)
            local predictedPosition = predictPosition(head, travelTime)
            ReplicatedStorage:WaitForChild("Event"):FireServer("aim", {predictedPosition})
        end
    end
end)
