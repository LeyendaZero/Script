from PIL import Image
import numpy as np

# Cargar la imagen
imagen = Image.open('imagen.jpg')

# Redimensionar la imagen
nuevo_tamano = (50, 50)  # Ajusta este tamaño según tus necesidades
imagen = imagen.resize(nuevo_tamano)

# Convertir la imagen a una matriz numpy
matriz_pixeles = np.array(imagen)

# Obtener las dimensiones de la imagen
alto, ancho, _ = matriz_pixeles.shape

# Crear una lista para almacenar las coordenadas y colores
lista_coordenadas_colores = []

# Recorrer cada píxel de la imagen
for y in range(alto):
    for x in range(ancho):
        # Obtener el color del píxel (R, G, B)
        color = matriz_pixeles[y, x]
        # Almacenar la coordenada y el color
        lista_coordenadas_colores.append(((x, y), tuple(color)))

# Mostrar las primeras 10 coordenadas y colores
for i in range(10):
    print(lista_coordenadas_colores[i])
