FROM openjdk:8
ADD jarstaging/com/may/basic-java-app/2.1.2/basic-java-app-2.1.2.jar bja.jar
ENTRYPOINT [ "java", "-jar", "bja.jar" ]