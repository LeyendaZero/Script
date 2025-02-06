local VirtualInputManager = game:GetService("VirtualInputManager")

local dibujo = {
    {600, 400}, -- Reemplaza con las coordenadas exactas del lienzo
    {610, 410},
    {620, 420},
    {630, 430}
}

for _, pixel in pairs(dibujo) do
    local x, y = pixel[1], pixel[2]
    
    -- Simula tocar la pantalla
    VirtualInputManager:SendTouchEvent(x, y, 0, true, game, 1)
    wait(0.05) -- Espera para que el trazo se vea mejor
    VirtualInputManager:SendTouchEvent(x, y, 0, false, game, 1)
end
