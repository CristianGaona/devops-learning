#!/bin/bash

## REPOSITORIO
REPO="app-295devops-travel"

#Validar el usuario root o super usuario

if [ "$EUID" -ne 0 ]; then
    echo "El script debe ser ejecutado por un usuario con privilegios de usuario root"
    exit 1
fi

echo "El usuario cuenta con los privilegios necesarios. Se procede a realizar las respectivas configuraciones e instalaciones"

# Comprobar existencia e instalación de herramientas

tools=("git" "php" "apache2" "mariadb-server")

for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "$tool no está instalado en el sistema."
    
    else
        echo "$tool está instalado en el sistema."
        apt-get install -y $tool
    fi
    
done



