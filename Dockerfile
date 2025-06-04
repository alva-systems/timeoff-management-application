FROM alpine:latest AS dependencies

RUN apk add --no-cache \
    nodejs npm \
    python3 make g++ \
    && ln -sf python3 /usr/bin/python

COPY package.json .
RUN npm install

FROM alpine:latest

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name alpine_timeoff"

RUN apk add --no-cache \
    nodejs npm \
    vim

RUN adduser --system app --home /app
USER app
WORKDIR /app
COPY . /app
COPY --from=dependencies /node_modules ./node_modules

EXPOSE 3000
CMD ["npm", "start"]