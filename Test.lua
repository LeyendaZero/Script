local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Lista de puntos a dibujar (X, Y, Color)
local dibujo = {
    {10, 20, Color3.fromRGB(255, 0, 0)},
    {15, 25, Color3.fromRGB(0, 255, 0)},
    {20, 30, Color3.fromRGB(0, 0, 255)}
}

-- Función para simular un toque en móvil
for _, pixel in pairs(dibujo) do
    local x, y, color = pixel[1], pixel[2], pixel[3]

    -- Simula un toque en la pantalla en esa posición
    UIS.InputBegan:Fire({Position = Vector2.new(x, y), UserInputType = Enum.UserInputType.Touch})

    wait(0.1) -- Pequeña pausa entre cada punto dibujado
end
