# Build stage
FROM container-registry.oracle.com/java/jdk:23 AS builder
WORKDIR /app

# First copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM container-registry.oracle.com/java/jre:23
WORKDIR /app

# Copy built JAR
COPY --from=builder /app/target/gemini-chatbot.jar app.jar

# Security: Run as non-root user
RUN useradd -m appuser
USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]