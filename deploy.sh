#!/bin/bash

USERID=$(id -u)
repo="The-DevOps-Journey-101"

if [ "$USERID" -ne 0 ]; then
    echo "USUARIO ROOT"
    exit

fi 

echo "============================"
apt-get update
echo "EL servidor se encuntra actualizado"

apt install -y git 
echo "Instalando Git"

### Base de datos ####

if dpkg -s mariadb-server > /dev/null 2>&1; then
    echo "El servidor se encuntra actualizado"
else
    echo "Instalando MARIA DB"
    apt install -y mariadb-server

    systemctl start mariadb
    systemctl enable mariadb

echo "Configurando base de datos"
    mysql -e "
    CREATE DATABASE ecomdb;
    CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
    GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
    FLUSH PRIVILEGES;"

cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF

mysql < db-load-script.sql

fi

if dpkg -s apache2 > /dev/null 2>&1; then
    echo "Apache 2 se encunetra instalado"
else
    echo "Instalando apache 2"
    apt install apache2 -y
    apt install -y php libapache2-mod-php php-mysql
    systemctl start apache2 
    systemctl enable apache2 
    systemctl status apache2 
    mv /var/www/html/index.html /var/www/html/index.html.bkp
fi

if [ -d "$repo" ]; then
    echo  "La carpeta existe"
    rm -rf $repo
fi

echo "Instalando web"
sleep 1
git clone https://github.com/roxsross/$repo.git
cp -r $repo/CLASE-02/lamp-app-ecommerce/* /var/www/html
sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

systemctl reload apache2