cd ../
echo %path%
python -m venv venv-grpc-tools
cd src
echo %cd%
call activate-grpc-tools.bat
pip install grpcio
pip install grpcio-tools
pause