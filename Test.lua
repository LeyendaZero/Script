-- CONFIG
local AimbotEnabled = true
local AimStrength = 0.1 -- 0.1 = suave, 1 = fuerte
local AimPart = "Head"
local Radius = 150

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

-- CIRCLE (visual opcional)
local Circle = Drawing.new("Circle")
Circle.Thickness = 1
Circle.Color = Color3.new(1, 0, 0)
Circle.Filled = false
Circle.Visible = true

-- TARGET
local function getClosest()
	local closest, minDist = nil, Radius
	local mouse = UIS:GetMouseLocation()

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
			local char = plr.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local part = char:FindFirstChild(AimPart) or char:FindFirstChild("HumanoidRootPart")

				for _, desc in pairs(workspace:GetDescendants()) do
					if desc:IsA("VehicleSeat") and desc.Occupant and desc.Occupant.Parent == char then
						if desc.Parent:IsA("Model") and desc.Parent.PrimaryPart then
							part = desc.Parent.PrimaryPart
						end
					end
				end

				if part then
					local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
					local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude

					if onScreen and dist < minDist then
						closest = part
						minDist = dist
					end
				end
			end
		end
	end

	return closest
end

-- LOOP
RunService.RenderStepped:Connect(function()
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	Circle.Position = center
	Circle.Radius = Radius

	if AimbotEnabled then
		local target = getClosest()
		if target then
			local targetPos = target.Position
			local direction = (targetPos - Camera.CFrame.Position).Unit
			local newLook = Camera.CFrame.Position + direction * AimStrength
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, newLook)
		end
	end
end)
