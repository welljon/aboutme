ARG CERTBOTEMAIL=none
FROM node:14
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN apt-get update && apt-get install -y cron certbot
CMD certbot certonly --webroot --agree-tos --email $CERTBOTEMAIL -d welljon.xyz -w public --keep-until-expiring --no-eff-email --pre-hook "node main.js" --post-hook "node main-https.js" --test-cert && node main.js