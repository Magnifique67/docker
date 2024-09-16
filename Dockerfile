# Use the official Maven image to build the application
FROM maven:3.8.8-eclipse-temurin-17 AS builder

# Set the working directory
WORKDIR /Advanced-Web-Sorting-Algorithms

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src /Advanced-Web-Sorting-Algorithms/src
RUN mvn package -DskipTests

# Use the official Eclipse Temurin JRE image to run the application
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /Advanced-Web-Sorting-Algorithms

# Copy the built JAR from the builder stage
COPY --from=builder /Advanced-Web-Sorting-Algorithms/target/Advanced-Web-Sorting-Algorithms-0.0.1-SNAPSHOT.jar /Advanced-Web-Sorting-Algorithms/Advanced-Web-Sorting-Algorithms-0.0.1-SNAPSHOT.jar

# Specify the command to run the application
ENTRYPOINT ["java", "-jar", "/Advanced-Web-Sorting-Algorithms/Advanced-Web-Sorting-Algorithms-0.0.1-SNAPSHOT.jar"]
