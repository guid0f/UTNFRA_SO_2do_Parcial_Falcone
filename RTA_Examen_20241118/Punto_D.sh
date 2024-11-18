#!/bin/bash

# Configuraciones iniciales
BASE_DIR=/UTN-FRA_SO_Examenes/202406/ansible
ROLE_DIR="$BASE_DIR/roles/2do_parcial"
TEMPLATE_DIR="$ROLE_DIR/templates"
TASKS_FILE="$ROLE_DIR/tasks/main.yml"
PLAYBOOK_FILE="$BASE_DIR/playbook.yml"

# Crear directorios necesarios
mkdir -p $TEMPLATE_DIR

# Crear archivo de plantilla datos_alumno.txt.j2 si no existe
if [ ! -f "$TEMPLATE_DIR/datos_alumno.txt.j2" ]; then
    cat <<EOL > $TEMPLATE_DIR/datos_alumno.txt.j2
Nombre: {{ Guido }}
Apellido: {{ Falcone }}
Division: {{ 311 }}
EOL
    echo "Archivo $TEMPLATE_DIR/datos_alumno.txt.j2 creado."
else
    echo "Archivo $TEMPLATE_DIR/datos_alumno.txt.j2 ya existe."
fi

# Crear archivo de plantilla datos_equipo.txt.j2 si no existe
if [ ! -f "$TEMPLATE_DIR/datos_equipo.txt.j2" ]; then
    cat <<EOL > $TEMPLATE_DIR/datos_equipo.txt.j2
IP: {{ ip }}
Distribución: {{ distro }}
Cantidad de Cores: {{ cores }}
EOL
    echo "Archivo $TEMPLATE_DIR/datos_equipo.txt.j2 creado."
else
    echo "Archivo $TEMPLATE_DIR/datos_equipo.txt.j2 ya existe."
fi

# Crear archivo de tareas main.yml si no existe
if [ ! -f "$TASKS_FILE" ]; then
    cat <<EOL > $TASKS_FILE
- name: Crear directorios necesarios
  file:
    path: "/tmp/2do_parcial/{{ item }}"
    state: directory
    mode: '0755'
  loop:
    - alumno
    - equipo

- name: Crear archivo de datos del alumno
  template:
    src: templates/datos_alumno.txt.j2
    dest: /tmp/2do_parcial/alumno/datos_alumno.txt
  vars:
    nombre: "Guido"
    apellido: "Falcone"
    division: "311"

- name: Crear archivo de datos del equipo
  template:
    src: templates/datos_equipo.txt.j2
    dest: /tmp/2do_parcial/equipo/datos_equipo.txt
  vars:
    ip: "tu-ip"
    distro: "tu-distro"
    cores: "tu-cantidad-de-cores"

- name: Configurar sudoers para el grupo 2PSupervisores
  copy:
    content: '%2PSupervisores ALL=(ALL) NOPASSWD: ALL'
    dest: /etc/sudoers.d/2psupervisores
    validate: 'visudo -cf %s'
EOL
    echo "Archivo $TASKS_FILE creado."
else
    echo "Archivo $TASKS_FILE ya existe."
fi

# Crear el archivo playbook.yml si no existe
if [ ! -f "$PLAYBOOK_FILE" ]; then
    cat <<EOL > $PLAYBOOK_FILE
- name: Configuración del 2do Parcial
  hosts: localhost
  tasks:
    - include_role:
        name: 2do_parcial
EOL
    echo "Archivo $PLAYBOOK_FILE creado."
else
    echo "Archivo $PLAYBOOK_FILE ya existe."
fi

# Crear o verificar el archivo hosts
INVENTORY_FILE="$BASE_DIR/inventory/hosts"
if [ ! -f "$INVENTORY_FILE" ]; then
    mkdir -p $(dirname $INVENTORY_FILE)
    cat <<EOL > $INVENTORY_FILE
[localhost]
localhost ansible_connection=local
EOL
    echo "Archivo $INVENTORY_FILE creado."
else
    echo "Archivo $INVENTORY_FILE ya existe."
fi

# Ejecutar el playbook de Ansible
cd $BASE_DIR
ansible-playbook -i inventory/hosts playbook.yml
