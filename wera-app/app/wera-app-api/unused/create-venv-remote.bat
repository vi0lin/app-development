ssh -i key-openssh root@{SOME_PUBLIC_IP} "pip3 install --upgrade pip"
ssh -i key-openssh root@{SOME_PUBLIC_IP} "rm -rf ~/wera-app-api-linux"
ssh -i key-openssh root@{SOME_PUBLIC_IP} "cd ~/src/ && source ./create-wera-app-api-linux.sh"