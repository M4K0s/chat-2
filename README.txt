

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


C:/mongodb/bin/mongod.exe --dbpath "C:\mongodb\data"


case "$1" in

   'prod')

       echo "======== Prod server start =========="

       nodemon ${project}_server_prod.coffee
      
   ;;

   'dev')

       echo "======== Dev server start ==========="

       nodemon ${project}_server_dev.coffee
   ;;

   'master')

       echo "======== Master server debug ========"

       nodemon ${project}_server_master.coffee
   ;;

   *)
       echo "Usage: $0 debug [prod|master|dev]"
   ;;
esac


echo
exit 0

