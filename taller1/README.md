# Taller Flutter: Widgets y Estado

## Descripción
Este taller muestra el uso de widgets básicos y manejo de estado en Flutter. Incluye:
- AppBar con título dinámico usando setState().
- SnackBar al cambiar el título.
- Contador con botones flotantes.
- Dos imágenes (de red y local) debajo del nombre.
- Stack con texto sobre imagen.
- ListView con 4 elementos (icono y texto).

## Pasos para ejecutar
1. Clona el repositorio o descarga el proyecto.
2. Abre la carpeta en VS Code o tu editor favorito.
3. Ejecuta en terminal:
	```
	flutter pub get
	flutter run
	```
4. Asegúrate de tener la imagen local en `assets/images/logo.png` y la ruta registrada en `pubspec.yaml`.

## Funcionamiento
- Estado inicial: El AppBar muestra "Hola, Flutter".
- Al presionar el botón "Siguiente" en el AppBar, el título cambia a "¡Título cambiado!" y aparece un SnackBar con el mensaje "Título actualizado".
- Los widgets adicionales (Stack y ListView) se muestran en la pantalla.

## Capturas

### Estado inicial de la app
![Estado inicial](assets/images/Estado_inicial.png)

### Estado tras presionar el botón (título cambiado + SnackBar)
![Título cambiado y SnackBar](assets/images/Cambiar_titulo.jpg)

### Funcionamiento de los widgets adicionales
![Widgets adicionales](assets/images/Otros_widgets.jpg)

## Datos del estudiante
- Nombre completo: Angie Tatiana Cardenas
- Código: [230221007]
# taller1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
