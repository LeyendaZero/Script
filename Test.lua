local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")
local Button = Instance.new("TextButton")

ScreenGui.Parent = Player:FindFirstChildOfClass("PlayerGui")

Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 100, 0, 50)
Button.Position = UDim2.new(0, 10, 0, 10)
Button.Text = "Activar"
Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)

local activo = false

Button.MouseButton1Click:Connect(function()
    activo = not activo
    Button.Text = activo and "Desactivar" or "Activar"

    if activo then
        local dibujo = {
            {10, 20, Color3.fromRGB(255, 0, 0)},
            {15, 25, Color3.fromRGB(0, 255, 0)},
            {20, 30, Color3.fromRGB(0, 0, 255)}
        }

        for _, pixel in pairs(dibujo) do
            if not activo then break end
            local x, y, color = pixel[1], pixel[2], pixel[3]
            UIS.InputBegan:Fire({Position = Vector2.new(x, y), UserInputType = Enum.UserInputType.Touch})
            wait(0.1)
        end
    end
end)
