cd ..
rm -rf venv wera-app-api-linux
python3 -m venv wera-app-api-linux
cd src
source ./activate.sh
# pip3 install flask
# pip3 install flask_restful
# pip3 install mysql-connector-python
# pip3 install firebase-admin

pip3 --proxy http://{PROXY_IP}:3128 install flask
pip3 --proxy http://{PROXY_IP}:3128 install flask_restful
pip3 --proxy http://{PROXY_IP}:3128 install mysql-connector-python
pip3 --proxy http://{PROXY_IP}:3128 install firebase-admin
pip3 --proxy http://{PROXY_IP}:3128 install google
pip3 --proxy http://{PROXY_IP}:3128 install protobuf
:: pip3 --proxy http://{PROXY_IP}:3128 install flask_mysqldb
:: pip3 --proxy http://{PROXY_IP}:3128 install grpcio
