# Ejercicio-1 Linux y Automatización

## Reto
Se debe crear un script en bash que permita instalar la web, la base de datos, el servidor Apache sobre linux [ubuntu] todo lo necesario para desplegar la web en el servidor. esta estrategia de enfoque es una arquitectura LAMP

"LAMP" es un conjunto de aplicaciones de software de código abierto que se suelen instalar juntas para que un servidor pueda alojar aplicaciones y sitios web dinámicos escritos en PHP. Este término es en realidad un acrónimo que representa al sistema operativo Linux, con el servidor web Apache. Los datos del sitio se almacenan en una base de datos MySQL y el contenido dinámico se procesa mediante PHP.

Las letras en LAMP representan:

* **Linux**: El sistema operativo en el que se ejecutarán las aplicaciones web. Linux es una opción popular debido a su estabilidad y escalabilidad.
* **Apache**: El servidor web. Apache es uno de los servidores web más utilizados en el mundo y es conocido por ser confiable y altamente configurable.
* **MySQ**L: El sistema de gestión de bases de datos relacional. MySQL se utiliza para almacenar y administrar los datos de la aplicación web.
* **PHP (o a veces, Perl o Python): El lenguaje de programación utilizado para desarrollar la lógica de la aplicación web. PHP es el lenguaje más comúnmente asociado con LAMP, pero en algunos casos se pueden usar Perl o Python.
* **Sistema Operativo**: Ubuntu
---
## Solución
Este repositorio contiene dos scripts:

**cristian-gaona-reto1.sh**: Este script contiene la automatización de la instalación de paquetes necesarios para el servidor web, la configuración de la base de datos, la actualización de archivos de configuración y la implementación de una aplicación desde un repositorio remoto.

**discord.sh**:  Este script contine la automatización de notificar en discord el status de la aplicacion

---

# Autor

Cristian Gaona

---

# Objetivo

Automatizar la configuración de un servidor web con una aplicación desplegada.

---

# Descripción

Este script automatiza la configuración e instalación de herramientas necesarias en un entorno de servidor web. Además, realiza la configuración de la base de datos, la actualización de archivos de configuración y la implementación de una aplicación desde un repositorio remoto.

---

# Requisitos

- El script debe ser ejecutado por un usuario con privilegios de superusuario (root).
- Se ha usado killercoda para ejecutar el script

---

# Pasos del script

## STAGE 1: Init
* Instalacion de paquetes en el sistema operativo ubuntu: [apache, php, mariadb, git, curl, etc]
* Validación si esta instalado los paquetes o no , de manera de no reinstalar
* Habilitar y Testear instalación de los paquetes

## STAGE 2: Build
* Clonar el repositorio de la aplicación
* Validar si el repositorio de la aplicación no existe realizar un git clone. y si existe un git pull
* Mover al directorio donde se guardar los archivos de configuración de apache /var/www/html/
* Testear existencia del codigo de la aplicación
* Ajustar el config de php para que soporte los archivos dinamicos de php agregando index.php
* Testear la compatibilidad -> ejemplo http://localhost/info.php
* Si te muestra resultado de una pantalla informativa php , estariamos funcional para la siguiente etapa.
## STAGE 3: Deploy
* Es momento de probar la aplicación, recuerda hacer un reload de apache y acceder a la aplicacion DevOps Travel
* Aplicación disponible para el usuario final.
## STAGE 4: Notify
* El status de la aplicacion si esta respondiendo correctamente o esta fallando debe reportarse via webhook al canal de discord #deploy-bootcamp
* Informacion a mostrar : Author del Commit, Commit, descripcion, grupo y status
----

# Uso

```bash
chmod +x ./cristian-gaona-reto1.sh // Otorgar permisos de ejecución
```

```bash
./cristian-gaona-reto1.sh // Ejecutar el script
```