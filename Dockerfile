FROM eclipse-temurin:23-jdk-alpine AS builder

WORKDIR /app

# Copy Maven wrapper and pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies
RUN ./mvnw dependency: resolve

# Copy source code
COPY src src

# Build application
RUN ./mvnw clean package -DskipTests

# Production image
FROM eclipse-temurin:23-jre-alpine

WORKDIR /app

# Copy built JAR from builder stage
COPY --from=builder /app/target/gemini-chatbot.jar app.jar

# Expose application port
EXPOSE 8080

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]