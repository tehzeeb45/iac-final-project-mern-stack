# Set the base image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /app

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && apt-get install -y mongodb \
    && apt-get install -y pm2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create data directories for MongoDB
RUN mkdir -p /data/db /var/log/mongodb && chown -R mongodb:mongodb /data/db /var/log/mongodb

# Copy the application files into the container
COPY . .

# Install dependencies for the entire application
RUN npm install

# Build the frontend
WORKDIR /app/frontend
RUN npm install
RUN npm run build

# Switch to the backend directory
WORKDIR /app/backend

# Start MongoDB and the Node.js application using pm2
CMD ["pm2-runtime", "start", "npm", "--", "run", "server"]


