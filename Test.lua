-- CONFIG
local AimbotEnabled = true
local CircleRadius = 150
local PredictionTime = 0.15 -- 0.15s adelante
local AimPart = "Head"

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

-- GUI HUD
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 100)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.2
frame.Visible = true

local function button(text, y, callback)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1, 0, 0, 30)
	b.Position = UDim2.new(0, 0, 0, y)
	b.Text = text
	b.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.MouseButton1Click:Connect(callback)
end

button("Toggle Aimbot", 0, function() AimbotEnabled = not AimbotEnabled end)
button("Aumentar Rango", 35, function() CircleRadius += 25 end)
button("Reducir Rango", 70, function() CircleRadius = math.max(50, CircleRadius - 25) end)

local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 40, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 50)
toggle.Text = "☰"
toggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- CIRCLE DRAWING
local Circle = Drawing.new("Circle")
Circle.Thickness = 1
Circle.Color = Color3.new(1, 0, 0)
Circle.Filled = false
Circle.Visible = true

-- FIND CLOSEST TARGET
local function getClosest()
	local closest, minDist = nil, CircleRadius
	local mouse = UIS:GetMouseLocation()

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
			local char = plr.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local part = char:FindFirstChild(AimPart) or char:FindFirstChild("HumanoidRootPart")

				-- Buscar si está en vehículo
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

-- AIMBOT LOOP
RunService.RenderStepped:Connect(function()
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	Circle.Position = center
	Circle.Radius = CircleRadius

	if AimbotEnabled then
		local target = getClosest()
		if target then
			local vel = target.Velocity
			local predicted = target.Position + (vel * PredictionTime)
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, predicted)
		end
	end
end)
