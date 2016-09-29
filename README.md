# ownCloud on Docker

A Dockerfile for deploying a [ownCloud](https://owncloud.org/) which is open source file sync and share software like a Dropbox!.

This image is registered to the [Docker Hub](https://hub.docker.com/r/nutsllc/toybox-redis/) which is the official docker image registory.

In addition, this image is compatible with [ToyBox](https://github.com/nutsllc/toybox) complytely to manage the applications on Docker.

## What is the ownCloud ?

>### Access & share your files, calendars, contacts, mail & more from any device, on your terms

>You can share one or more files and folders on your computer, and synchronize them with your ownCloud server. Place files in your local shared directories, and those files are immediately synchronized to the server and to other devices using the ownCloud Desktop Sync Client, Android app, or iOS app.

* [Learn more](http://redis.io/topics/introduction)
* [Official Demo](https://demo.owncloud.org/index.php/apps/files/)

## Run container

```bash
docker run -p 8888:80 -td nutsllc/toybox-owncloud:9.1.0-apache
```

Then open your web browser and access ``http://<HOST(IP Address)>:8888``

## Docker Compose example( with SQLite )

This is the simplest way to run the ownCloud using SQLite as a database of it.

```bash
owncloud:
    image: nutsllc/toybox-owncloud
    volumes:
        - "./.data/owncloud/config:/var/www/html/config"
        - "./.data/owncloud/data:/var/www/html/data"
    ports:
        - "8080:80"
```

## Docker Compose example( with MySQL )

Using MySQL as database for the owncloud, set ``DATABASE`` environment to ``mysql`` variable and also set ``OWNCLOUD_USER`` and ``OWNCLOUD_PASSWORD`` for initial admin account.

```bash
owncloud:
    image: nutsllc/toybox-owncloud
    links:
        - mysql:mysql
    environment:
        - DATABASE=mysql
        - OWNCLOUD_USER=toybox
        - OWNCLOUD_PASSWORD=toybox
        - TOYBOX_UID=1000
        - TOYBOX_GID=1000
    volumes:
        - "./.data/owncloud/config:/var/www/html/config"
        - "./.data/owncloud/data:/var/www/html/data"
    ports:
        - "8080:80"

mysql:
    image: nutsllc/toybox-mariadb:10.1.14
    volumes:
        - ./.data/mariadb:/var/lib/mysql
    environment:
        MYSQL_ROOT_PASSWORD: root
        MYSQL_DATABASE: owncloud
        MYSQL_USER: owncloud
        MYSQL_PASSWORD: owncloud
        TOYBOX_UID: 1000
        TOYBOX_GID: 1000
        TERM: xterm
    ports:
        - 3306
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/nutsllc/toybox-redis/issues), or submit a [pull request](https://github.com/nutsllc/toybox-redis/pulls) with your contribution.
