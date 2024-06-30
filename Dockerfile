# Stage 1: Build the application
FROM ghcr.io/graalvm/jdk-community:21.0.2 AS build
WORKDIR /app

COPY . .

RUN gu install native-image
RUN ./gradlew nativeBuild

# Stage 2: Create the final Docker image
FROM scratch
COPY --from=build /app/build/native/nativeCompile/eurekaserver .

ENTRYPOINT ["./eurekaserver"]
