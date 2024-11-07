# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory to /app
WORKDIR /src

# Copy the package.json and package-lock.json files to /app
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to /app
COPY ./src ./src

# Expose port 3000
EXPOSE 3000

# Start the server
CMD ["npm", "start"]