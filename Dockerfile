FROM docker.io/tomcat:9.0.87-jre21-temurin-jammy
COPY target/struts-examples.war /usr/local/tomcat/webapps/

