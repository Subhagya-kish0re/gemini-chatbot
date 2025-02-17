# Build stage with Eclipse Temurin JDK 23
FROM eclipse-temurin:23-jdk-jammy AS builder
WORKDIR /app

# Copy Maven wrapper and pom.xml first
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

# Runtime stage with JRE 23
FROM eclipse-temurin:23-jre-jammy
WORKDIR /app

# Copy built JAR from builder stage
COPY --from=builder /app/target/gemini-chatbot.jar app.jar

# Run as non-root user for security
RUN useradd -m appuser
USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]