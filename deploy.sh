#!/bin/bash
#instalacion de docker
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

#despliegue de contenedores
echo 'indica el numero de puerto de escucha para la instancia odoo, seguido de [ENTER]:'

read port

echo 'escribe la version de odoo que quieres desplegar, seguido de [ENTER] (valores permitidos:"8", "9", "10":'

read version

if [ $version = 8 ] || [ $version = 9 ] || [ $version = 10 ]; then
	sudo mkdir -p /opt/odoo$version/addons /opt/odoo$version/config /opt/odoo$version/log
	sudo chmod -R 755 /opt/odoo$version/
	sudo chmod -R 777 /opt/odoo$version/log
	if [ $version = 8 ] || [ $version = 9 ]; then
		sudo cp ./openerp-server.conf /opt/odoo$version/config
	else
		sudo cp ./odoo.conf /opt/odoo$version/config
	fi
	docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo --name db$version postgres:9.4
	docker run -d -v /opt/odoo$version/addons:/mnt/extra-addons -v /opt/odoo$version/log:/var/log/odoo -v /opt/odoo$version/config:/etc/odoo -p $port:8069 --name odoo$version --link db$version:db -t odoo:$version
else
	echo 'no existe la versión'
fi

