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

tools=("git" "php" "apache2" "mariadb")

for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "$tool no está instalado en el sistema."
    
    else
        echo "$tool está instalado en el sistema."
        apt-get install -y $tool
    fi
done
services=("php" "apache2" "mariadb")

for service in "${services[@]}"; do
    
    if ! systemctl is-active --quiet "$service"  && ! service is-enable --quiet "$service"; then
        echo "$service no está activo en el sistema."
        systemctl start $service
        systemctl enable $service
    else
        echo "$service está activo en el sistema."
    fi
done

# Configuración de base de datos

mysql -e "
CREATE DATABASE devopstravel;
CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
FLUSH PRIVILEGES;"

mysql < database/devopstravel.sql

### STAGE 2 [BUILD]
echo "Se esta ejecutando el STAGE 2 [Build]"

# Clonar el repositorio de la aplicación


git clone -b clase2-linux-bash --single-branch https://github.com/roxsross/bootcamp-devops-2023.git
cp -r bootcamp-devops-2023/$repo/* /var/www/html
mv /var/www/html/index.html /var/www/html/index.html.bkp
sed -i 's/""/"codepass"/g' /var/wwww/html/
echo "El repositorio se ha clonado en el sistema."


# Reiniciar servicios

sudo systemctl restart apache2
