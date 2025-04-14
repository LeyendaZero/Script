--// CONFIGURACIONES
local AimbotEnabled = true
local AimbotRange = 200
local IgnoredPlayers = {}
local AimPartName = "Head" -- Parte si no se detecta vehículo

--// VARIABLES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

--// GUI HUD
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AimbotHUD"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 180, 0, 160)
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
	AimbotRange = AimbotRange + 50
end)

createButton("Reducir Rango", 70, function()
	AimbotRange = math.max(50, AimbotRange - 50)
end)

createButton("Ocultar HUD", 105, function()
	Frame.Visible = false
end)

-- Botón flotante para abrir menú
local FloatButton = Instance.new("TextButton", ScreenGui)
FloatButton.Size = UDim2.new(0, 50, 0, 50)
FloatButton.Position = UDim2.new(0, 10, 0, 40)
FloatButton.Text = "☰"
FloatButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
FloatButton.TextColor3 = Color3.new(1, 1, 1)
FloatButton.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)

--// BEAM LINEA ROJA
local BeamLine = Drawing.new("Line")
BeamLine.Visible = false
BeamLine.Thickness = 2
BeamLine.Color = Color3.fromRGB(255, 0, 0)

--// FUNCIONES
local function getTarget()
	local closest = nil
	local closestDist = AimbotRange

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and not IgnoredPlayers[player.Name] and player.Team ~= LocalPlayer.Team then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local targetPart = char:FindFirstChild(AimPartName) or char:FindFirstChild("HumanoidRootPart")

				-- Detectar vehículo montado
				local vehicle = nil
				for _, part in pairs(workspace:GetDescendants()) do
					if part:IsA("VehicleSeat") and part.Occupant and part.Occupant.Parent == char then
						vehicle = part.Parent
						break
					end
				end

				if vehicle and vehicle:IsA("Model") and vehicle.PrimaryPart then
					targetPart = vehicle.PrimaryPart
				end

				if targetPart then
					local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
					local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - UserInputService:GetMouseLocation()).Magnitude
					if dist < closestDist and onScreen then
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
	if not AimbotEnabled then
		BeamLine.Visible = false
		return
	end

	local target = getTarget()

	if target then
		local targetPos = target.Position
		local screenPos, visible = Camera:WorldToViewportPoint(targetPos)

		if visible then
			-- Aimbot mira
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)

			-- Línea roja
			BeamLine.Visible = true
			BeamLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
			BeamLine.To = Vector2.new(screenPos.X, screenPos.Y)
		else
			BeamLine.Visible = false
		end
	else
		BeamLine.Visible = false
	end
end)
