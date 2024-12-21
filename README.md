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
  Firebase Emulator Suite


---

## 🔧 **Versiones**
| Componente                        | Versión         |
|-----------------------------------|-----------------|
| **Flutter**                       | 3.27.1          |
| **Dart SDK**                      | 3.6.0           |
| **Firebase CLI**                  | 13.29.1         |
| **Node.js**                       | 18.16.1         |
| **npm**                           | 9.5.1           |
| **Docker**                        | 4.x.x           |

### 📦 **Dependencias de Flutter**
| Paquete                          | Versión         |
|----------------------------------|-----------------|
| **cloud_firestore**              | 5.6.0           |
| **cloud_firestore_platform_interface** | 6.6.0     |
| **cloud_firestore_web**          | 4.4.0           |
| **cupertino_icons**              | 1.0.8           |
| **device_preview**               | 1.2.0           |
| **device_frame**                 | 1.2.0           |
| **firebase_auth**                | 5.3.4           |
| **firebase_auth_platform_interface** | 7.4.10      |
| **firebase_auth_web**            | 5.13.5          |
| **firebase_core**                | 3.9.0           |
| **firebase_core_platform_interface** | 5.4.0       |
| **firebase_core_web**            | 2.19.0          |
| **fl_chart**                     | 0.70.0          |
| **flutter_dotenv**               | 5.2.1           |
| **flutter_lints**                | 5.0.0           |
| **flutter_local_notifications**  | 18.0.1          |
| **freezed_annotation**           | 2.4.4           |
| **http**                         | 1.2.2           |
| **intl**                         | 0.19.0          |
| **json_annotation**              | 4.9.0           |
| **logger**                       | 2.5.0           |
| **provider**                     | 6.1.2           |
| **shared_preferences**           | 2.3.4           |
| **syncfusion_flutter_charts**    | 28.1.35         |
| **table_calendar**               | 3.1.3           |
| **timezone**                     | 0.10.0          |

### 🔍 **Dependencias de Soporte**
| Paquete                          | Versión         |
|----------------------------------|-----------------|
| **args**                         | 2.6.0           |
| **collection**                   | 1.19.0          |
| **clock**                        | 1.1.1           |
| **dbus**                         | 0.7.10          |
| **ffi**                          | 2.1.3           |
| **flutter_web_plugins**          | 0.0.0           |
| **material_color_utilities**     | 0.11.1          |
| **meta**                         | 1.15.0          |
| **path**                         | 1.9.0           |
| **vector_math**                  | 2.1.4           |
| **xml**                          | 6.5.0           |

### 📂 **Herramientas Adicionales**
| Herramienta                       | Versión         |
|-----------------------------------|-----------------|
| **Firebase CLI**                 | 13.29.1         |
| **Docker Compose**               | 2.x.x           |
| **Dart DevTools**                | 2.37.3          |

---


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




## 🐳 **Ejecutar el Proyecto Localmente con Docker y Firebase Emulator Suite**

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
   Ejecutar con los siguientes comandos:
   ```bash
   docker-compose up --build
   ```
   ```bash
   docker-compose up -d
   ```

   Para desplegar los logs y tener una visualización más clara de los procesos, puedes usar:
   ```bash
   docker-compose logs -f
   ```


4. **Abrir la aplicación**:  
   Una vez el contenedor esté corriendo, abre tu navegador y dirígete a:
   ```
   http://127.0.0.1:5000/
   ```
   Donde aparecerá el login de la aplicación

   ```
   http://127.0.0.1:4001/firestore
   ```
   Donde se podrán apreciar los cambios, registros y peticiones a la base de datos simulada


   Nota: Es importante saber que para que pudiera probarse el programa vía docker fué necesario, implementar Firebase Emulator Suite, que es basicamente un simulador tanto de la aplicación como de la base de datos de Firebase (Firestore), para poder probar las funcionalidades del programa de manera local.




## ✅ **Verificación**

1. El contenedor debería construirse correctamente y poder ejecutarse.  
2. La aplicación Flutter Web debe ser accesible en los url brindados a menos que tenga un choque de puertos los cuales se recomendaría dejar despejados para esta prueba.  



## 🚀 **Lógica de prueba de las funcionalidades**

1. En primer lugar debe crearse un usuario en el formulario de registro con un rut válido y sin "-", como default será registrado como usuario tipo "paciente" que es para quienes aplica el eje principal de la aplicación.

      Ruts con el formato válido de ejemplo:
         56033661
         105855508
         240343479

2. Posterior a la creación de este usuario, debe cerrar cesión y dirigirse a la pestaña de Firestore que se abrió simultaneamente con la aplicación en la sección anterior.

   ```
   http://127.0.0.1:4001/firestore
   ```
   Aquí ya se podría evidenciar el registro del usuario exitosamente y cualquier petición o interacción con la base de datos, en el campo de rol del usuario (default: "paciente"), editamos y cambiamos por "admin" e ingresamos vía login con los datos recién creados "correo" y "contraseña" y esta vez, aparecerá el panel de administrador, donde aparecerían todos los usuarios registrados y botones para la creación, eliminación y edición de usuarios.


2. Luego, para seguir con la lógica de la prueba de las funcionalidades, se debe crear al menos un paciente y al menos un psicólogo.

3. Posterior al paso anterior, con los datos que se hayan ingresado en cada uno, podrá ingresar con el "correo" y "contraseña" de cada uno y se podrá apreciar las diferentes funcionalidades de cada uno de los roles, según la interfaz que tengan.

4. Como recomendación, ingrese primero a la cuenta del psicólogo creado y ahí ya en su propia interfaz podrá vincular al o los pacientes creados (simulando la vinculación de un paciente a un psicólogo) y podrá ver los datos, además de habilitar a ese "paciente" a poder registrar su ánimo.

5. Cuando ya el "Paciente X" haya sido vinculado con un psicólogo y este ingrese a su cuenta, podrá crear "Registros anímicos" los cuales a medida que se van creando, van generando un gráfico representativo, también podría modificar el horario de las notificaciones para responder el cuestionario anímico pero, como se mencionaba, también puede registrar las veces que quiera.

6. Bajo esta lógica se cumpliría el objetivo principal de la aplicación, ya que se lograría la vinculación de un paciente a un psicólogo, el cual podrá monitorear el estado de anímo de sus pacientes.

5. **Detener el contenedor**:  
   Si quieres detener la aplicación, presiona `Ctrl + C` o ejecuta:
   ```bash
   docker-compose down
   ```

---
