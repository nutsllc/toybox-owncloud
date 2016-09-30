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
docker run -p 8080:80 -td nutsllc/toybox-owncloud:9.1.0-apache
```

Then, access it via http://localhost:8080 or http://host-ip:8080 in a browser.

## Auto configuration

By applying ``DATABASE`` environment variable value, it will be set database configuratin and APC cache up automatically.

If you'd like to run the owncloud with sqlite database and configure them automatically, set ``-e DATABASE=sqlite``. 

Example:

```bash
docker run -p 8080:80 -e DATABASE=sqlite -td nutsllc/toybox-owncloud:9.1.0-apache
```

If you'd like to run the owncloud with mysql database and configure them automatically, set ``-e DATABASE=mysql`` and ``--link`` option.

Example:

```bash
docker run -p 8080:80 --link some-mysql:mysql -e DATABASE=mysql -td nutsllc/toybox-owncloud:9.1.0-apache
```

When you run owncloud instance with auto configuration, you can log it in by toybox/toybox.

## Changing initial account for auto configuration

If you'd like to change username and password of an initial account, set ``-e OWNCLOUD_ADMIN_USER=your-admin-username`` and ``-e OWNCLOUD_ADMIN_PASSWORD=your-admin-password``.

## Docker Compose example( with SQLite auto configuration )

Run docker-compose up, and visit http://localhost:8080 or http://host-ip:8080.

```bash
owncloud:
    image: nutsllc/toybox-owncloud:latest
    environment:
    	- DATABASE=sqlite
        - OWNCLOUD_ADMIN_USER=admin
        - OWNCLOUD_ADMIN_PASSWORD=mypass
    volumes:
        - "./data/owncloud/data:/var/www/html/data"
    ports:
        - "8080:80"
```

## Docker Compose example( with MySQL auto configuration)

Run docker-compose up, wait for it to initialize completely, and visit http://localhost:8080 or http://host-ip:8080.

```bash
owncloud:
    image: nutsllc/toybox-owncloud:latest
    links:
        - mysql:mysql
    environment:
        - DATABASE=mysql
        - OWNCLOUD_ADMIN_USER=admin
        - OWNCLOUD_ADMIN_PASSWORD=mypass
    volumes:
        - "./data/owncloud/data:/var/www/html/data"
    ports:
        - "8080:80"

mysql:
    image: nutsllc/toybox-mariadb:10.1.14
    volumes:
        - ./data/mariadb:/var/lib/mysql
    environment:
        MYSQL_ROOT_PASSWORD: root
        MYSQL_DATABASE: owncloud
        MYSQL_USER: owncloud
        MYSQL_PASSWORD: owncloud
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/nutsllc/toybox-redis/issues), or submit a [pull request](https://github.com/nutsllc/toybox-redis/pulls) with your contribution.
