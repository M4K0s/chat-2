

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


echo "========= `date` - START SERVER ========="


C:/mongodb/bin/mongod.exe --dbpath "C:\mongodb\data" & nodemon chat_server_prod.coffee

echo
exit 0