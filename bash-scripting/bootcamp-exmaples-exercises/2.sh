#!/bin/bash

if [ "$#" -eq 3 ]; then
    nombre=$1
    apellido1=$2
    apellido2=$3

    inicial_nombre=$(echo $nombre | cut -c 1)
    inicial_a1=$(echo $apellido1 | cut -c 1)
    inicial_a2=$(echo $apellido2 | cut -c 1)

    resultado="$inicial_nombre.$inicial_a1.$inicial_a2"

    echo "Las iniciales ::: $resultado"

else
    echo "Error: Debes proporcionar 3 argumentos"

fi