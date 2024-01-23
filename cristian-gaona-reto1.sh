#!/bin/bash

repo="app-295devops-travel"
#Validar el usuario root o super usuario

if [ "$EUID" -ne 0 ]; then
    echo "El script debe ser ejecutado por un usuario con privilegios de usuario root"
    exit 1
fi

echo "El usuario cuenta con los privilegios necesarios. Se procede a realizar las respectivas configuraciones e instalaciones"

### STAGE 1 [INITIALIZATION]
echo "Se esta ejecutando el STAGE 1 [Init]"
# Actualizar el sistema
 sudo apt-get update
 echo "El servidor se encuentra actualizado"

# Comprobar existencia e instalación de herramientas

tools=("git" "php7.4-fpm" "apache2" "mariadb-server" "php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-json php-curl")

for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "$tool no está instalado en el sistema."
        apt install -y $tool
    else
        echo "$tool está instalado en el sistema."
    fi
done

services=("php7.4-fpm" "apache2" "mariadb")

for service in "${services[*]}"; do
    
    if ! systemctl is-active --quiet "$service"  && ! systemctl is-enabled --quiet "$service"; then
        echo "$service no está activo en el sistema."
        systemctl start $service
        systemctl enable $service
    else
        echo "$service está activo en el sistema."
    fi
done

# Configuración de base de datos
#if mysql -e "SHOW DATABASES LIKE devopstravel" | grep devopstravel &> /dev/null; then
    #echo "La base de datos devopstravel ya existe. No se ejecutará la creación."
#else
mysql -e "
CREATE DATABASE devopstravel;
CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
FLUSH PRIVILEGES;"
#fi
mysql < bootcamp-devops-2023/app-295devops-travel/database/devopstravel.sql

### STAGE 2 [BUILD]
echo "Se esta ejecutando el STAGE 2 [Build]"

# Archivo de configuración
archivo_configuracion="/etc/apache2/mods-enabled/dir.conf"

# Verificar si el archivo de configuración existe
if [ ! -f "$archivo_configuracion" ]; then
    echo "Error: El archivo de configuración $archivo_configuracion no existe."
    exit 1
fi

# Realizar los cambios en el archivo de configuración
sed -i '/<IfModule mod_dir.c>/,/<\/IfModule>/ s/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/' "$archivo_configuracion"

echo "Se han realizado los cambios en el archivo $archivo_configuracion"

# Verificar existencia de repositorio
if [ -d "bootcamp-devops-2023" ]; then
    echo  "La carpeta existe, se actualiza repositorio"
    git --git-dir=bootcamp-devops-2023/.git --work-tree=bootcamp-devops-2023 checkout clase2-linux-bash
    git --git-dir=bootcamp-devops-2023/.git --work-tree=bootcamp-devops-2023 pull origin clase2-linux-bash
else
    # Clonar el repositorio de la aplicación
    git clone -b clase2-linux-bash --single-branch https://github.com/roxsross/bootcamp-devops-2023.git
    cp -r bootcamp-devops-2023/$repo/* /var/www/html
    mv /var/www/html/index.html /var/www/html/index.html.bkp
    echo "El repositorio se ha clonado en el sistema."
fi

nueva_contrasena="codepass"
archivo_config="/var/www/html/config.php"

# Verificar si el archivo de configuración existe
if [ -f "$archivo_config" ]; then
    # Actualizar la contraseña en el archivo de configuración
    sed -i "s/\(\$dbPassword = \).*/\1\"$nueva_contrasena\";/" "$archivo_config"
    echo "La contraseña en $archivo_config se ha actualizado correctamente."
else
    echo "Error: El archivo de configuración $archivo_config no existe."
    exit 1
fi

## STAGE 3: [Deploy]
echo "Se esta ejecutando el STAGE 3 [Deploy]"
# Reiniciar servicios
systemctl reload apache2

# STAGE 4: [Notify]
echo "Se esta ejecutando el STAGE 4 [Notify]"
#chmod +x ./discord.sh
#./discord.sh

