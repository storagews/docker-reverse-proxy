#!/bin/sh
if [ "$FQDN" = "example.com" ]; then
    echo "No set FQDN"
else
	letsencrypt certonly -t -n --agree-tos --renew-by-default --email $EMAIL --webroot -w /usr/share/nginx/html -d $FQDN
    cp -fv /etc/letsencrypt/live/$FQDN/privkey.pem /etc/nginx/ssl/ssl.key
    cp -fv /etc/letsencrypt/live/$FQDN/fullchain.pem /etc/nginx/ssl/ssl.crt
fi