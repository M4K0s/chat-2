

��� ��������� ������������� - ���������� ��������� ������:

	npm install -g nodemon

	*������: https://github.com/remy/nodemon

� �����:

	MongoDB

	*������: http://docs.mongodb.org/manual/tutorial/install-mongodb-on-windows/

#################


������ �������:

===== start.sh =====

#!/bin/bash


echo "========= `date` - START SERVER ========="


C:/mongodb/bin/mongod.exe --dbpath "C:\mongodb\data" & nodemon chat_server_prod.coffee

echo
exit 0