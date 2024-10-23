# Stage 1: Build Stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json, yarn.lock, and install dependencies
COPY package*.json ./
COPY yarn.lock ./
RUN yarn install

# Copy the rest of the app's source code
COPY . .

# Build the app
RUN yarn build

# Stage 2: Production Stage
FROM node:18-alpine AS production

# Install 'serve' to serve the built files
RUN yarn global add serve

# Set working directory
WORKDIR /app

# Copy only the build output from the previous stage
COPY --from=builder /app/build ./build

# Expose port 3000 for serving the app
EXPOSE 3000

# Command to serve the app on port 3000
CMD ["serve", "-s", "build", "-l", "3000"]
