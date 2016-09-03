FROM owncloud:9.0.2-apache

RUN apt-get update && apt-get install -y sudo

COPY docker-entrypoint.sh /entrypoint-ex.sh
ENTRYPOINT ["/entrypoint-ex.sh"]
CMD ["apache2-foreground"]
