#!/bin/sh

# functions ###
setup_nginx_le () {
	# make dhparams
	if [ ! -f /etc/nginx/ssl/dhparams.pem ]; then
    	echo "make dhparams"
    	cd /etc/nginx/ssl
    	openssl dhparam -out dhparams.pem 2048
    	chmod 600 dhparams.pem
	fi
	sed -i "s|FQDN|${FQDN}|g" /http
	sed -i "s|HTTP|${HTTP}|g" /http
	sed -i "s|FQDN|${FQDN}|g" /https
	sed -i "s|HTTPS|${HTTPS}|g" /https
	sed -i "s|DESTINATION|${DESTINATION}|g" /https
	(
 		while :
 		do
 		if [ ! -f /etc/nginx/sites-enabled/https ]; then
 			if [ ! -f /etc/nginx/sites-enabled/http ]; then
	 			mv /http /etc/nginx/sites-enabled/http
	 		fi
 			nginx -s reload
 			sleep 3
 			/le.sh && mv /https /etc/nginx/sites-enabled/https
 			nginx -s reload
 			sleep 60d
 		else
 			if [ ! -f /etc/nginx/sites-enabled/http ]; then
	 			mv /http /etc/nginx/sites-enabled/http
	 		fi
 			mv /etc/nginx/sites-enabled/https /https 
			nginx -s reload
 			sleep 3
 			/le.sh && mv /https /etc/nginx/sites-enabled/https
 			nginx -s reload
 			sleep 60d
 		fi
 		done
	) &
}

# - setup
if [ "$FQDN" = "example.com" ]; then
	echo "No set FQDN" && exit 1
else
	setup_nginx_le
fi
# - run
/usr/bin/supervisord