# ==========================================
# Stage 1: Build the WAR file using Maven
# ==========================================
FROM maven:3.8.6-openjdk-8 AS build
WORKDIR /app

# Copy the pom.xml and source code to the container
COPY pom.xml .
COPY src ./src

# Run Maven to build the .war file
RUN mvn clean package

# ==========================================
# Stage 2: Run Tomcat and deploy the WAR file
# ==========================================
FROM tomcat:9.0

# Clear out default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the newly built .war file from Stage 1 into Tomcat
COPY --from=build /app/target/PhalBaazaar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Start Tomcat
EXPOSE 8080
CMD ["catalina.sh", "run"]
