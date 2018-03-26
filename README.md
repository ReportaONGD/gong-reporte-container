# Supported tags and respective `Dockerfile` links

- [`2.54`, `latest`  (*2.54/Dockerfile*)](https://github.com/ReportaONGD/gong-container/tree/master/2.54/Dockerfile)

# What is Gong-R?

Gong is a free and open source, web-based project management and issue tracking tool. It allows users to manage multiple projects and associated subprojects. 

> [http://gong.es](http://gong.es)

![logo](http://gong.es/IMG/siteon0.png)

## Run Gong with a Database

Running Gong with a database server is the recommened way.

1.	start gong

	```console
	$ docker run -d --name some-gong -e GONG_DB_HOST=MYSQL_HOST  reportaongd/gong
	```

## Via docker-compose
Example `docker-compose.yml` for gong:


```console
version: '3'

services:

db:
	image: mysql:5.7
	restart: always
	command: --sql-mode=''
	ports:
	- 3306:3306
	environment:
	- MYSQL_ROOT_PASSWORD=root

gong:
	image: reportaongd/gong:latest
	depends_on:
	- db
	volumes:
	- /my/own/datadir:/var/lib/gong/files
	ports:
	- 80:80
	- 443:443
	environment:
	- GONG_DB_HOST=db

gong-reporte:
	image: reportaongd/gong-reporte:latest
	depends_on:
	- db
	- gong
	volumes:
	- /my/own/datadir:/var/opt/Gong-Reporte
	ports:
	- 8080:8080
	environment:
	- GONG_REPORTE_DB_HOST=db
	- GONG_API_TOKEN_URL=http://gong
```
Run docker `docker-compose up`, wait for it to initialize completely, and visit http://swarm-ip:8080, http://localhost:8080, or http://host-ip:8080 (as appropriate).



## Accessing the Application

Currently, the default user and password is admin/admin


## Where to Store Data

Important note: There are several ways to store data used by applications that run in Docker containers. We encourage users of the `Gong` images to familiarize themselves with the options available, including:

-	Let Docker manage the storage of your files [by writing the files to disk on the host system using its own internal volume management](https://docs.docker.com/engine/tutorials/dockervolumes/#adding-a-data-volume). This is the default and is easy and fairly transparent to the user. The downside is that the files may be hard to locate for tools and applications that run directly on the host system, i.e. outside containers.
-	Create a data directory on the host system (outside the container) and [mount this to a directory visible from inside the container](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume). This places the database files in a known location on the host system, and makes it easy for tools and applications on the host system to access the files. The downside is that the user needs to make sure that the directory exists, and that e.g. directory permissions and other security mechanisms on the host system are set up correctly.

The Docker documentation is a good starting point for understanding the different storage options and variations, and there are multiple blogs and forum postings that discuss and give advice in this area. We will simply show the basic procedure here for the latter option above:

1.	Create a data directory on a suitable volume on your host system, e.g. `/my/own/datadir`.
2.	Start your `gong` container like this:

	```console
	$ docker run -d --name some-gong -v /my/own/datadir:/var/lib/gong/files --link some-mysql:mysql gong
	```

The `-v /my/own/datadir:/var/lib/gong/files` part of the command mounts the `/my/own/datadir` directory from the underlying host system as `/var/lib/gong/files` inside the container, where Gong will store uploaded files.

## Environment Variables

When you start the `Gong` image, you can adjust the configuration of the instance chanbing defautl values in .env file.

All those environment varibles can be overwriten this way:

```console
$ doc ker run -d --name some-gong -e GONG_DB_NAME=gong2  reportaongd/gong
```

### `RAILS_ENV`

This variable sets the environment for the application. If unspecified, it will default to `production`.

### `GONG_DB_ADAPTER`

This variable sets the database adapter for the application. If unspecified, it will default to `mysql2`. **Unless you're sure of what you're doing. Do not change this value**

### `GONG_DB_HOST`

This variable allows you to specify a custom database name. If unspecified, it will default to `localhost`. **Unless you're sure of what you're doing. Do not change this value**

### `GONG_DB_PORT`

This variable allows you to specify a custom database connection port. If unspecified, it will default to the regular connection ports: `3306`.

### `GONG_DB_USER`

This variable sets the user that Gong and any rake tasks use to connect to the specified database. If unspecified, it will default to `root`.

### `GONG_DB_PASSWORD`

This variable sets the password that the specified user will use in connecting to the database. If unspecified, it will default to `example`.

### `GONG_DB_NAME`

This variable sets the database that Gong will use in the specified database server. If not specified, it will default to `gong`.

### `GONG_DB_ENCODING`

This variable sets the character encoding to use when connecting to the database server. If unspecified, it will use the default for the `mysql2` library ([`UTF-8`](https://github.com/brianmario/mysql2/tree/18673e8d8663a56213a980212e1092c2220faa92#mysql2---a-modern-simple-and-very-fast-mysql-library-for-ruby---binding-to-libmysql)) for MySQL.


### `GONG_HOST`

This variable sets hostname where Gong is running . If not specified, it will default to `localhost`. **Unless you're sure of what you're doing. Do not change this value**

### `GONG_PORT`

This variable sets the hostname port where Gong is listening . If not specified, it will default to `80`. **Unless you're sure of what you're doing. Do not change this value**

### `GONG_PORT_SSL`

This variable sets the hostname port where Gong is listening . If not specified, it will default to `443`. **Unless you're sure of what you're doing. Do not change this value**

### `GOR_PLUGINS`

This variable sets the path of plugin's Gong . If not specified, it will default to `/home/app/plugins`. **Unless you're sure of what you're doing. Do not change this value**

### `GONGR_URL`

This variable sets the url of Gong-Reporte . If not specified, it will default to `http://localhost:8080/gong_r`. 

### `RAILS_VAR`

This variable sets the path of Gong's files. If not specified, it will default to `/var/lib/gong/files`. 

### `AD_CLIENT_ID`

This variable sets the Client Id for the Oauth communication between Gong a Gong-Reporte. If not specified, it will default to `71800f89-46e5-499a-b90c-f6163a90280cAA`. 

### `AD_CLIENT_PW`

This variable sets the Client Password for the Oauth communication between Gong a Gong-Reporte. If not specified, it will default to `f4363b9e-12a8-421e-88ae-010d406fa208AA`. 


# License



