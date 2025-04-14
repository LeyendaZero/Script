local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function getClosestPlayer()
    local maxDist = math.huge
    local closest = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

            if onScreen and dist < maxDist then
                maxDist = dist
                closest = player
            end
        end
    end

    return closest
end

-- Predicción simple (sin gravedad ni delay real)
local function predictPosition(target, velocityFactor)
    local hrp = target.Character.HumanoidRootPart
    local velocity = hrp.Velocity
    return hrp.Position + velocity * velocityFactor
end

-- Aimbot loop
game:GetService("RunService").RenderStepped:Connect(function()
    local target = getClosestPlayer()
    if target and target.Character then
        local aimPos = predictPosition(target, 0.1) -- puedes ajustar el factor
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, aimPos)
    end
end)
