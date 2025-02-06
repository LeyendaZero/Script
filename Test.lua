local VirtualInputManager = game:GetService("VirtualInputManager")
local screenWidth, screenHeight = game:GetService("GuiService"):GetScreenResolution()

-- Ajusta estas coordenadas según el tamaño de la pantalla
local startX, startY = screenWidth * 0.4, screenHeight * 0.3
local endX, endY = screenWidth * 0.6, screenHeight * 0.5

-- Simula tocar el lienzo y arrastrar
VirtualInputManager:SendTouchEvent(startX, startY, 0, true, game, 1)
wait(0.2) -- Mantiene el toque por un instante

for i = 0, 1, 0.1 do
    local x = startX + (endX - startX) * i
    local y = startY + (endY - startY) * i
    VirtualInputManager:SendTouchEvent(x, y, 0, true, game, 1)
    wait(0.05)
end

VirtualInputManager:SendTouchEvent(endX, endY, 0, false, game, 1) -- Suelta el toque
