# Stage 1: Build the application using OpenJDK 17
FROM alpine:3.17 as builder

# Install bash, curl, and OpenJDK 17
RUN apk add --no-cache bash openjdk17 curl

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

# Stage 2: Use Alpine as the base image
FROM alpine:3.17

# Install bash, curl, and OpenJDK 17
RUN apk add --no-cache bash openjdk17 curl

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=builder /app/build/libs/eurekaserver-0.0.1-SNAPSHOT.jar app.jar

# Expose the Eureka server port
EXPOSE 8761

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
