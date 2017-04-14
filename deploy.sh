#!/bin/bash
# This script will test if you have given a leap year or not.

echo 'escribe la version de odoo que quieres desplegar, seguido de [ENTER] (valores permitidos:"8", "9", "10":'

read version

if [ $version == 8 ]; then
	sudo mkdir -p /opt/odoo8/addons /opt/odoo8/config /opt/odoo8/log
	sudo chmod -R 755 /opt/odoo8/
	sudo chmod -R 777 /opt/odoo8/log
	sudo cp ./openerp-server.conf /opt/odoo8/config
	docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo --name db8 postgres:9.4
	docker run -d -v /opt/odoo8/addons:/mnt/extra-addons -v /opt/odoo8/log:/var/log/odoo -v /opt/odoo8/config:/etc/odoo -p 8069:8069 --name odoo8 --link db8:db -t odoo:8
elif [ $version == 9 ]; then
	sudo mkdir -p /opt/odoo9/addons /opt/odoo9/config /opt/odoo9/log
	sudo chmod -R 755 /opt/odoo9/
	sudo chmod -R 777 /opt/odoo9/log
	sudo cp ./openerp-server.conf /opt/odoo9/config
	docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo --name db9 postgres:9.4
	docker run -d -v /opt/odoo9/addons:/mnt/extra-addons -v /opt/odoo9/log:/var/log/odoo -v /opt/odoo9/config:/etc/odoo -p 8070:8069 --name odoo9 --link db9:db -t odoo:9
else
	sudo mkdir -p /opt/odoo10/addons /opt/odoo10/config /opt/odoo10/log
	sudo chmod -R 755 /opt/odoo10
	sudo chmod -R 777 /opt/odoo10/log
	sudo cp ./odoo.conf /opt/odoo10/config
	docker run -d -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo --name db9 postgres:9.4
	docker run -d -v /opt/odoo10/addons:/mnt/extra-addons -v /opt/odoo10/log:/var/log/odoo -v /opt/odoo10/config:/etc/odoo -p 8071:8069 --name odoo10 --link db9:db -t odoo:10
fi

