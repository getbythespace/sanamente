
FROM ghcr.io/cirruslabs/flutter:3.27.1

# dependencias necesarias
RUN apt-get update && apt-get install -y curl git

# Firebase CLI
RUN curl -sL https://firebase.tools | bash

# directorio de trabajo
WORKDIR /app

# Copiar pubspec.yaml y pubspec.lock
COPY pubspec.yaml pubspec.lock ./

# dependencias de Flutter
RUN FLUTTER_SUPPRESS_ROOT_WARNING=true flutter pub get

# Copiar el resto de los archivos del proyecto
COPY . .

# Construir la versión web del proyecto Flutter
RUN flutter build web

# Exponer los puertos utilizados por los emuladores de Firebase y hosting
EXPOSE 5000 8080 9099 4001 9150

# Comando para iniciar los emuladores de Firebase
CMD ["sh", "-c", "FLUTTER_SUPPRESS_ROOT_WARNING=true firebase emulators:start --only auth,firestore,hosting"]
