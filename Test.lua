local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Crear la línea (Beam visual)
local function crearLinea()
	local attachment0 = Instance.new("Attachment", Camera)
	local attachment1 = Instance.new("Attachment")
	local beam = Instance.new("Beam")
	beam.Attachment0 = attachment0
	beam.Attachment1 = attachment1
	beam.Color = ColorSequence.new(Color3.new(1, 0, 0))
	beam.Width0 = 0.05
	beam.Width1 = 0.05
	beam.FaceCamera = true
	beam.Parent = attachment0
	return attachment1, beam
end

local function getClosestEnemy()
	local closest = nil
	local minDist = math.huge

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
			local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

			if onScreen and dist < minDist then
				minDist = dist
				closest = player
			end
		end
	end

	return closest
end

local function predictPosition(target, factor)
	local hrp = target.Character.HumanoidRootPart
	local velocity = hrp.Velocity
	return hrp.Position + velocity * factor
end

-- Línea roja al objetivo
local attachment1, beam = crearLinea()

RunService.RenderStepped:Connect(function()
	local target = getClosestEnemy()
	if target and target.Character then
		local predictedPos = predictPosition(target, 0.1)
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPos)

		-- Mover la línea al enemigo
		attachment1.Parent = target.Character.HumanoidRootPart
		attachment1.Position = Vector3.new(0, 0, 0)
		beam.Enabled = true
	else
		beam.Enabled = false
	end
end)
