#!/bin/bash

# Step 1: List all Docker images
echo "Listing all Docker images..."
docker images

# Step 2: Find and delete existing Eureka server container
echo "Searching for existing Eureka server container..."
existing_container=$(docker ps -aq --filter="name=eurekaserver")

if [ -n "$existing_container" ]; then
    echo "Existing Eureka server container found. Stopping and removing container..."
    docker stop "$existing_container"
    docker rm "$existing_container"
else
    echo "No existing Eureka server container found."
fi

# Step 3: Find and delete existing Eureka server image
echo "Searching for existing Eureka server image..."
existing_image=$(docker images -q eurekaserver:latest)

if [ -n "$existing_image" ]; then
    echo "Existing Eureka server image found. Deleting image..."
    docker rmi -f "$existing_image"
else
    echo "No existing Eureka server image found."
fi

# Step 4: Build the new Docker image
echo "Building the new Docker image for Eureka server..."
docker build -t eurekaserver:latest .

# Step 5: Run the Docker container
echo "Running the Docker container..."
docker run -d -p 8761:8761 --name eurekaserver eurekaserver:latest

echo "Eureka server Docker container is now running on port 8761."