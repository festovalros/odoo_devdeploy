#!/bin/bash
#instalacion de docker

read -p "Escoge tu siste operativo: 1. debian 2. ubuntu 3. archlinux " os
if [ "$os" = "1" ]; then
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' docker-ce|grep "install ok installed")
	echo "Revisando instalacion de docker: $PKG_OK"
	if [ "" == "$PKG_OK" ]; then 
	  echo "No instalado. empezando instalacion."
	  sudo apt-get remove docker docker-engine 
	  sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
	  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
	  sudo apt-get update
	  sudo apt-get install docker-ce
	  sudo groupadd docker
	  sudo usermod -aG docker $(whoami)
	else
		echo "docker previamente instalado"
	fi
fi
#despliegue de contenedores
echo 'indica el numero de puerto de escucha para la instancia odoo, seguido de [ENTER]:'

read port

echo 'escribe la version de odoo que quieres desplegar, seguido de [ENTER] (valores permitidos:"8", "9", "10", "11":'

read version

echo 'escribe el nombre de la instancia'

read name

read -p "deseas que el cotenedor se auto-inicie con el sistema (s/n)?" resp
if [ "$resp" = "s" ]; then
  restart=" --restart always";
fi
echo "auto-inicio desactivado"

if [ $version = 8 ] || [ $version = 9 ] || [ $version = 10 ] || [ $version = 11 ]; then
	sudo mkdir -p /opt/$name/addons /opt/$name/config /opt/$name/log
	sudo chmod -R 755 /opt/$name/
	sudo chmod -R 777 /opt/$name/log
	if [ $version = 8 ] || [ $version = 9 ]; then
		sudo cp ./openerp-server.conf /opt/$name/config
	else
		sudo cp ./odoo.conf /opt/$name/config
	fi 
	sudo docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo$restart --name db$name postgres:9.4
	sudo docker run -d -v /opt/$name/addons:/mnt/extra-addons -v /opt/$name/log:/var/log/odoo -v /opt/$name/config:/etc/odoo -p $port:8069$restart --name $name --link db$name:db -t odoo:$version
else
	echo 'no existe la versión'
fi

