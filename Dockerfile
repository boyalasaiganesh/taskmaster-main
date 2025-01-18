# Dockerfile
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Gradle wrapper and configuration files to cache dependencies
COPY --chmod=755 gradlew /app/gradlew
COPY build.gradle settings.gradle /app/
COPY gradle /app/gradle

# Verify permissions of gradlew
RUN ls -l /app/gradlew

# Download Gradle dependencies to cache (fail gracefully to allow partial caching)
RUN ./gradlew dependencies --no-daemon || true

# Copy the rest of the project files into the container
COPY . /app

# Build the project
RUN ./gradlew build --no-daemon

# Expose the default application port
EXPOSE 8080

# Set the entry point to run the application
CMD ["java", "-jar", "build/libs/taskmaster-0.0.1-SNAPSHOT.jar"]
