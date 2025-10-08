# 📱 Taller Flutter - Desarrollo Móvil UCEVA

## 🎯 Descripción del Proyecto

Este proyecto es una aplicación educativa de Flutter que demuestra conceptos avanzados de **asincronía**, **manejo de tiempo** y **procesamiento paralelo** en el desarrollo móvil. Desarrollado como parte del curso de Desarrollo Móvil de la Universidad UCEVA.

### 📚 Conceptos Implementados

- **Future/Async/Await**: Manejo de operaciones asíncronas
- **Timer**: Cronómetros y actualizaciones periódicas
- **Isolates**: Procesamiento paralelo para tareas pesadas
- **HTTP API**: Consumo de APIs REST con manejo de estados
- **Navegación**: Sistema de rutas con Go Router
- **Estados**: Gestión del ciclo de vida de widgets
- **Variables de Entorno**: Configuración con flutter_dotenv

---

## 🏗️ Arquitectura del Proyecto

```
taller1/
├── lib/
│   ├── main.dart                    # Punto de entrada
│   ├── routes/
│   │   └── app_router.dart         # Configuración de navegación
│   ├── models/
│   │   └── joke.dart              # Modelo de datos con fromJson
│   ├── services/
│   │   └── chuck_norris_service.dart # Servicio HTTP para API
│   ├── views/
│   │   ├── home/                   # Dashboard principal
│   │   ├── future/                 # Demo de Future/Async
│   │   ├── timer/                  # Demo de Timer
│   │   ├── isolate/               # Demo de Isolates
│   │   ├── http-api/              # Consumo de API REST
│   │   ├── paso_parametros/       # Navegación con parámetros
│   │   ├── ciclo_vida/           # Ciclo de vida de widgets
│   │   └── widgets_demo/         # Demostración de widgets
│   ├── widgets/
│   │   ├── base_view.dart        # Layout base consistente
│   │   └── custom_drawer.dart    # Drawer de navegación
│   └── themes/
│       └── app_theme.dart        # Tema personalizado
```

---

## 🎮 Pantallas y Funcionalidades

### 🏠 **Dashboard Principal**
- **Archivo**: `lib/views/home/home_screen.dart`
- **Función**: Punto de entrada con acceso a todas las funcionalidades
- **Características**:
  - Grid de navegación organizado
  - Información del estudiante
  - Acceso al drawer con funciones avanzadas

### ⏰ **Future / Async / Await**
- **Archivo**: `lib/views/future/future_async_screen.dart`
- **Función**: Demuestra manejo de operaciones asíncronas
- **Características**:
  - Múltiples tipos de consultas simuladas
  - Estados de carga, éxito y error
  - Consultas concurrentes con `Future.wait()`
  - Logs detallados en consola

### ⏱️ **Timer / Cronómetro**
- **Archivo**: `lib/views/timer/timer_screen.dart`
- **Función**: Cronómetro completo con estados
- **Características**:
  - Timer que actualiza cada 100ms
  - Estados: Detenido, Corriendo, Pausado
  - Controles: Iniciar, Pausar, Reanudar, Reiniciar
  - Display estilo marcador digital
  - Limpieza automática de recursos

### 🧠 **Isolates Pesados**
- **Archivo**: `lib/views/isolate/isolate_advanced_screen.dart`
- **Función**: Tareas CPU-intensivas en hilos separados
- **Características**:
  - 5 tipos de tareas pesadas diferentes
  - Ejecución individual o en paralelo
  - Estadísticas de rendimiento
  - UI que nunca se bloquea

### 🌐 **HTTP API - Chuck Norris Facts**
- **Archivos**: `lib/views/http-api/http_api_screen.dart` y `joke_detail_screen.dart`
- **Función**: Consumo completo de API REST
- **Características**:
  - **Listado**: ListView.builder con imágenes y estados
  - **Detalle**: Navegación con go_router y parámetros
  - **Estados**: Loading, éxito, error con UI apropiada
  - **Búsqueda**: Por texto libre y filtro por categorías
  - **Manejo de errores**: Try/catch con mensajes amigables
  - **Service separado**: Lógica HTTP independiente
  - **Model con fromJson**: Parseo automático de JSON
  - **Variables de entorno**: Configuración con .env

---

## 🔄 Flujos de Trabajo

### 📊 **Flujo del Cronómetro**

```
[Detenido] --Iniciar--> [Corriendo] --Pausar--> [Pausado]
    ^                        |                     |
    |                   Reiniciar             Reanudar
    |                        |                     |
    +------------------------+                     |
    |                                              |
    +----------------------------------------------+
                    Reiniciar
```

**Estados del Timer:**
1. **Detenido** ⚫: Tiempo en 00:00:00, puede iniciar
2. **Corriendo** 🟢: Timer activo, actualiza cada 100ms
3. **Pausado** 🟡: Timer detenido temporalmente, mantiene tiempo

### 🔀 **Flujo de Isolates**

```
[Solicitar Tarea] → [Crear Isolate] → [Configurar Comunicación] 
       ↓
[Enviar Parámetros] → [Ejecutar Tarea Pesada] → [Enviar Resultado]
       ↓
[Actualizar UI] → [Limpiar Isolate]
```

**Tipos de Tareas:**
1. **Fibonacci(35)**: Cálculo recursivo ~1-2 segundos
2. **Números Primos**: Encuentra primos hasta 100,000
3. **Bubble Sort**: Ordena 5,000 números (O(n²))
4. **Matriz Grande**: Procesa matriz 200x200
5. **Big Data**: Genera 50,000 registros JSON

---

## 📘 Cuándo Usar Cada Tecnología

### 🎯 **Future / Async / Await**

**✅ Usar cuando:**
- Consultas a APIs o bases de datos
- Operaciones de archivo (lectura/escritura)
- Navegación entre pantallas con datos
- Cualquier operación que pueda tardar tiempo

**❌ No usar cuando:**
- Tareas que requieren procesamiento intensivo de CPU
- Operaciones que bloquearían la UI por más de unos segundos
- Cálculos matemáticos complejos

**💡 Ejemplo de uso:**
```dart
Future<List<User>> fetchUsers() async {
  final response = await http.get('/api/users');
  return User.fromJsonList(response.data);
}
```

### ⏲️ **Timer**

**✅ Usar cuando:**
- Cronómetros y temporizadores
- Actualizaciones periódicas de UI
- Animaciones personalizadas
- Polling de datos en intervalos

**❌ No usar cuando:**
- Animaciones complejas (usar AnimationController)
- Operaciones únicas (usar Future)
- Tareas que requieren alta precisión temporal

**💡 Ejemplo de uso:**
```dart
Timer.periodic(Duration(seconds: 1), (timer) {
  setState(() {
    currentTime = DateTime.now();
  });
});
```

### 🔀 **Isolates**

**✅ Usar cuando:**
- Procesamiento de imágenes grandes
- Cálculos matemáticos complejos
- Parsing de archivos JSON/XML grandes
- Algoritmos de ordenamiento/búsqueda
- Cualquier tarea que bloquee la UI

**❌ No usar cuando:**
- Operaciones simples y rápidas
- Consultas de red (usar Future)
- Operaciones que requieren acceso a UI
- Tareas que usan plugins de plataforma

**💡 Ejemplo de uso:**
```dart
// Para procesar imagen grande sin bloquear UI
await Isolate.spawn(processImageIsolate, imagePath);
```

---

## 🎨 Navegación y UX

### 📱 **Drawer Organizado**

**Navegación Principal:**
- 🏠 Inicio
- ↔️ Paso de Parámetros
- 🌀 Ciclo de Vida
- 🧩 Demo de Widgets

**Funcionalidades Avanzadas:**
- ⏰ Future / Async
- ⏱️ Timer
- 🧠 Isolates
- 🌐 HTTP API

### 🎯 **Principios de UX Aplicados**

1. **Estados Visuales Claros**: Cada operación muestra su estado
2. **Feedback Inmediato**: Loading indicators y mensajes
3. **Navegación Intuitiva**: Drawer organizado por categorías
4. **Consistencia Visual**: BaseView para layout uniforme
5. **Gestión de Recursos**: Limpieza automática en dispose()

---

## 🌐 Chuck Norris API - Implementación Completa

### 📋 **Requisitos Cumplidos**

#### **1) Consumo de API y Listado**
- **ListView.builder** con renderizado eficiente
- **Imágenes** mostradas con Image.network y manejo de errores
- **Estados completos**: Loading (CircularProgressIndicator), Éxito, Error
- **Service separado**: `ChuckNorrisService` con lógica HTTP independiente
- **Model con fromJson**: `Joke` model con parseo automático de JSON

#### **2) Detalle con navegación (go_router)**
- **Navegación**: `context.push('/joke_detail', extra: joke)`
- **Parámetros**: Objeto Joke completo pasado como extra
- **Pantalla detalle**: Información ampliada con imagen y metadatos
- **Botón atrás**: `context.pop()` funcional

#### **3) Manejo de estado y validación**
- **Try/catch**: En todos los métodos del servicio
- **StatusCode**: Verificación de response.statusCode == 200
- **Estados en UI**: LoadingState enum con switch case
- **Excepciones específicas**: TimeoutException, SocketException, etc.

#### **4) Buenas prácticas mínimas**
- **Peticiones en initState()**: No en build()
- **Async/await**: Implementación correcta sin bloquear UI
- **Mensajes claros**: SnackBar para errores de red
- **Variables de entorno**: Configuración con flutter_dotenv

### 🛠️ **API Endpoints Utilizados**

```dart
// Chiste aleatorio
GET https://api.chucknorris.io/jokes/random

// Chiste por categoría
GET https://api.chucknorris.io/jokes/random?category={category}

// Buscar chistes
GET https://api.chucknorris.io/jokes/search?query={query}

// Obtener categorías
GET https://api.chucknorris.io/jokes/categories
```

### 📱 **Funcionalidades Extra Implementadas**

- **Búsqueda en tiempo real** con validación
- **Filtro por categorías** con dropdown
- **Pull-to-refresh** en la lista
- **Carga paralela** de múltiples chistes
- **Deduplicación** por ID de chiste
- **Estados de carga en imágenes** con placeholders
- **Botones de acción** (Copiar, Compartir)
- **Configuración de timeout** (10 segundos)

### 🎯 **Arquitectura Implementada**

```
HTTP API Flow:
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   UI Screen     │───▶│   Service Layer  │───▶│   API External  │
│ (HttpApiScreen) │    │(ChuckNorrisServ.)│    │ (chucknorris.io)│
└─────────────────┘    └──────────────────┘    └─────────────────┘
         ▲                       ▲                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   UI States     │    │   Data Models    │    │   JSON Response │
│ (LoadingState)  │    │   (Joke.dart)    │    │   (Chuck Norris)│
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

---

## 👥 Información del Proyecto

**Estudiante**: Angie Tatiana Cardenas Quintero  
**Código**: 230221007  
**Universidad**: UCEVA (Unidad Central del Valle del Cauca)  
**Curso**: Desarrollo de Aplicaciones Móviles  
**Tecnología**: Flutter & Dart  
**Fecha**: Octubre 2025
---

## 🗺️ Rutas de Navegación

La app usa `go_router` para navegación declarativa:

```dart
// Rutas principales
- `/` : HomeScreen (dashboard principal)
- `/paso_parametros` : PasoParametrosScreen (navegación con parámetros)
- `/detalle/:parametro/:metodo` : DetalleScreen (pantalla de detalles)
- `/ciclo_vida` : CicloVidaScreen (ciclo de vida de widgets)
- `/widgets_demo` : WidgetsDemoScreen (demostración de widgets)

// Rutas avanzadas
- `/future_async` : FutureAsyncScreen (demo de asincronía)
- `/timer` : TimerScreen (cronómetro con Timer)
- `/isolate` : IsolateAdvancedScreen (tareas pesadas en isolates)
- `/http_api` : HttpApiScreen (listado de chistes de Chuck Norris)
- `/joke_detail` : JokeDetailScreen (detalle del chiste con parámetros)
```

---

## 🧩 Widgets y Componentes Utilizados

### 📱 **Widgets de UI**
- **GridView**: Dashboards y galerías organizadas
- **TabBar + TabBarView**: Contenido en pestañas navegables
- **ListView**: Listas verticales de elementos
- **CustomDrawer**: Menú lateral organizado por categorías
- **BaseView**: Layout consistente para todas las pantallas

### 🎯 **Widgets de Estado**
- **StatefulWidget**: Para componentes con manejo de estado
- **CircularProgressIndicator**: Indicadores de carga
- **SnackBar**: Feedback al usuario
- **ElevatedButton**: Botones de acción principales

### 🎨 **Widgets de Presentación**
- **Card**: Contenedores con elevación
- **Container**: Layout y decoración
- **Image (network/asset)**: Recursos visuales
- **Text con estilos**: Tipografía consistente

---

