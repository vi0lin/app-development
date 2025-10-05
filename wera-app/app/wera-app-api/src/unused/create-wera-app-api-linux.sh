cd ..
rm -rf venv wera-app-api-linux
python3 -m venv wera-app-api-linux
cd src
source ./activate.sh
# pip3 install flask
# pip3 install flask_restful
# pip3 install mysql-connector-python
# pip3 install firebase-admin

pip3 install flask_api
pip3 install flask
pip3 install flask_restful
pip3 install mysql-connector-python
pip3 install firebase-admin
pip3 install google
pip3 install protobuf
pip3 install grpcio
pip3 install redis
pip3 install psutil 


:: pip3 install flask_mysqldb
