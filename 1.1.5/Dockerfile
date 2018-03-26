FROM tomcat:7.0

LABEL maintainer="Raul Victoria Martin <raul.victoria@ezentis.com>"
LABEL version="1.1.5"

RUN apt-get update -qq && apt-get install -y \
		maven \
		openjdk-7-jdk \
		mysql-client \
		subversion \
		netcat

# Define where our application will live inside the image
ENV GONG_REPORTE_VER=1.1.5 \
	TMP_DIR=/tmp/gongr \
	GONG_REPORTE_HOST=localhost \
	GONG_REPORTE_PORT=8080 \
	GONG_REPORTE_DB_HOST=localhost \
	GONG_REPORTE_DB_PORT=3306 \
	GONG_REPORTE_DB_NAME=gongr \
	GONG_REPORTE_DB_USERNAME=root \
	GONG_REPORTE_DB_PASSWORD=root \
	GONG_REPORTE_FILES=/var/opt/Gong-Reporte \
	GONG_REPORTE_LOG=/var/log/gongr \
	GONG_URL=http://localhost \
	AD_CLIENT_ID=71800f89-46e5-499a-b90c-f6163a90280cAA \
	AD_CLIENT_PW=f4363b9e-12a8-421e-88ae-010d406fa208AA 

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR $TMP_DIR

# Download Gong-Reporte
RUN svn export --force https://gong.org.es/svn/gong-r/tags/GONGR_v1.1.5/GONGReporte_v$GONG_REPORTE_VER $TMP_DIR

COPY docker-entrypoint.sh .

COPY org-netbeans-core-1.0.jar .

RUN mvn install:install-file -Dfile=./org-netbeans-core-1.0.jar \
	 -DgroupId=org.netbeans.core -DartifactId=org-netbeans-core \
	 -Dversion=1.0 -Dpackaging=jar && \
	 mvn install && \
	 rm org-netbeans-core-1.0.jar && \
	 rm -r $CATALINA_HOME/webapps/* 

CMD ./docker-entrypoint.sh