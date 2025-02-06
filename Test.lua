local VirtualInputManager = game:GetService("VirtualInputManager")
local screenWidth, screenHeight = game:GetService("GuiService"):GetScreenResolution()

-- Establece el punto de inicio en el lienzo (ajústalo si es necesario)
local startX, startY = screenWidth * 0.5, screenHeight * 0.5 
local endX, endY = startX + 100, startY + 50  

-- Mantiene el toque en el punto inicial
VirtualInputManager:SendTouchEvent(startX, startY, 0, true, game, 1)
wait(0.2)

-- Mueve el toque en pequeños pasos
for i = 1, 10 do
    local x = startX + (endX - startX) * (i / 10)
    local y = startY + (endY - startY) * (i / 10)
    VirtualInputManager:SendTouchEvent(x, y, 0, true, game, 1)
    wait(0.05)
end

-- Suelta el toque
VirtualInputManager:SendTouchEvent(endX, endY, 0, false, game, 1)
