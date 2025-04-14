--// Variables básicas
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local aimEnabled = false
local predictionFactor = 0.1
local ignoredPlayers = {}

--// Crear GUI flotante
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0, 20, 0, 100)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(1, -20, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "Aimbot: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)

local SliderLabel = Instance.new("TextLabel", MainFrame)
SliderLabel.Size = UDim2.new(1, -20, 0, 20)
SliderLabel.Position = UDim2.new(0, 10, 0, 50)
SliderLabel.Text = "Predicción: 0.1"
SliderLabel.TextColor3 = Color3.new(1, 1, 1)
SliderLabel.BackgroundTransparency = 1

local Slider = Instance.new("TextButton", MainFrame)
Slider.Size = UDim2.new(1, -20, 0, 20)
Slider.Position = UDim2.new(0, 10, 0, 75)
Slider.Text = ""
Slider.BackgroundColor3 = Color3.fromRGB(100, 0, 0)

-- Movimiento del slider con clic
Slider.MouseButton1Down:Connect(function()
	local moveConn
	moveConn = Mouse.Move:Connect(function()
		local relX = math.clamp(Mouse.X - Slider.AbsolutePosition.X, 0, Slider.AbsoluteSize.X)
		predictionFactor = math.round((relX / Slider.AbsoluteSize.X) * 100) / 100
		SliderLabel.Text = "Predicción: " .. tostring(predictionFactor)
	end)

	game:GetService("UserInputService").InputEnded:Wait()
	moveConn:Disconnect()
end)

-- Botón toggle
ToggleBtn.MouseButton1Click:Connect(function()
	aimEnabled = not aimEnabled
	ToggleBtn.Text = "Aimbot: " .. (aimEnabled and "ON" or "OFF")
end)

-- Crear línea visual
local function crearLinea()
	local a0 = Instance.new("Attachment", Camera)
	local a1 = Instance.new("Attachment")
	local beam = Instance.new("Beam")
	beam.Attachment0 = a0
	beam.Attachment1 = a1
	beam.Color = ColorSequence.new(Color3.new(1, 0, 0))
	beam.Width0 = 0.05
	beam.Width1 = 0.05
	beam.FaceCamera = true
	beam.Parent = a0
	return a1, beam
end

local function getClosestEnemy()
	local closest, minDist = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and not ignoredPlayers[player.Name] then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local hrp = char.HumanoidRootPart
				local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
				local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
				if onScreen and dist < minDist then
					minDist = dist
					closest = player
				end
			end
		end
	end
	return closest
end

local function predictPosition(target)
	local hrp = target.Character.HumanoidRootPart
	return hrp.Position + hrp.Velocity * predictionFactor
end

local a1, beam = crearLinea()

-- Loop principal
RunService.RenderStepped:Connect(function()
	if not aimEnabled then beam.Enabled = false return end

	local target = getClosestEnemy()
	if target and target.Character then
		local pos = predictPosition(target)
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, pos)
		a1.Parent = target.Character.HumanoidRootPart
		a1.Position = Vector3.new(0, 0, 0)
		beam.Enabled = true
	else
		beam.Enabled = false
	end
end)

--// Ignorar jugadores manualmente:
-- ignoredPlayers["NombreDelJugador"] = true
