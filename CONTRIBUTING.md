# CONTRIBUTING.md

## 🚀 ¡Gracias por tu interés en contribuir a **Sanamente**!

Sanamente es un proyecto para monitorear el estado de ánimo, orientado principalmente a estudiantes en un entorno de pruebas, con soporte para emuladores y opciones de despliegue en producción. Este archivo detalla cómo puedes contribuir eficazmente al proyecto.

---

## 1. Introducción y Agradecimientos

¡Bienvenido(a) al desarrollo de Sanamente! 🎉

Apreciamos tu interés en colaborar y mejorar esta plataforma. Este proyecto se basa en Flutter y Firebase, y está diseñado para ser modular y escalable.

---

## 2. Cómo Contribuir

### 2.1 Flujo de Trabajo Estándar
1. **Forkea el repositorio:** Haz clic en el botón `Fork` en GitHub.
2. **Clona tu fork localmente:**

   ```bash
   git clone https://github.com/tu-usuario/sanamente.git
   cd sanamente
   ```
3. **Crea una nueva rama:**

   ```bash
   git checkout -b feature/nueva-funcionalidad
   ```
4. **Desarrolla y prueba tus cambios:** Asegúrate de seguir los estándares establecidos.
5. **Realiza un commit con un mensaje descriptivo:**

   ```bash
   git add .
   git commit -m "feat: descripción de los cambios"
   ```
6. **Sube tus cambios a tu fork:**

   ```bash
   git push origin feature/nueva-funcionalidad
   ```
7. **Envía un Pull Request (PR):** Explica:
   - Los cambios realizados.
   - La necesidad de estos cambios.
   - Qué problema resuelven o qué funcionalidad añaden.

---

## 3. Configuración del Entorno de Desarrollo

### 3.1 Requisitos Previos

Asegúrate de tener instaladas las siguientes herramientas:

- Flutter (v3.5.3 o superior)
- Dart SDK
- Firebase CLI
- Docker y Docker Compose (opcional para despliegue y pruebas)
- Android Studio
- Java
- Node

También incluyelas en tu PATH local para que puedan ser reconocidas.

### 3.2 Instalación

1. **Clona el repositorio:**

   ```bash
   git clone https://github.com/PabloCastilloFer/sanamente.git
   cd sanamente
   ```

2. **Configura las variables de entorno:**

   Renombra el archivo `.env.example` a `.env` y ajusta las variables necesarias.

3. **Instala las dependencias:**

   ```bash
   flutter pub get
   ```

4. **Inicia los emuladores de Firebase:**

   ```bash
   firebase emulators:start
   ```

5. **Ejecuta la aplicación:**

   ```bash
   flutter run
   ```

---

## 4. Estándares de Estilo y Formato de Código

### General
- Usa `camelCase` para nombres de variables y funciones.
- Documenta los métodos y clases utilizando comentarios en formato DartDoc.

### Commits
Sigue el formato de convención para commits:

- **feat:** Añadir una nueva funcionalidad.
- **fix:** Corregir un error.
- **refactor:** Refactorizar código existente.
- **docs:** Cambios en la documentación.
- **test:** Añadir o modificar tests.

Ejemplo:

```bash
git commit -m "feat: agregar funcionalidad de notificaciones diarias"
```

---

## 5. Pruebas de Código

Antes de enviar un Pull Request, asegúrate de que todo funcione correctamente. Las pruebas están estructuradas de la siguiente manera:

### 5.1 Unit Tests

Corre los tests con:

```bash
flutter test
```

---

## 6. Despliegue en Docker

Sanamente soporta pruebas y despliegue usando Docker.

1. **Construye la imagen:**

   ```bash
   docker-compose build
   ```

2. **Inicia los contenedores:**

   ```bash
   docker-compose up
   ```

3. **Verifica los servicios:**

   ```bash
   docker-compose ps
   ```

---

## 7. Reportar Errores

1. Abre un Issue en GitHub.
2. Incluye:
   - Descripción del error.
   - Pasos para reproducirlo.
   - Comportamiento esperado y actual.
   - Capturas de pantalla (si aplica).

---

## 8. Estructura del Proyecto

```plaintext
sanamente/
├── android/          # Configuración para Android
├── ios/              # Configuración para iOS
├── lib/              # Código fuente principal
│   ├── models/       # Modelos de datos
│   ├── providers/    # Gestión de estado
│   ├── repositories/ # Repositorios de datos
│   ├── screens/      # Pantallas principales
│   ├── services/     # Servicios (e.g., Firebase, notificaciones)
│   ├── utils/        # Utilidades
│   ├── widgets/      # Componentes reutilizables
│   └── main.dart     # Entrada principal de la app
├── test/             # Pruebas unitarias
├── firebase.json     # Configuración de Firebase Hosting
├── dockerfile        # Configuración de Docker
├── pubspec.yaml      # Dependencias del proyecto
└── README.md         # Documentación del proyecto
```

---

## 📜 Licencia

Este proyecto está bajo la licencia MIT. Para más detalles, consulta el archivo [LICENSE](./LICENSE).

---

¡Gracias por ayudar a mejorar **Sanamente**! 🚀
