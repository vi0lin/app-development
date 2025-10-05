set http_proxy=http://{Some_IP}:3128
set https_proxy=http://{Some_IP}:3128
scp -i key-openssh -r src/api2_multiprocess_starter.py root@{Some_IP}:~/src/api2_multiprocess_starter.py
scp -i key-openssh -r src/api2_multiprocess_variant_ssl_in_multiprocess.py root@{Some_IP}:~/src/api2_multiprocess_variant_ssl_in_multiprocess.py
scp -i key-openssh -r src/api1_Thread.py root@{Some_IP}:~/src/api1_Thread.py
::ssh -i key-openssh root@{Some_IP} "chmod 777 ~/src/api2_multiprocess_starter.sh"
::ssh -i key-openssh root@{Some_IP} "chmod 777 ~/src/api2_multiprocess_variant_ssl_in_multiprocess.py "
::rundll32.exe Kernel32.dll,Beep 220,3
::rundll32.exe cmdext.dll,MessageBeepStub
rundll32 user32.dll,MessageBeep
