# ----------- STAGE 1: Build -----------

FROM eclipse-temurin:17-jdk-alpine AS builder

# Crea directorio de trabajo
WORKDIR /app

# Copia el wrapper de Gradle y configura permisos
COPY gradle/ gradle/
COPY build.gradle settings.gradle gradlew ./
RUN chmod +x gradlew

# Copia el código fuente
COPY src/ src/

# Construye el JAR
RUN ./gradlew bootJar --no-daemon

# ----------- STAGE 2: Runtime -----------

FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copia el JAR generado
COPY --from=builder /app/build/libs/eurekaserver-0.0.1-SNAPSHOT.jar app.jar

# Configura límites de memoria
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# Expón el puerto de Eureka
EXPOSE 8761

# Ejecuta el JAR con opciones JVM
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]