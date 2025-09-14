# Use the Eclipse temurin alpine official image
# https://hub.docker.com/_/eclipse-temurin
FROM eclipse-temurin:21-jdk-alpine

# Install git-crypt
RUN apk add --no-cache git-crypt git

# Create and change to the app directory.
WORKDIR /app

# Copy local code to the container image.
COPY . ./

# Accept the git-crypt key as a build argument
ARG GIT_CRYPT_KEY

# Create the key file from the build argument
RUN echo "$GIT_CRYPT_KEY" | base64 -d > ./git-crypt-key

# Unlock the repository using git-crypt
RUN git-crypt unlock ./git-crypt-key

# Remove the key file for security
RUN rm ./git-crypt-key

# Make mvnw executable
RUN chmod +x ./mvnw

# Build the app.
RUN ./mvnw -DoutputFile=target/mvn-dependency-list.log -B -DskipTests clean dependency:list install

# Run the app by dynamically finding the JAR file in the target directory
CMD ["sh", "-c", "java -jar target/*.jar"]