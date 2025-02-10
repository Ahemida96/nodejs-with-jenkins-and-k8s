# Stage 1 is added is here
FROM node:20 AS backened-builder

# Set the working directory inside the container to /app
WORKDIR /app

# Copy the package.json and package-lock.json for dependency installation
COPY . .

# Install all dependencies listed in package.json
RUN npm install

# Stage 2
FROM node:20-slim

# Create a non-root user and group
RUN groupadd -r groupapp && useradd -r -g groupapp userapp

# Set up the working directory
WORKDIR /app

# Copy the build from the previous stage
COPY --from=backened-builder /app .

# Change ownership of files to the non-root user
RUN chown -R userapp:groupapp /app

# Switch to the non-root user
USER userapp

# Execute the command
CMD ["npm", "start"]
