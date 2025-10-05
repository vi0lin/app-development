call activate-grpc-tools.bat
pause
echo ??
echo %cd%
python -m grpc_tools.protoc -I./ --python_out=. --grpc_python_out=. ./api2.proto
pause
:: cd ../..
echo %cd%
pause
protoc --dart_out=grpc:./../../lib/generated -I. ./api2.proto
pause



::pub global activate protoc_plugin
::SET Environment Variables	G:\Programme\protoc\bin
::				G:\Programme\flutter\.pub-cache\bin
::				C:\tools\dart-sdk\bin
::				C:\Users\codek\AppData\Roaming\Pub\Cache\bin