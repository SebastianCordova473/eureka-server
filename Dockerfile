# Stage 1: Build the application using Amazon Corretto 17
FROM amazoncorretto:17 as builder

# Set the working directory
WORKDIR /app

# Copy the Gradle wrapper and build files
COPY gradle/ gradle/
COPY build.gradle settings.gradle gradlew ./
RUN chmod +x gradlew

# Copy the source code
COPY src/ src/

# Build the application
RUN ./gradlew bootJar --no-daemon

# Stage 2: Use Amazon Corretto 17 as the base image
FROM amazoncorretto:17

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=builder /app/build/libs/eurekaserver-0.0.1-SNAPSHOT.jar app.jar

# Expose the Eureka server port
EXPOSE 8761

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
