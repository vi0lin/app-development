#@echo off
#set OPENSSL_CONF=c:\OpenSSL-Win64\bin\openssl.cfg   
#pass=38d7b7f0285056a505e336fa3e35f156
#cert="/C=DE/ST=NRW/L=Duisburg/O=/OU=/CN={SOME_PUBLIC_IP}"
#echo Generate CA key:
openssl genrsa -passout pass:38d7b7f0285056a505e336fa3e35f156 -des3 -out ca.key 4096
#echo Generate CA certificate:
openssl req -passin pass:38d7b7f0285056a505e336fa3e35f156 -new -x509 -days 365 -key ca.key -out ca.crt -subj  "/C=DE/ST=NRW/L=Duisburg/O=/OU=/CN={SOME_PUBLIC_IP}"
#echo Generate server key:
openssl genrsa -passout pass:38d7b7f0285056a505e336fa3e35f156 -des3 -out server.key 4096
#echo Generate server signing request:
openssl req -passin pass:38d7b7f0285056a505e336fa3e35f156 -new -key server.key -out server.csr -subj  "/C=DE/ST=NRW/L=Duisburg/O=/OU=/CN={SOME_PUBLIC_IP}"
#echo Self-sign server certificate:
openssl x509 -req -passin pass:38d7b7f0285056a505e336fa3e35f156 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt
#echo Remove passphrase from server key:
openssl rsa -passin pass:38d7b7f0285056a505e336fa3e35f156 -in server.key -out server.key
#echo Generate client key
openssl genrsa -passout pass:38d7b7f0285056a505e336fa3e35f156 -des3 -out client.key 4096
#echo Generate client signing request:
openssl req -passin pass:38d7b7f0285056a505e336fa3e35f156 -new -key client.key -out client.csr -subj  "/C=DE/ST=NRW/L=Duisburg/O=/OU=/CN={SOME_PUBLIC_IP}"
#echo Self-sign client certificate:
openssl x509 -passin pass:38d7b7f0285056a505e336fa3e35f156 -req -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out client.crt
#echo Remove passphrase from client key:
openssl rsa -passin pass:38d7b7f0285056a505e336fa3e35f156 -in client.key -out client.key
