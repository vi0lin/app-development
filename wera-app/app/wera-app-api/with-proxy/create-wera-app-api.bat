cd ../
echo %path%
python -m venv wera-app-api
cd src
echo %cd%
call activate.bat
:: pip install grpcio
pip install flask
pip install flask_restful
:: pip install flask_mysqldb
pip --proxy http://{Some_IP}:3128 install mysql-connector-python
pip --proxy http://{Some_IP}:3128 install firebase-admin
pip --proxy http://{Some_IP}:3128 install google
pip --proxy http://{Some_IP}:3128 install protobuf
pause
