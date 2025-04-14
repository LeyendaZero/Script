local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local aimEnabled = false
local predictionFactor = 0.1
local aimbotRange = 1000
local ignoredPlayers = {}

-- Crear GUI principal
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

-- Botón flotante para mostrar/ocultar menú
local ToggleMenuBtn = Instance.new("TextButton", ScreenGui)
ToggleMenuBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleMenuBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleMenuBtn.Text = "≡"
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleMenuBtn.TextColor3 = Color3.new(1, 1, 1)

-- Menú principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0, 60, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = true
MainFrame.Draggable = true
MainFrame.Active = true

-- Botón de encendido/apagado
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(1, -20, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "Aimbot: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)

-- Slider de predicción
local PredLabel = Instance.new("TextLabel", MainFrame)
PredLabel.Size = UDim2.new(1, -20, 0, 20)
PredLabel.Position = UDim2.new(0, 10, 0, 50)
PredLabel.Text = "Predicción: 0.1"
PredLabel.TextColor3 = Color3.new(1, 1, 1)
PredLabel.BackgroundTransparency = 1

local PredSlider = Instance.new("TextButton", MainFrame)
PredSlider.Size = UDim2.new(1, -20, 0, 20)
PredSlider.Position = UDim2.new(0, 10, 0, 70)
PredSlider.Text = ""
PredSlider.BackgroundColor3 = Color3.fromRGB(100, 0, 0)

-- Slider de rango
local RangeLabel = Instance.new("TextLabel", MainFrame)
RangeLabel.Size = UDim2.new(1, -20, 0, 20)
RangeLabel.Position = UDim2.new(0, 10, 0, 100)
RangeLabel.Text = "Rango: 1000"
RangeLabel.TextColor3 = Color3.new(1, 1, 1)
RangeLabel.BackgroundTransparency = 1

local RangeSlider = Instance.new("TextButton", MainFrame)
RangeSlider.Size = UDim2.new(1, -20, 0, 20)
RangeSlider.Position = UDim2.new(0, 10, 0, 120)
RangeSlider.Text = ""
RangeSlider.BackgroundColor3 = Color3.fromRGB(0, 100, 0)

-- Función de sliders
local function manejarSlider(slider, label, valorMin, valorMax, onChange)
	slider.MouseButton1Down:Connect(function()
		local moveConn
		moveConn = Mouse.Move:Connect(function()
			local relX = math.clamp(Mouse.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
			local valor = math.round((relX / slider.AbsoluteSize.X) * (valorMax - valorMin) + valorMin, 2)
			onChange(valor)
		end)
		UserInput.InputEnded:Wait()
		moveConn:Disconnect()
	end)
end

manejarSlider(PredSlider, PredLabel, 0, 1, function(val)
	predictionFactor = val
	PredLabel.Text = "Predicción: " .. tostring(val)
end)

manejarSlider(RangeSlider, RangeLabel, 100, 5000, function(val)
	aimbotRange = val
	RangeLabel.Text = "Rango: " .. tostring(val)
end)

-- Botón toggle
ToggleBtn.MouseButton1Click:Connect(function()
	aimEnabled = not aimEnabled
	ToggleBtn.Text = "Aimbot: " .. (aimEnabled and "ON" or "OFF")
	ToggleBtn.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
end)

-- Mostrar/ocultar menú
ToggleMenuBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Crear línea visual
local function crearLinea()
	local a0 = Instance.new("Attachment", Camera)
	local a1 = Instance.new("Attachment")
	local beam = Instance.new("Beam")
	beam.Attachment0 = a0
	beam.Attachment1 = a1
	beam.Color = ColorSequence.new(Color3.new(1, 0, 0))
	beam.Width0 = 0.1
	beam.Width1 = 0.1
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
				local dist = (char.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
				if dist < minDist and dist <= aimbotRange then
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

-- Aimbot loop
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
