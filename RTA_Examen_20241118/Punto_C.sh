#!/bin/bash

PATH_DE_TRABAJO_DOCKER="~/repogit/UTN-FRA_SO_Examenes/202406/docker"
echo "-----------------------------------------------------------------------------------------------------------"
cd $PATH_DE_TRABAJO_DOCKER

cat <<EOF > dockerfile
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
EOF

echo "Creando imagen de Docker… "

docker build -t guid0f/web1-falcone:latest .

docker push guid0f/web1-falcone:latest
echo "Imagen creada…"
docker images

sudo chmod 777 run.sh
./run.sh
echo "-------------------------------------------------------------------------------------------------------------"

echo " script que corre el contenedor disponible en el path: "
echo "$PATH_DE_TRABAJO_DOCKER"
echo
echo "-------------------------------------------------------------------------------------------------------------"

