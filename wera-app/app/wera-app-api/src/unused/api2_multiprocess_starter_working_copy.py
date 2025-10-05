from threading import Thread
import socket               # Import socket module
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)         # Create a socket object
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
host = '{WERA_STEUERUNG_API_DOMAIN}' # socket.gethostname() # Get local machine name
remote_host = '127.0.0.1'
port = 9000 # Reserve a port for your service.
print(host+':'+str(port))
print('Server started!')
print('Waiting for clients...')

import sys



kill = False


import redis
r = redis.Redis(host='127.0.0.1', port=6379, db=0)


clients = []
global processes
processes = []



import os
# from multiprocessing import Pool
import subprocess
# from subprocess import Popen, PIPE, STDOUT
from subprocess import *
import sys
import threading
from nbstreamreader import NonBlockingStreamReader as NBSR
from time import sleep

terminateAll = False

import select
import sys

class ClientThread(threading.Thread):
    def __init__(self, clientSocket, targetHost, targetPort):
        threading.Thread.__init__(self)
        self.__clientSocket = clientSocket
        self.__targetHost = targetHost
        self.__targetPort = targetPort
        
    def run(self):
        # print("woooop")
        
        self.__clientSocket.setblocking(0)
        
        targetHostSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        connected = False
        while not connected:
            try:
                targetHostSocket.connect((self.__targetHost, self.__targetPort))
                connected = True
            except:
                connected = False
        targetHostSocket.setblocking(0)
        
        clientData = b""
        targetHostData = b""
        terminate = False
        while not terminate and not terminateAll:
            inputs = [self.__clientSocket, targetHostSocket]
            outputs = []
            
            if len(clientData) > 0:
                outputs.append(self.__clientSocket)
                
            if len(targetHostData) > 0:
                outputs.append(targetHostSocket)
            
            try:
                inputsReady, outputsReady, errorsReady = select.select(inputs, outputs, [], 1.0)
            except Exception as e:
                print(e)
                break
                
            for inp in inputsReady:
                if inp == self.__clientSocket:
                    try:
                        data = self.__clientSocket.recv(4096)
                    except Exception as e:
                        print(e)
                    
                    if data != None:
                        if len(data) > 0:
                            targetHostData += data
                        else:
                            terminate = True
                elif inp == targetHostSocket:
                    try:
                        data = targetHostSocket.recv(4096)
                    except Exception as e:
                        print(e)
                        
                    if data != None:
                        if len(data) > 0:
                            clientData += data
                        else:
                            terminate = True
                        
            for out in outputsReady:
                if out == self.__clientSocket and len(clientData) > 0:
                    bytesWritten = self.__clientSocket.send(clientData)
                    if bytesWritten > 0:
                        clientData = clientData[bytesWritten:]
                elif out == targetHostSocket and len(targetHostData) > 0:
                    bytesWritten = targetHostSocket.send(targetHostData)
                    if bytesWritten > 0:
                        targetHostData = targetHostData[bytesWritten:]
        
        self.__clientSocket.close()
        targetHostSocket.close()
        print("ClienThread terminating")



def handle(buffer):
    return buffer

def transfer(p, clientSrc, clientPort, src, dst, direction):
    # print("src")
    # print(src)
    # print("dst")
    # print(dst)
    src_name = src.getsockname()
    src_address = src_name[0]
    src_port = src_name[1]
    dst_name = dst.getsockname()
    dst_address = dst_name[0]
    dst_port = dst_name[1]
    while True:
        try:
            buffer = src.recv(0x400)
            print(".")
            if len(buffer) == 0:
                print("[-] No data received! Breaking...")
                break
            # print "[+] %s:%d => %s:%d [%s]" % (src_address, src_port, dst_address, dst_port, repr(buffer))
            if direction:
                print("[+] %s:%d >|> %s:%d >>> %s:%d [%d]" % (clientSrc, clientPort, src_address, src_port, dst_address, dst_port, len(buffer)))
            else:
                print("[+] %s:%d <|< %s:%d <<< %s:%d [%d]" % (clientSrc, clientPort, dst_address, dst_port, src_address, src_port, len(buffer)))
            dst.send(handle(buffer))
        except OSError as e:
            print("OSERROR!!" + str(e))
            # if p in processes:
            #     processes.remove(p)
            #     p.kill()
            pass
        except:
            pass
            # print("error.")
    p.kill()
    print("[+] Closing connecions! [%s:%d]" % (src_address, src_port))
    src.shutdown(socket.SHUT_RDWR)
    src.close()
    # print("[+] Closing connecions! [%s:%d]" % (dst_address, dst_port))
    # dst.shutdown(socket.SHUT_RDWR)
    # dst.close()

push = []

import _thread
from threading import Timer

def run_with_timeout(timeout, default, f, *args, **kwargs):
    if not timeout:
        return f(*args, **kwargs)
    try:
        timeout_timer = Timer(timeout, _thread.interrupt_main)
        timeout_timer.start()
        result = f(*args, **kwargs)
        return result
    except KeyboardInterrupt:
        return default
    finally:
        timeout_timer.cancel()

def usage():
    print("[][][] WELCOME TO SERVER ")
    print("h help how ?                prints help")
    print("a [0...n/all] [message]     answer ")
    print("q quit exit bye s           quit")
    print("ls                          list all pushes")
    print("ips                         prints all ips")
    print("proc p pr                   prints stdin of last subprocess")
    print("r read [0...n]              reads specified process")

global readAll
readAll = True

global currentThread
currentThread = None

def socketBinding():
    # print(str(host)+':'+str(port)+' already in use?')
    s.bind((host, port))
    s.listen(5)

    while not kill:
        # for p in processes:                    'HAS NOT WORKED
        #     stdout, stderr = p.communicate()   'HAS NOT WORKED
        #     print(stdout)                      'HAS NOT WORKED
        c, addr = s.accept()
        # print("ACCEPT")
        # print(addr in r.lrange("ips", 0, -1))
        if addr not in clients:
            clients.append(addr)
            #r.rpush("ips", *addr)
            
            processPort = find_free_port()#30000+(len(clients)) # r.llen("ips")
            
            # r.set('addr:'+str(addr[0])+':'+str(addr[1]), str(processPort), ex=5)
                    
            print(addr[0] + ':' + str(addr[1]) + ' -> ' + str(processPort))
            #print(str(len(clients))) # r.llen("ips")
            # if False:                                                                       # r.llen("ips")
            # p = subprocess.Popen([sys.executable,
            #     "api2_multiprocess_variant_ssl_in_multiprocess.py",
            #     str(processPort),
            #     str(addr)],
            #     stdin=subprocess.PIPE,
            #     stdout=subprocess.PIPE,
            #     stderr=subprocess.PIPE,
            #     shell=False)#, creationflags=CREATE_NEW_CONSOLE)#, capture_output=True),# start_new_session=False, shell=False, #  stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            # subprocess.run(["api2_multiprocess_variant_ssl_in_multiprocess.py", str(processPort), str(addr), " > ~/src/log/logfile 2>&1"])
            # p = subprocess.Popen([sys.executable,
            # "api2_multiprocess_variant_ssl_in_multiprocess.py",
            #     str(processPort),
            #     str(addr), ' > ./log/logfile 2>&1'],
            #     stdin=subprocess.PIPE,#sys.stdout,
            #     stdout=subprocess.PIPE,#sys.stdout,
            #     stderr=subprocess.PIPE,#sys.stderr,
            #     shell=True)
            # else:
            #     p = subprocess.Popen([sys.executable, "api2_multiprocess.py", str(processPort), str(r.llen("ips"))], stdin=PIPE, stderr=PIPE, stdout=PIPE, shell=True)#, creationflags=CREATE_NEW_CONSOLE)#, capture_output=True),# start_new_session=False, shell=False, #  stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            # p = None
            # v = [sys.executable, "api2_multiprocess_variant_ssl_in_multiprocess.py", str(processPort), str(addr[0]), str(addr[1])] # , '>>', '~/src/log/logfile'
            # print(v)
            # p = subprocess.Popen(v)

            # r.rpush("proc:"+p.pid, *p)

            # cmd = "python3 ./api2_multiprocess_variant_ssl_in_multiprocess.py "+str(processPort)+" "+str(addr[0])+" "+str(addr[1])+" > ~/src/log/logfile"
            # print(cmd)
            # os.system(cmd)

           

            # from multiprocessing import Process
            # p = Process(target=startNewProcess, args=(str(processPort),str(addr[0]),str(addr[1]),))
            # p.start()
            # p.join()
            p = subprocess.Popen(['stdbuf', '--output=L', "python3", "-u",
                "api2_multiprocess_variant_ssl_in_multiprocess.py",
                str(processPort),
                str(addr[0]),
                str(addr[1])],
                bufsize=1, stdout=PIPE, stderr=STDOUT, close_fds=True,
                stdin=subprocess.PIPE
                # stdout=subprocess.PIPE,
                # stderr=sys.stdout,
                # shell=True,
                )

            processes.append(p)
            # print('pid: ' + str(p.pid))

        #for p in processes:
            # def readThread(p):
            #     try:
            #         # print(p)
            #         # from time import sleep
            #         # for number in range(1,20):
            #         #     b.stdout.flush()
            #         #      
            #         #     print(p.stdout.readline())
            #         nbsr = NBSR(p.stdout)
            #         # sleep(3)
            #         while True:
            #             output = nbsr.readline(0.1)
            #             # 0.1 secs to let the shell output the result
            #             if not output:
            #                 print('[No more data]')
            #                 t2._stop()
            #                 break
            #             print(output)
            #     except:
            #         pass
            #         print("readThread closed.")
            # t2 = Thread(target=readThread(p))
            # t2.start()

            # p = Popen(cmd, stdout=PIPE, stderr=PIPE)
            # stdout, stderr = p.communicate()
            # print(stdout)
            # print(stderr)
            # os.system('python api2_multiprocess.py ' + processPort)
            # execfile('api2_multiprocess.py ' + processPort)
            # os.spawnl(os.P_DETACH, 'api2_multiprocess.py', str(processPort))
            # print("waiting to bind...")
            # sleep(2)
            # try transfer
            # remote_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            # remote_socket.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
            # remote_socket.bind(('localhost', processPort))
            # import ssl
            # wrappedSocket = ssl.wrap_socket(remote_socket, ssl_version=ssl.PROTOCOL_TLSv1_2)
            
            # print(remote_host)
            # print(processPort)
            
            # # remote_socket.connect((remote_host, processPort))
            # print("[+] Tunnel connected! Tranfering data...")
            # # threads = []
            # print("remote socket")
            # print(remote_socket)
            # print("c")
            # print(c)
            # print(" ")
            # send = threading.Thread(target=transfer, args=(p, addr[0], addr[1], remote_socket, c, False))
            # recv = threading.Thread(target=transfer, args=(p, addr[0], addr[1], c, remote_socket, True))
            # # threads.append(s)
            # # threads.append(r)
            # send.start()
            # recv.start()
            ClientThread(c, 'localhost', processPort).start()

    # msg = c.recv(1024)
    # msg = input('SERVER >> ')
    # c.send(msg)
    #c.close()

    ####################################

    # #!/usr/bin/env python
    # # -*- coding: utf-8 -*-
    # # Tcp Port Forwarding (Reverse Proxy)
    # # Author : WangYihang <wangyihanger@gmail.com>


    # import socket
    # import threading
    # import sys


    # def handle(buffer):
    #     return buffer


    # def transfer(src, dst, direction):
    #     src_name = src.getsockname()
    #     src_address = src_name[0]
    #     src_port = src_name[1]
    #     dst_name = dst.getsockname()
    #     dst_address = dst_name[0]
    #     dst_port = dst_name[1]
    #     while True:
    #         buffer = src.recv(0x400)
    #         if len(buffer) == 0:
    #             print "[-] No data received! Breaking..."
    #             break
    #         # print "[+] %s:%d => %s:%d [%s]" % (src_address, src_port, dst_address, dst_port, repr(buffer))
    #         if direction:
    #             print "[+] %s:%d >>> %s:%d [%d]" % (src_address, src_port, dst_address, dst_port, len(buffer))
    #         else:
    #             print "[+] %s:%d <<< %s:%d [%d]" % (dst_address, dst_port, src_address, src_port, len(buffer))
    #         dst.send(handle(buffer))
    #     print "[+] Closing connecions! [%s:%d]" % (src_address, src_port)
    #     src.shutdown(socket.SHUT_RDWR)
    #     src.close()
    #     print "[+] Closing connecions! [%s:%d]" % (dst_address, dst_port)
    #     dst.shutdown(socket.SHUT_RDWR)
    #     dst.close()


    # def server(local_host, local_port, remote_host, remote_port, max_connection):
    #     server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    #     server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    #     server_socket.bind((local_host, local_port))
    #     server_socket.listen(max_connection)
    #     print '[+] Server started [%s:%d]' % (local_host, local_port)
    #     print '[+] Connect to [%s:%d] to get the content of [%s:%d]' % (local_host, local_port, remote_host, remote_port)
    #     while True:
    #         local_socket, local_address = server_socket.accept()
    #         print '[+] Detect connection from [%s:%s]' % (local_address[0], local_address[1])
    #         print "[+] Trying to connect the REMOTE server [%s:%d]" % (remote_host, remote_port)
    #         remote_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    #         remote_socket.connect((remote_host, remote_port))
    #         print "[+] Tunnel connected! Tranfering data..."
    #         # threads = []
    #         s = threading.Thread(target=transfer, args=(
    #             remote_socket, local_socket, False))
    #         r = threading.Thread(target=transfer, args=(
    #             local_socket, remote_socket, True))
    #         # threads.append(s)
    #         # threads.append(r)
    #         s.start()
    #         r.start()
    #     print "[+] Releasing resources..."
    #     remote_socket.shutdown(socket.SHUT_RDWR)
    #     remote_socket.close()
    #     local_socket.shutdown(socket.SHUT_RDWR)
    #     local_socket.close()
    #     print "[+] Closing server..."
    #     server_socket.shutdown(socket.SHUT_RDWR)
    #     server_socket.close()
    #     print "[+] Server shuted down!"








from contextlib import closing

def find_free_port():
    with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as s:
        s.bind(('', 0))
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        return s.getsockname()[1]

# import NewProcess
# def startNewProcess(a, b, c):
#     NewProcess(a, b, c).start()

        
from threading import Thread

def writeSubprocessLoop():
    global readAll
    while True:
        # print("subprocess loop disabled.")
        # print(currentThread)
        # for p in processes:
        #     print(p.stdout.read())
        #working
        if currentThread:
            line = currentThread.stdout.readline()
            print(line.decode(), end='')
            if not line:
                break
            readAll = False
        elif readAll:
            for p in processes:
                line = p.stdout.readline()
                print(line.decode(), end='')
                if not line:
                    break
        else:
            sleep(1)

def killLoop():
    global currentThread
    currentThread = None
    while True:
        for p in processes:
            if p.poll() != None:
                print(currentThread)
                print("killing")
                if currentThread == p:
                    currentThread = None
                processes.remove(p) 
                
        sleep(1)


# def main():
#     if len(sys.argv) != 5:
#         print "Usage : "
#         print "\tpython %s [L_HOST] [L_PORT] [R_HOST] [R_PORT]" % (sys.argv[0])
#         print "Example : "
#         print "\tpython %s 127.0.0.1 8888 127.0.0.1 22" % (sys.argv[0])
#         print "Author : "
#         print "\tWangYihang <wangyihanger@gmail.com>"
#         exit(1)
#     LOCAL_HOST = sys.argv[1]
#     LOCAL_PORT = int(sys.argv[2])
#     REMOTE_HOST = sys.argv[3]
#     REMOTE_PORT = int(sys.argv[4])
#     MAX_CONNECTION = 0x10
#     server(LOCAL_HOST, LOCAL_PORT, REMOTE_HOST, REMOTE_PORT, MAX_CONNECTION)

global cleanDead
cleanDead = Thread(target=killLoop)
cleanDead.daemon = True
cleanDead.start()

global writeSub
writeSub = Thread(target=writeSubprocessLoop)
writeSub.daemon = True
writeSub.start()

global t
t = Thread(target=socketBinding)
t.daemon = True
t.start()

#cli
i = None
while i not in ["quit", "exit", "bye", "q", "s"]:
    # try:
    try:
        i = input('> ')
        # print(f'you printed {i}')
        if i in ["whoami", "whereami", "who"]:
            print("mainprocess")
        # if i in ["a"]:
        #     currentThread=processes[0]
        # if i in ["b"]:
        #     currentThread=processes[1]
        if i in ["c"]:
            currentThread = None
            print(currentThread)
        
        if i in ["proc", "p", "pr"]:
            # print(processes[len(processes)-1].communicate()[0])
            print("currentThread:")
            print(currentThread)
            print("")
            print("processes:")
            for p in processes:
                print(p)#print(processes)
                if p.poll() == None:
                    print("\talive")
                else:
                    print("\tdead")
            # import fcntl
            # import select
            # import os
            # p = processes[len(processes)-1]
            # fcntl.fcntl(
            #     p.stdout.fileno(),
            #     fcntl.F_SETFL,
            #     fcntl.fcntl(p.stdout.fileno(), fcntl.F_GETFL) | os.O_NONBLOCK,
            # )
            # while p.poll() == None:
            #     readx = select.select([p.stdout.fileno()], [], [])[0]
            #     if readx:
            #         chunk = p.stdout.read()
            #         print(chunk)
        if i in ["ips", "ip"]:
            print(r.lrange("ips", 0, -1))
        if i in ["help", "h", "how", "?"]:
            usage()
        if i.split(' ', 1)[0] in ["r", "read"]:
            try:
                # if i.split(' ', 1)[1] == "all":
                #     for p in processes:
                #         print(p)
                #         # # for line in p.stdout: 
                #         # #     print(">>> " + str(line.rstrip())) 
                #         # #     p.stdout.flush()
                #         # line = await asyncio.wait_for(p.stdout.readline(), 20)
                #         # if not line: # EOF
                #         #     break
                #         # else: 
                #         #     print(line) # while some criterium is satisfied
                #         # try:
                #         #     while True:
                #         #         print(p.stdout.readline())
                #         # except KeyboardInterrupt:
                #         #     pass
                #         # def readThread(p):
                #         #     try:
                #         #         # print(p)
                #         #         # from time import sleep
                #         #         # for number in range(1,20):
                #         #         #     b.stdout.flush()
                #         #         #      
                #         #         #     print(p.stdout.readline())
                #         #         nbsr = NBSR(p.stdout)
                #         #         sleep(1)
                #         #         while True:
                #         #             output = nbsr.readline(0.1)
                #         #             # 0.1 secs to let the shell output the result
                #         #             if not output:
                #         #                 print('[No more data]')
                #         #                 t2._stop()
                #         #                 break
                #         #             print(output)
                #         #     except:
                #         #         pass
                #         #         print("readThread closed.")
                #         # t2 = Thread(target=readThread(p))
                #         # t2.start()
                #             # line = run_with_timeout(2, None, p.stdout.readline)
                #             # if line is None:
                #             #     break
                #             # else:
                #             #     print(line)
                # elif i.split(' ', 1)[1].isdigit():
                if i.split(' ', 1)[1].isdigit():
                    # print(i.split(' ', 1)[1])
                    # print(processes)
                    readAll = False
                    currentThread = processes[int(i.split(' ', 1)[1])]
                    print(currentThread)
                    # for line in processes[i.split(' ', 1)[1]].stdout: 
                    #     print(">>> " + str(line.rstrip())) 
                    #     p.stdout.flush()
                elif i.split(' ', 1)[1].upper() == "ALL":
                    readAll = True
                    currentThread = None
                else:#elif i.split(' ', 1)[1].upper() == "NONE":
                    readAll = False
                    currentThread = None
                
                # print(i.split(' ', 1)[0])
                # print(i.split(' ', 1)[1])
            except Exception as e:
                print("r read [0...n/all]")
                print(str(e))
        if i.split(' ', 2)[0] in ["w", "write", "ans", "answer"]:
            # print(i.split(' ', 1)[1])
            # push.append(i.split(' ', 1)[1])
            try:
                if i.split(' ', 2)[1] == "all":
                    for p in processes:
                        # print(p)
                        p.stdin.write(('%s\n' % i.split(' ', 2)[2]).encode())
                        p.stdin.flush()
                elif i.split(' ', 2)[1].isdigit():
                    p = processes[int(i.split(' ', 2)[1])]
                    print(p)
                    p.stdin.write(('%s\n' % i.split(' ', 2)[2]).encode())
                    p.stdin.flush()
                
                # print(i.split(' ', 2)[0])
                # print(i.split(' ', 2)[1])
                # print(i.split(' ', 2)[2])
            except Exception as e:
                print("a/ans/answer [0...n/all] message")
                print("a/ans/answer [0...n/all] help")
                print("a/ans/answer [0...n/all] a Test")
                print("a/ans/answer [0...n/all] ls")
                print(str(e))
                # # def thread(p):
                # # p.communicate(input=b'a Broadcast Push')[0]
                # # p.stdin.write(b'a test\n')
                # # p.communicate()
                # # read, write = os.pipe()
                # # os.write(write, b'a Broadcast Push')
                # # os.close(write)
                # # p.check_call(['a test2'], stdin=read)
                
                # # x = p.stdin
                # # p.stdin = subprocess.PIPE
                # # print(i.split(' ', 1)[1])
                # # p.stdin.write(i.split(' ', 1)[1].encode()) #expects a bytes type object
                # #p.stdin.write(b'brc') #expects a bytes type object
                # # p.check_output(["a ", "brc"], universal_newlines=True)
                # # p.stdin.close()
                # # p.stdin.write(b'a brc\n') # <<--- wokring!!
                # p.stdin.write(('a %s\n' % i.split(' ', 1)[1]).encode())
                # p.stdin.flush()
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # print(p.stdout.readline())
                # # p.stdout.flush()
                # # p.communicate(b'a brc\n')[0]
                # # print("after timeout.")
                # # sys.stdin.read()
                # # p.stdin.close()
                # # p.stdin = x
                # # def readThread():
                # #     print(p.stdout.readline())
                # #     t2._stop()
                # # t2 = Thread(target=readThread(p))
                # # t2.start()
                # # t2.join()
        if i in ["redis"]:
            #print(push)
            # print(processes)
            #print(clients)
            #print(r.lrange("ips", 0, -1))
            for key in r.scan_iter("addr:*"):
                # delete the key
                print(str(key) + ' -> ' + str(r.get(key)))
        # except:
        #    print("type help")
    except Exception as e:
        print(e)

t._stop()
s.shutdown()
s.close()
kill = True





    
# if __name__ == "__main__":
#     main()
