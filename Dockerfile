# Build stage
FROM eclipse-temurin:23-jdk-jammy as build
WORKDIR /workspace/app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN ./mvnw clean package -DskipTests

# Package stage
FROM eclipse-temurin:23-jre-jammy
VOLUME /tmp
ARG JAR_FILE=/workspace/app/target/gemini-chatbot.jar
COPY --from=build ${JAR_FILE} app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app.jar"]