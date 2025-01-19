#!/bin/bash

docker network create --attachable -d bridge "${RADIUSDESK_NETWORK}"

source ./.env

echo Radiusdesk 2-docker system builder v1.0
echo ---------------------------------------
echo
echo Special shout out to:
echo - Dirk van der Walt for building this brilliant software and helping debug the dockers
echo - Enock Mbewe for building the first docker version and showing the way with supervisord
echo - Keegan White for all the work on traefik and improving the iNethi architecture
echo
echo Starting Build ....
echo
echo Copying database files to volume mounts for MariaDB ...
mkdir  -p "${RADIUSDESK_VOLUME}"
mkdir  -p "${RADIUSDESK_VOLUME}/db_startup"
mkdir  -p "${RADIUSDESK_VOLUME}/db_conf"
chmod -R 777 "${RADIUSDESK_VOLUME}"
chmod -R 777 "${RADIUSDESK_VOLUME}/db_startup"
chmod -R 777 "${RADIUSDESK_VOLUME}/db_conf"

if [ -d "rdcore" ]
then
    echo "Directory rdcore exists."
else
    git clone https://github.com/RADIUSdesk/rdcore
fi

cp rdcore/cake4/rd_cake/setup/db/rd.sql "${RADIUSDESK_VOLUME}/db_startup"
cp db_priveleges.sql "$RADIUSDESK_VOLUME/db_startup"
cp startup.sh "$RADIUSDESK_VOLUME/db_startup"
cp my_custom.cnf "$RADIUSDESK_VOLUME/db_conf"

echo
echo Building docker database container ...
#docker-compose config
docker compose up -d rdmariadb
echo
echo Waiting for MariaDB to come up ...
sleep 60

echo Creating database for Radiusdesk ...
# Build daatabase
docker exec -u 0 -it radiusdesk-mariadb /tmp/startup.sh
echo
echo Building Radiusdesk container with nginx, php-fpm and freeradius ...

docker compose build
docker compose up -d radiusdesk

echo
echo All done!
