#!/bin/bash
until nc -z $GONG_REPORTE_DB_HOST $GONG_REPORTE_DB_PORT; do
    echo "$(date) - waiting for mysql..."
    sleep 1
done

mkdir -p $GONG_REPORTE_LOG

	read -d '' gor_db <<EOF
create DATABASE /*!32312 IF NOT EXISTS*/ $GONG_REPORTE_DB_NAME;
grant ALL ON $GONG_REPORTE_DB_NAME.* TO '$GONG_REPORTE_DB_USER'@'%' IDENTIFIED BY '$GONG_REPORTE_DB_PASSWORD';
EOF
	
	echo "Creando $gor_db"
	echo "$gor_db" > ./gor_db.sql


mysql -h $GONG_REPORTE_DB_HOST -u $GONG_REPORTE_DB_USER -p$GONG_REPORTE_DB_PASSWORD < ./gor_db.sql

mysql -h $GONG_REPORTE_DB_HOST -u $GONG_REPORTE_DB_USER -p$GONG_REPORTE_DB_PASSWORD < /tmp/gongr/script_bbdd/gongr_v1.0.1.sql

rm ./gor_db.sql

app_config_path=$TMP_DIR/src/main/resources

	read -d '' database <<EOF
jdbc.driverClassName=com.mysql.jdbc.Driver
jdbc.dialect=org.hibernate.dialect.MySQLDialect
jdbc.url=jdbc\:mysql\://$GONG_REPORTE_DB_HOST\:$GONG_REPORTE_DB_PORT/$GONG_REPORTE_DB_NAME
jdbc.username=$GONG_REPORTE_DB_USER
jdbc.password=$GONG_REPORTE_DB_PASSWORD
hibernate.show_sql=false

ws.gong_authorized_uri=$GONG_URL/oauth/authorize
ws.gong_token_uri=$GONG_URL/oauth/token
ws.init_url=$GONG_URL

# datos localhost
ws.gong_client_id=$AD_CLIENT_ID
ws.gong_secret_id=$AD_CLIENT_PW
ws.gong_redirect_uri=http://$GONG_REPORTE_HOST:$GONG_REPORTE_PORT/gong_r/ws/authorized

EOF

echo "Creating file database.properties $database"

echo "$database" > $app_config_path/database.properties

	read -d '' application <<EOF
rutaBaseDoc=$GONG_REPORTE_FILES/informes
rutaBaseZip=$GONG_REPORTE_FILES/envios
rutaBaseXml=$GONG_REPORTE_FILES/xml

urlGongr=$GONG_URL


smtp.host.name=smtp.tuurl.com
smtp.host.port=25
smtp.auth.user=smtpuser
smtp.auth.pwd=smptpass
smtp.smtp.from=tumail@tuurl.com
gong.activado.envio.mails=0
EOF

echo "Creating file aplicacion.properties $aplicacion"

echo "$application" > $app_config_path/aplicacion.properties

mkdir -p $GONG_REPORTE_FILES/informes/ $GONG_REPORTE_FILES/envios/ $GONG_REPORTE_FILES/xml


 	read -d '' log <<EOF
# Direct log messages to a log file
log4j.appender.fileerror=org.apache.log4j.RollingFileAppender
log4j.appender.fileerror.File=$GONG_REPORTE_LOG/loging-error.log
log4j.appender.fileerror.MaxFileSize=20MB
log4j.appender.fileerror.MaxBackupIndex=1
log4j.appender.fileerror.layout=org.apache.log4j.PatternLayout
log4j.appender.fileerror.layout.ConversionPattern=%d{ABSOLUTE} %5p %c{1}:%L - %m%n 
log4j.appender.fileerror.threshold = debug

# Direct log messages to stdout
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target=System.out
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d{ABSOLUTE} %5p %c{1}:%L - %m%n
 
# Root logger option
log4j.rootLogger = INFO, stdout
log4j.category.org.springframework.beans.factory=INFO
log4j.category.org.springframework=debug
log4j.category.org.springframework.transaction=TRACE
EOF

echo "Creating file log4j.properties $log"
echo "$log" > $app_config_path/log4j.properties


#mvn install 
mvn -e clean install -Dmaven.test.skip=true
cp target/gong_r.war $CATALINA_HOME/webapps

catalina.sh run
