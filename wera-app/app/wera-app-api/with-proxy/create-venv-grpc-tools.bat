cd ../
echo %path%
python -m venv venv-grpc-tools
cd src
echo %cd%
call activate-grpc-tools.bat
pip --proxy http://{Some_IP}:3128 install grpcio
pip --proxy http://{Some_IP}:3128 install grpcio-tools
pause
:: --proxy ....:....
