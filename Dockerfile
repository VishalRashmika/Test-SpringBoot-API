# Use the Eclipse temurin alpine official image
# https://hub.docker.com/_/eclipse-temurin
FROM eclipse-temurin:21-jdk-alpine

# Install git-crypt
RUN apk add --no-cache git-crypt git

# Create and change to the app directory.
WORKDIR /app

# Accept the git-crypt key as a build argument
ARG GIT_CRYPT_KEY

# Debug: Check if the argument was passed
RUN if [ -z "$GIT_CRYPT_KEY" ]; then echo "ERROR: GIT_CRYPT_KEY not provided"; exit 1; fi

# Copy local code to the container image INCLUDING .git directory
COPY . ./

# Initialize git repository
RUN git init .

# Add all files to git (needed for git-crypt to work)
RUN git add .

# Create initial commit
RUN git -c user.email="build@railway.com" -c user.name="Railway Build" commit -m "Initial commit" || echo "Commit failed, continuing..."

# Create the key file from the build argument
RUN echo "$GIT_CRYPT_KEY" | base64 -d > ./git-crypt-key

# Debug: Check key file was created
RUN ls -la ./git-crypt-key

# Import the git-crypt key and unlock
RUN git-crypt unlock ./git-crypt-key

# Verify unlock was successful - check if .db file is readable
RUN echo "Checking database files after unlock:"
RUN find . -name "*.db" -exec ls -la {} \;
RUN find . -name "*.db" -exec file {} \;

# Remove the key file for security
RUN rm ./git-crypt-key

# Make mvnw executable
RUN chmod +x ./mvnw

# Build the app.
RUN ./mvnw -DoutputFile=target/mvn-dependency-list.log -B -DskipTests clean dependency:list install

# Run the app by dynamically finding the JAR file in the target directory
CMD ["sh", "-c", "java -jar target/*.jar"]