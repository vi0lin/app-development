ssh -i key-openssh root@{SOME_PUBLIC_IP} "rm -rf ~/src"
scp -i key-openssh -r src/ root@{SOME_PUBLIC_IP}:~/src
ssh -i key-openssh root@{SOME_PUBLIC_IP} "chmod 777 ~/src/create-wera-app-api-linux.sh"
ssh -i key-openssh root@{SOME_PUBLIC_IP} "chmod 777 ~/src/api2_multiprocess_starter.sh"
ssh -i key-openssh root@{SOME_PUBLIC_IP} "chmod 777 ~/src/activate.sh"
::ssh -i key-openssh root@{SOME_PUBLIC_IP} "kill `netstat -nataup | grep python3 | awk '{print $7}' | sed 's/\//\t/' | awk '{print $1}'`"
ssh -i key-openssh root@{SOME_PUBLIC_IP} "netstat -taupn | grep python3 | awk '{print $7}' | sed 's/\//\t/' | awk '{print $1}' | xargs kill"
ssh -i key-openssh root@{SOME_PUBLIC_IP} "cd ~/src/ && source ./api2_multiprocess_starter.sh"
pause
::netstat -taupn | grep python3 | awk '{print $7}' | sed 's/\//\t/' | awk '{print $1}' | xargs kill
