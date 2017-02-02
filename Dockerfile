FROM kudato/docker-supervisor
#
MAINTAINER Alexander Shevchenko <kudato@me.com>
# ports 
ENV HTTP 80
ENV HTTPS 443
# domain
ENV FQDN example.com
# email
ENV EMAIL support@examle.com
# destination
ENV DESTINATION localhost
# add nginx config
ADD https /https
ADD http /http
# add lestencrypt setup script
ADD le.sh /le.sh
# add entrypoint script
ADD entrypoint.sh /entrypoint.sh
# install and setup nginx
RUN apt-get update
RUN apt-get install -y nginx letsencrypt
RUN echo "[program:nginx]" >> /etc/supervisor/conf.d/supervisord.conf && \
	echo "command = /usr/sbin/nginx" >> /etc/supervisor/conf.d/supervisord.conf && \
	echo "user = root" >> /etc/supervisor/conf.d/supervisord.conf && \
	echo "autostart = true" >> /etc/supervisor/conf.d/supervisord.conf && \
	rm -rf /etc/nginx/sites-enabled/default && rm -rf /etc/nginx/nginx.conf && \
	mkdir -p /etc/nginx/ssl && mkdir -p /usr/share/nginx/html
ADD nginx.conf /etc/nginx/nginx.conf
#
RUN chmod +x /*.sh
# - >
CMD ["/entrypoint.sh"]
