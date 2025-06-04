# Remplace tout ton Dockerfile par :
    FROM node:18-alpine AS dependencies

    WORKDIR /app
    COPY package.json ./
    RUN npm install
    
    FROM node:18-alpine
    
    RUN apk add --no-cache vim
    
    RUN adduser --system app --home /app
    USER app
    WORKDIR /app
    COPY --chown=app:app . .
    COPY --from=dependencies /app/node_modules ./node_modules
    
    EXPOSE 3000
    CMD ["npm", "start"]