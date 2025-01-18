# Use an OpenJDK image as the base
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Gradle wrapper and configuration files to cache dependencies
COPY gradlew build.gradle settings.gradle /app/
COPY gradle /app/gradle

# Ensure the Gradle wrapper script has executable permissions
RUN chmod +x ./gradlew

# Download Gradle dependencies (fail gracefully to cache as much as possible)
RUN ./gradlew dependencies --no-daemon || true

# Copy the rest of the project files into the container
COPY . /app

# Build the project
RUN ./gradlew build --no-daemon

# Expose the default application port
EXPOSE 8080

# Set the entry point to run the application
CMD ["java", "-jar", "build/libs/taskmaster-0.0.1-SNAPSHOT.jar"]
