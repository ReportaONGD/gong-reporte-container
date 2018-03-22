# Supported tags and respective `Dockerfile` links

- [`1.1.5`, `latest`  (*1.1.5/Dockerfile*)](https://github.com/ReportaONGD/gong-reporte-container/tree/master/1.1.5/Dockerfile)

# What is Gong-R?

Gong-R is a free and open source, web-based reporting tool for Gong.

> [https://gong.org.es/projects/gongr](https://gong.org.es/projects/gongr)

![logo](http://gong.es/IMG/siteon0.png)

## Run Gong with a Database Container

Running Gong with a database server is the recommened way.

1.	start gong

	```console
	$ docker run -d --name some-gong-r -e GONG_REPORTE_DB_HOST=MYSQL_HOST  reportaongd/gong-reporte
	```

## Where to Store Data

Important note: There are several ways to store data used by applications that run in Docker containers. We encourage users of the `Gong-R` images to familiarize themselves with the options available, including:

-	Let Docker manage the storage of your files [by writing the files to disk on the host system using its own internal volume management](https://docs.docker.com/engine/tutorials/dockervolumes/#adding-a-data-volume). This is the default and is easy and fairly transparent to the user. The downside is that the files may be hard to locate for tools and applications that run directly on the host system, i.e. outside containers.
-	Create a data directory on the host system (outside the container) and [mount this to a directory visible from inside the container](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume). This places the database files in a known location on the host system, and makes it easy for tools and applications on the host system to access the files. The downside is that the user needs to make sure that the directory exists, and that e.g. directory permissions and other security mechanisms on the host system are set up correctly.

The Docker documentation is a good starting point for understanding the different storage options and variations, and there are multiple blogs and forum postings that discuss and give advice in this area. We will simply show the basic procedure here for the latter option above:

1.	Create a data directory on a suitable volume on your host system, e.g. `/my/own/datadir`.
2.	Start your `gong` container like this:

	```console
	$ docker run -d --name some-gong-r -v /my/own/datadir:/var/opt/Gong-Reporte --link some-mysql:mysql gong
	```

The `-v /my/own/datadir:/var/opt/Gong-Reporte` part of the command mounts the `/my/own/datadir` directory from the underlying host system as `/var/opt/Gong-Reporte` inside the container, where Gong will store uploaded files.

## Environment Variables

All those environment varibles can be overwriten this way:

```console
$ docker run -d --name some-gong-r -e GONG_REPORTE_DB_NAME=gong-reporte  reportaongd/gong-reporte
```

### `GONG_REPORTE_DB_HOST`

This variable allows you to specify a custom database name. If unspecified, it will default to `localhost`. **Unless you're sure of what you're doing. Do not change this value**

### `GONG_REPORTE_DB_PORT`

This variable allows you to specify a custom database connection port. If unspecified, it will default to the regular connection ports: `3306`.

### `GONG_REPORTE_DB_USER`

This variable sets the user that Gong and any rake tasks use to connect to the specified database. If unspecified, it will default to `root`.

### `GONG_REPORTE_DB_PASSWORD`

This variable sets the password that the specified user will use in connecting to the database. If unspecified, it will default to `root`.

### `GONG_REPORTE_DB_NAME`

This variable sets the database that Gong will use in the specified database server. If not specified, it will default to `gongr`.

### `GONG_REPORTE_HOST`

This variable sets hostname where Gong is running . If not specified, it will default to `localhost`. **Unless you're sure of what you're doing. Do not change this value**

### `GONG_REPORTE_PORT`

This variable sets the hostname port where Gong is listening . If not specified, it will default to `8080`. **Unless you're sure of what you're doing. Do not change this value**


### `GONG_URL`

This variable sets the url of Gong-Reporte . If not specified, it will default to `http://localhost`. 

### `GONG_REPORTE_FILES`

This variable sets the path where Gong-Reporte's files are storaged. If not specified, it will default to `/var/opt/Gong-Reporte`.

### `GONG_REPORTE_LOG`

This variable sets the path where Gong-Reporte's logs are storaged . If not specified, it will default to `/var/log/gongr`. 



# License



