# SANAMENTE 🧠✨  
Aplicación web que facilita el **monitoreo anímico** de estudiantes-pacientes de la Universidad del Bío-Bío (UBB). Los estudiantes pueden registrar su estado de ánimo y los psicólogos pueden visualizar  y monitorear la información de sus pacientes de manera sencilla y accesible.

---

## ✨ **Características Principales**
- **Registro de estados anímicos**:  
   Los estudiantes registran su estado de ánimo diariamente con fecha y notas adicionales(opcionales).

- **Visualización para psicólogos**:  
   Los psicólogos pueden ver los registros de sus pacientes y realizar un seguimiento efectivo.

- **Gestión de pacientes**:  
   Los psicólogos pueden ver a los pacientes registrados en la plataforma y vincularlos hacia su propia sección "mis pacientes" para llevar un monitoreo organizado a sus pacientes desde una interfaz simple e intuitiva.

- **Historial y reportes**:  
   Se proporciona un historial detallado de los estados de ánimo de cada paciente.

---

## 📚 **Índice**
1. [Tecnologías Utilizadas](#tecnologías-utilizadas)
2. [Versiones](#versiones)
3. [Estructura del Proyecto](#estructura-del-proyecto)
4. [Instalación](#instalación)
5. [Uso](#uso)
6. [Esquema de la Base de Datos](#esquema-de-la-base-de-datos)
7. [Contacto](#contacto)

---

## 💻 **Tecnologías Utilizadas**

- **Frontend**:  
   - Flutter/Dart (Web)  
   - HTML/CSS  

- **Backend**:  
   - Firebase Firestore (Base de Datos)  
   - Firebase Auth (autenticación de usuarios)  

- **Contenedores**:  
   - Docker  

- **Entornos de prueba**:  
  Windows 10 (Navegador Chrome)


---

## 🔧 **Versiones**
| Componente                        | Versión         |
|-----------------------------------|-----------------|
| **Flutter**                       | 3.24.3          |
| **Dart SDK**                      | 3.5.3           |
| **Firebase CLI**                  | 13.29.1         |
| **Node.js**                       | 18.16.1         |
| **npm**                           | 9.5.1           |
| **Docker**                        | 4.x.x           |

### 📦 **Dependencias de Flutter**
| Paquete                          | Versión         |
|----------------------------------|-----------------|
| **cloud_firestore**              | 4.17.5          |
| **firebase_auth**                | 4.20.0          |
| **firebase_core**                | 2.32.0          |
| **device_preview**               | 1.2.0           |
| **shared_preferences**           | 2.3.3           |
| **fl_chart**                     | 0.69.2          |
| **flutter_dotenv**               | 5.2.1           |
| **flutter_local_notifications**  | 12.0.4          |
| **http**                         | 0.13.6          |
| **intl**                         | 0.19.0          |
| **provider**                     | 6.1.2           |
| **syncfusion_flutter_charts**    | 20.4.54         |
| **table_calendar**               | 3.1.3           |
| **timezone**                     | 0.9.4           |
| **logger**                       | 1.4.0           |

---

## 🔍 **Herramientas de Desarrollo**
| Herramienta                       | Versión         |
|----------------------------------|-----------------|
| **Flutter Doctor**               | Stable          |
| **Firebase CLI**                 | 13.29.1         |
| **Dart DevTools**                | 2.37.3          |
| **Docker Compose**               | 2.x.x           |

---


# 🚀 **Pasos Iniciales**

A continuación se detallan las instrucciones necesarias para obtener y ejecutar una copia del proyecto en una máquina local con **Windows 10/11**.

---

## ✅ **Requisitos Previos**

Antes de iniciar, asegúrate de tener las siguientes herramientas instaladas en tu sistema:

### **1. Git (para clonar el repositorio)**  

1. **🔍 Verificar si Git está instalado**:  
   Abre una terminal o línea de comandos y ejecuta:  
   ```bash
   git --version
   ```  
   Si Git está instalado, verás algo similar a:  
   ```plaintext
   git version 2.34.1
   ```

2. **⬇️ Instalar Git (si no está instalado)**:  
   - Descarga el instalador desde [git-scm.com](https://git-scm.com).  
   - Sigue los pasos de instalación para **Windows**.

3. **⚙️ Configurar Git**:  
   Una vez instalado, configura tu nombre de usuario y correo electrónico con los siguientes comandos:  
   ```bash
   git config --global user.name "TuNombre"
   git config --global user.email "tu.correo@ejemplo.com"
   ```

---

### **2. Docker (para crear y ejecutar contenedores)**  

1. **🔍 Verificar si Docker está instalado**:  
   Ejecuta el siguiente comando en la terminal:  
   ```bash
   docker --version
   ```  
   Debería aparecer algo como:  
   ```plaintext
   Docker version 24.0.5
   ```

2. **⬇️ Instalar Docker (si no está instalado)**:  
   - Descarga **Docker Desktop** desde [docker.com](https://www.docker.com/products/docker-desktop).  
   - Sigue las instrucciones del instalador y reinicia tu máquina si es necesario.

---

### **3. Docker Compose (para gestionar múltiples contenedores)**  

1. **🔍 Verificar si Docker Compose está instalado**:  
   Ejecuta:  
   ```bash
   docker-compose --version
   ```  
   Si está correctamente configurado, verás algo como:  
   ```plaintext
   docker-compose version 2.17.0
   ```

2. **⬇️ Instalar Docker Compose (si falta)**:  
   - Docker Compose ya viene incluido en **Docker Desktop**, por lo que no es necesario instalarlo manualmente.  
   - Si tienes una versión anterior, actualiza **Docker Desktop**.

---

### **4. Flutter y Firebase CLI (para ejecutar la app web)**  

1. **🔍 Verificar Flutter**:  
   ```bash
   flutter --version
   ```  
   Ejemplo de salida:  
   ```plaintext
   Flutter 3.24.3 • Dart 3.5.3
   ```

2. **🔍 Verificar Firebase CLI**:  
   ```bash
   firebase --version
   ```  
   Si no está instalado, puedes hacerlo con:  
   ```bash
   npm install -g firebase-tools
   ```

---

## 🚀 **Opciones para Configurar Firebase**

Para ejecutar correctamente esta aplicación, puedes optar por dos métodos:

---

### ⚙️ **Opción 1: Configuración Manual (Recomendada)**

Sigue estos pasos detallados para crear y configurar un proyecto Firebase propio:

1. **Crea un proyecto en Firebase** en [Firebase Console](https://console.firebase.google.com).  
2. **Habilita Firestore y Authentication**.  
3. **Registra tu app web** y obtén las credenciales (`firebase_options.dart` o claves manuales).  
  `  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'apikey',
    appId: 'appId',
    messagingSenderId: 'messagingSenderId',
    projectId: 'nombre/id proeyecto',
    authDomain: 'nombre/id proeyecto."example".com',
    storageBucket: 'nombre/id proeyecto.firebasestorage.app',
  );`

4. Configura las credenciales en los archivos de tu proyecto.

> Para una guía detallada, consulta la sección **Configuración de Firebase** más abajo.

---

### 🧪 **Opción 2: Uso de un Sandbox Preconfigurado**

Si prefieres probar rápidamente la aplicación sin configurar Firebase manualmente, utiliza el **entorno Sandbox** que he preparado:

- **Acceso mediante invitación**:  
   - Recibirás una invitación a tu correo electrónico con acceso al entorno Sandbox de Firebase.

- **Cómo ejecutar con el Sandbox**:  
   1. Acepta la invitación en tu correo y accede a Firebase Console con tu cuenta Google.  
   2. Descarga el archivo de configuración (`firebase_options_sandbox.dart`) desde el repositorio.  
   3. Colócalo en la carpeta `lib/` de tu proyecto Flutter.  
   4. Asegúrate de que tu código utilice este archivo de configuración:
      ```dart
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      ```
   5. Ejecuta la aplicación:
      ```bash
      flutter run -d chrome
      ```

---

### ⚠️ **Nota Importante**  
- El **Sandbox** es un entorno temporal creado únicamente para pruebas.  
- Se recomienda optar por la **configuración manual** para validar el proceso completo.

---

## ✅ **Resumen**

| Opción                     | Ventajas                            | Desventajas                    |
|----------------------------|-------------------------------------|--------------------------------|
| **Configuración Manual**   | Buenas prácticas, flexible          | Más pasos, toma más tiempo     |
| **Sandbox con Invitación** | Rápido y fácil de probar, seguro    | Temporal, menos personalizado  |

---

## 📩 **Cómo Acceder al Sandbox**

- Proporciona tu dirección de correo electrónico y te enviaré una **invitación directa** al entorno Sandbox de Firebase.
- Una vez aceptada, podrás usarlo sin necesidad de configurar Firebase desde cero.

---

















## 📥 **Clonar el Proyecto**

Una vez que tengas todas las herramientas instaladas, clona el repositorio y accede a la carpeta del proyecto:

```bash
git clone https://github.com/getbythespace/sanamente.git
cd sanamente
```

---

## 🔧 **Configuración Inicial**

 **Configurar las variables de entorno**:  
   - Copia el archivo `.env.example` y renómbralo a `.env`.  
   - Completa las variables necesarias con tus credenciales o configuración local.




## 🐳 **Ejecutar el Proyecto Localmente con Docker**

Para probar la aplicación localmente usando Docker, sigue estos pasos:

1. **Requisitos previos**:  
   - Instala [Docker](https://www.docker.com/products/docker-desktop).  
   - Verifica que Docker esté funcionando correctamente:
     ```bash
     docker --version
     docker-compose --version
     ```

2. **Clonar el repositorio**:  
   ```bash
   git clone https://github.com/getbythespace/sanamente.git
   cd sanamente
   ```

3. **Construir y ejecutar el contenedor**:  
   Ejecuta el siguiente comando:
   ```bash
   docker-compose up --build
   ```

4. **Abrir la aplicación**:  
   Una vez el contenedor esté corriendo, abre tu navegador y dirígete a:
   ```
   http://localhost:8080
   ```

5. **Detener el contenedor**:  
   Si quieres detener la aplicación, presiona `Ctrl + C` o ejecuta:
   ```bash
   docker-compose down
   ```

---

## ✅ **Verificación**

1. El contenedor debería construirse correctamente.  
2. La aplicación Flutter Web debe ser accesible en **localhost**.  
3. El proceso es totalmente automático: **no 






## 🚀 **Ejecutar la Aplicación**

1. En el terminal ejecuta:  
   ```plaintext
   flutter run -d chrome
   ```

2. ¡Listo! debería desplegarse **Sanamente** en tu navegador.

---
