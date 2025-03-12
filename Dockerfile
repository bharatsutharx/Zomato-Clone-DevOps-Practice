# ---- Build Stage ----
    FROM node:16-alpine AS build

    # Set working directory inside /app
    WORKDIR /app
    
    # Copy package.json and package-lock.json from src
    COPY /package*.json ./
    
    # Install dependencies
    RUN npm install --frozen-lockfile
    
    # Copy the entire src/ directory into /app
    COPY . . 

    # Build the React app
    RUN npm run build
    
    # ---- Production Stage ----
    FROM nginx:alpine
    
    # Copy built React app to Nginx html directory
    COPY --from=build /app/build /usr/share/nginx/html
    
    # Expose port 80
    EXPOSE 80
    
    # Start Nginx
    CMD ["nginx", "-g", "daemon off;"]

    