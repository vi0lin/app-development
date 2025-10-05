set http_proxy=http://{Some_IP}:3128
set https_proxy=http://{Some_IP}:3128
scp -i key-openssh -r test.py root@{Some_IP}:~/test.py
scp -i key-openssh -r subp.py root@{Some_IP}:~/subp.py
ssh -i key-openssh root@{Some_IP} "chmod 777 ~/test.py"
ssh -i key-openssh root@{Some_IP} "chmod 777 ~/subp.py "
::ssh -i key-openssh root@{Some_IP} "cd test-env/bin && ./activate && cd ../../ && python3 ./test.py"
::pause
