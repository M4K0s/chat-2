

При локальном использовании - установить глобально модули:

	npm install -g nodemon

	*ссылка: https://github.com/remy/nodemon

А также:

	MongoDB

	*ссылка: http://docs.mongodb.org/manual/tutorial/install-mongodb-on-windows/

#################


Пример запуска:

===== start.sh =====


#!/bin/bash

project="chat"

case "$1" in

 	'prod')

		echo "======== Prod server start =========="
		nodemon --debug ${project}_server_prod.coffee
		
	 ;;

	'dev')

		echo "======== Dev server start ==========="
		nodemon --debug ${project}_server_dev.coffee
	;;

	'master')

		echo "======== Master server start ========"
		nodemon --debug ${project}_server_master.coffee
	;;

	'db')
		rm C:/mongodb/data/mongod.lock
		C:/mongodb/bin/mongod --dbpath C:/mongodb/data --repair
		C:/mongodb/bin/mongod --dbpath C:/mongodb/data &
		exit 0
	;;

	*)
		echo "====================================="
		echo "Usage: $0 [prod|master|dev] or [db] if need database"
		echo "====================================="
	;;

esac


echo
exit 0





