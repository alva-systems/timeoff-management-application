FROM node:18-alpine AS dependencies

# Ajout des outils nécessaires pour compiler sqlite3
RUN apk add --no-cache \
  python3 \
  make \
  g++ \
  && python3 -m ensurepip \
  && ln -sf python3 /usr/bin/python \
  && pip3 install --no-cache --upgrade pip setuptools

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