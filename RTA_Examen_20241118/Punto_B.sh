#!/bin/bash

# Parametros
usuario_origen=$1
ruta_repo=$2
archivo_lista_usuarios="${ruta_repo}/202406/bash_script/Lista_Usuarios.txt"

# Obtener la clave del usuario origen
clave_origen=$(sudo getent shadow $usuario_origen | cut -d: -f2)

# Crear los grupos (extraer de la segunda columna y eliminar duplicados)
cat "$archivo_lista_usuarios" | cut -d',' -f2 | sort -u | xargs -I {} sudo groupadd {} 2>/dev/null

# Crear los usuarios (extraer de la primera columna y asignar el grupo correspondiente)
cat "$archivo_lista_usuarios" | cut -d',' -f1 | while read usuario; do
    grupo=$(grep -m1 "^$usuario" "$archivo_lista_usuarios" | cut -d',' -f2)
    sudo useradd -m -p "$clave_origen" -g "$grupo" "$usuario" 2>/dev/null
done

echo "Proceso completado."
