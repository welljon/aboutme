FROM node:14
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
WORKDIR /usr/src/app/public
RUN apt-get update && apt-get install -y cron certbot
RUN mkdir -p public/.well-known/acme-challenge
CMD certbot certonly --webroot --agree-tos --email jrobertwells@gmail.com -d welljon.xyz -d www.welljon.xyz -w /usr/src/app/public --keep-until-expiring --no-eff-email --pre-hook "node main.js" --post-hook "node main-https.js" --test-cert && node main.js