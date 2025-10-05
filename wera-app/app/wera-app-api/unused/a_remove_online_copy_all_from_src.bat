set http_proxy=http://{Some_IP}:3128
set https_proxy=http://{Some_IP}:3128
ssh -i openssh-key root@{Some_IP} "rm -rf ~/src"
scp -i openssh-key -r src/ root@{Some_IP}:~/src
::ssh -i key-openssh root@{Some_IP} "chmod 777 ~/src/create-wera-app-api-linux.sh"
::ssh -i key-openssh root@{Some_IP} "chmod 777 ~/src/api2_multiprocess_starter.sh"
::ssh -i key-openssh root@{Some_IP} "chmod 777 ~/src/api2_multiprocess_variant_ssl_in_multiprocess.py"
::ssh -i key-openssh root@{Some_IP} "chmod 777 ~/src/activate.sh"
