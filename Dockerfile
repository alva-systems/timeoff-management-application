# Étape 1 : Build des dépendances
FROM node:18-alpine AS dependencies

WORKDIR /app

# Install des dépendances système nécessaires à node-sass ou autres
RUN apk add --no-cache python3 make g++ \
  && ln -sf python3 /usr/bin/python

COPY package.json ./

RUN npm install

# Étape 2 : Application
FROM node:18-alpine

RUN apk add --no-cache vim

# Créer un utilisateur non-root
RUN adduser --system app --home /app
WORKDIR /app

COPY --chown=app:app . .

# ✅ Copier les node_modules depuis le bon stage nommé
COPY --from=dependencies /app/node_modules ./node_modules

EXPOSE 3000
CMD ["npm", "start"]