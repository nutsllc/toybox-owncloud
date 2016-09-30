#!/bin/bash

user="www-data"
group="www-data"

if [ -n "${TOYBOX_GID}" ] && ! cat /etc/group | awk 'BEGIN{ FS= ":" }{ print $3 }' | grep ${TOYBOX_GID} > /dev/null 2>&1; then
    groupmod -g ${TOYBOX_GID} ${group}
    echo "GID of ${group} has been changed."
fi

if [ -n "${TOYBOX_UID}" ] && ! cat /etc/passwd | awk 'BEGIN{ FS= ":" }{ print $3 }' | grep ${TOYBOX_UID} > /dev/null 2>&1; then
    usermod -u ${TOYBOX_UID} ${user}
    echo "UID of ${user} has been changed."
fi

sh /entrypoint.sh


docroot="/var/www/html"
chown -R ${user}:${group} ${docroot}

: ${DATABASE:=manual}
: ${OWNCLOUD_ADMIN_USER:=toybox}
: ${OWNCLOUD_ADMIN_PASSWORD:=toybox}

if [ ${DATABASE} = "mysql" ]; then
    db_state=$(mysqladmin ping -h ${MYSQL_PORT_3306_TCP_ADDR} -u root -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} 2>/dev/null )
    printf "wait.."
    while [ "${db_state}" != "mysqld is alive" ]; do
        printf "." && sleep 3
        db_state=$(mysqladmin ping -h ${MYSQL_PORT_3306_TCP_ADDR} -u root -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} 2>/dev/null )
    done
    echo ""
fi

if [ -f "${docroot}/config/config.php" ]; then
    if [ ${DATABASE} = "mysql" ]; then
        sed -i -e "s/'dbhost' => '.*\..*\..*\..*'/'dbhost' => '${MYSQL_PORT_3306_TCP_ADDR}'/g" ${docroot}/config/config.php
    fi
else

    if [ "${DATABASE}" = "mysql" ]; then
        sudo -u www-data php /usr/src/owncloud/occ maintenance:install \
            --database ${DATABASE} \
            --database-host ${MYSQL_PORT_3306_TCP_ADDR} \
            --database-name ${MYSQL_ENV_MYSQL_DATABASE} \
            --database-user ${MYSQL_ENV_MYSQL_USER} \
            --database-pass ${MYSQL_ENV_MYSQL_PASSWORD} \
            --admin-user ${OWNCLOUD_ADMIN_USER} \
            --admin-pass ${OWNCLOUD_ADMIN_PASSWORD}

    elif [ "${DATABASE}" = "sqlite" ]; then
        sudo -u www-data php /usr/src/owncloud/occ maintenance:install \
            --database ${DATABASE} \
            --admin-user ${OWNCLOUD_ADMIN_USER} \
            --admin-pass ${OWNCLOUD_ADMIN_PASSWORD}
    fi

    if [ "${DATABASE}" != "manual" ]; then
        sudo -u www-data php /usr/src/owncloud/occ config:system:set trusted_domains \
            1 --value ${VIRTUAL_HOST:=localhost}

        sudo -u www-data php /usr/src/owncloud/occ config:system:set logtimezone \
            --value=$(date +%Z)

        ## for APC
        sudo -u www-data php /usr/src/owncloud/occ config:system:set memcache.local \
            --value="\OC\Memcache\APC"

        ## for APCu
        #sudo -u www-data php /usr/src/owncloud/occ config:system:set memcache.local \
        #    --value="\OC\Memcache\APCu"

        ## for Redis
        #sudo -u www-data php /usr/src/owncloud/occ config:system:set memcache.locking \
        #    --value="\OC\Memcache\Redis"

        #sudo -u www-data php /usr/src/owncloud/occ config:system:set redis \
        #    'host' --value redis

        #sudo -u www-data php /usr/src/owncloud/occ config:system:set redis \
        #    'port' --value 6379
    fi
fi

exec "$@"
