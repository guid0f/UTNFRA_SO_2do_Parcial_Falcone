#!/bin/bash  

# Comprobamos si se están ejecutando como root  
if [ "$EUID" -ne 0 ]; then  
    echo "Por favor, ejecute el script como root"  
    exit 1  
fi  

# Crear grupos de volúmenes y volúmenes lógicos  

# Crear un grupo de volúmenes llamado vg_datos  
pvcreate /dev/sdc /dev/sdd  
vgcreate vg_datos /dev/sdc  
vgcreate vg_temp /dev/sdd  

# Crear los volúmenes lógicos  
lvcreate -L 5M -n lv_docker vg_datos  
lvcreate -L 1.5G -n lv_workareas vg_datos  
lvcreate -L 512M -n lv_swap vg_temp  

# Crear los sistemas de archivos  
mkfs.ext4 /dev/vg_datos/lv_docker  
mkfs.ext4 /dev/vg_datos/lv_workareas  
mkswap /dev/vg_temp/lv_swap  

# Crear los puntos de montaje  
mkdir -p /var/lib/docker  
mkdir -p /work  

# Montar los volúmenes  
mount /dev/vg_datos/lv_docker /var/lib/docker  
mount /dev/vg_datos/lv_workareas /work  
swapon /dev/vg_temp/lv_swap  

# Agregar al fstab para montarlo automáticamente al arrancar  
echo "/dev/vg_datos/lv_docker /var/lib/docker ext4 defaults 0 2" >> /etc/fstab  
echo "/dev/vg_datos/lv_workareas /work ext4 defaults 0 2" >> /etc/fstab  
echo "/dev/vg_temp/lv_swap none swap sw 0 0" >> /etc/fstab  

echo "Configuración completada con éxito."
