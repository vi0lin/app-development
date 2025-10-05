cd ../
set http_proxy=http://{Some_IP}:3128
set https_proxy=http://{Some_IP}:3128
echo %path%
python -m venv wera-app-api
cd src
echo %cd%
call activate.bat
pip install grpcio
pip install flask
pip install flask_restful
:: pip install flask_mysqldb
pip install mysql-connector-python
pip install firebase-admin
pip install google
pip install protobuf
pip install redis
pip install flask_api
pause
