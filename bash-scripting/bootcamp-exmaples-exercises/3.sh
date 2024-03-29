#!/bin/bash

TASK_FILE="tarea.txt"


# Funciones

agregar_tarea() {
    echo "Ingrese la descripcion de la tarea: "
    read descripcion
    echo "Ingrese fecha de vencimiento (Formato yyyy-mm-dd): "
    read fecha
    tarea_id=$(date +%s)
    echo "$tarea_id | $descripcion | $fecha" >> $TASK_FILE
    echo "Tarea agregada con el ID $tarea_id"
}

listar_tareas() {
    echo "Listado de tareas"
    echo "ID | Descripcion | Fecha de vencimiento | Completada"
    echo "-----------------------------------------------------------------------------------"
    while IFS="|" read id descripcion fecha completada; do
        tarea_id=$(echo $id)
        descripcion=$(echo $descripcion)
        fecha=$(echo $fecha)
        completada=$(echo $completada)
        echo "$tarea_id | $descripcion | $fecha | $completada"
        echo "---------------------------------------------------------------------------------"
    done < "$TASK_FILE"
    
}

marcar(){
    echo "Ingrese el ID de la tarea a marcar como completada: "
    read tarea_id
    sed -i "/^$tarea_id/s/$/ | Tarea completada/" "$TASK_FILE"
    echo "Tarea $tarea_id marcada como completada."
}

eliminar() {
    echo "Ingrese el ID de la tarea a eliminar: "
    read tarea_id
    sed -i "/^$tarea_id/d" $TASK_FILE
    echo "Tarea $tarea_id eliminada"
}

# Menu principal
while true; do
    echo "Sistema de tareas"
    echo "1. Agregar tarea"
    echo "2. Listar tarea"
    echo "3. Marcar tarea completada"
    echo "4. Eliminar tarea"
    echo "5. Salir del programa"
    echo -n "Seleccione una opcion: "
    read opcion

    case $opcion in
        1)  agregar_tarea ;;
        2)  listar_tareas ;;
        3)  marcar ;;
        4)  eliminar ;;
        5)  echo "Saliendo del programa"; exit;;
        *)  echo "Opcion invalida" ;;
    esac
done
