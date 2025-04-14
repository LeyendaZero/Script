--// CONFIGURACIONES
local AimbotEnabled = true
local AimbotRange = 200
local CircleRadius = 150
local IgnoredPlayers = {}
local AimPartName = "Head"

--// VARIABLES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--// GUI HUD
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AimbotHUD"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 180, 0, 190)
Frame.Position = UDim2.new(0, 10, 0, 100)
Frame.BackgroundTransparency = 0.3
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.BorderSizePixel = 0
Frame.Visible = true

local function createButton(text, yPos, callback)
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.Position = UDim2.new(0, 0, 0, yPos)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	btn.MouseButton1Click:Connect(callback)
end

createButton("Toggle Aimbot", 0, function()
	AimbotEnabled = not AimbotEnabled
end)

createButton("Aumentar Rango", 35, function()
	AimbotRange += 50
end)

createButton("Reducir Rango", 70, function()
	AimbotRange = math.max(50, AimbotRange - 50)
end)

createButton("Aumentar Círculo", 105, function()
	CircleRadius += 25
end)

createButton("Reducir Círculo", 140, function()
	CircleRadius = math.max(50, CircleRadius - 25)
end)

createButton("Ocultar HUD", 175, function()
	Frame.Visible = false
end)

local FloatButton = Instance.new("TextButton", ScreenGui)
FloatButton.Size = UDim2.new(0, 50, 0, 50)
FloatButton.Position = UDim2.new(0, 10, 0, 40)
FloatButton.Text = "☰"
FloatButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
FloatButton.TextColor3 = Color3.new(1, 1, 1)
FloatButton.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)

--// CÍRCULO DE ENFOQUE
local Circle = Drawing.new("Circle")
Circle.Visible = true
Circle.Color = Color3.new(1, 0, 0)
Circle.Thickness = 1
Circle.Filled = false
Circle.Radius = CircleRadius
Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

--// FUNCIONES
local function getTarget()
	local mousePos = UserInputService:GetMouseLocation()
	local closest = nil
	local closestDist = AimbotRange

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and not IgnoredPlayers[player.Name] and player.Team ~= LocalPlayer.Team then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local targetPart = char:FindFirstChild(AimPartName) or char:FindFirstChild("HumanoidRootPart")

				-- Detectar vehículo
				for _, part in pairs(workspace:GetDescendants()) do
					if part:IsA("VehicleSeat") and part.Occupant and part.Occupant.Parent == char then
						if part.Parent:IsA("Model") and part.Parent.PrimaryPart then
							targetPart = part.Parent.PrimaryPart
						end
						break
					end
				end

				if targetPart then
					local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
					local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude

					if dist < closestDist and dist < CircleRadius and onScreen then
						closest = targetPart
						closestDist = dist
					end
				end
			end
		end
	end

	return closest
end

--// LOOP
RunService.RenderStepped:Connect(function()
	Circle.Radius = CircleRadius
	Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

	if not AimbotEnabled then return end

	local target = getTarget()
	if target then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
	end
end)
