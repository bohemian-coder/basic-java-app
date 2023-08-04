FROM openjdk:8
ADD jarstaging/com/may/basic-java-app/2.1.3/basic-java-app-2.1.3.jar bja.jar
ENTRYPOINT [ "java", "-jar", "bja.jar" ]