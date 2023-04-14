#FROM openjdk:8-jdk-alpine
FROM adoptopenjdk/openjdk11:latest
EXPOSE 8081
ADD target/spring-boot-jacoco.jar spring-boot-jacoco.jar
ENTRYPOINT ["java","-jar","/spring-boot-jacoco.jar"]
