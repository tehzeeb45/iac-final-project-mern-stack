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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create data directories for MongoDB
RUN mkdir -p /data/db && chown -R mongodb:mongodb /data/db

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

# Start MongoDB and the Node.js application
CMD ["sh", "-c", "mongod --bind_ip_all --dbpath /data/db --logpath /var/log/mongodb.log --fork && npm run server"]


