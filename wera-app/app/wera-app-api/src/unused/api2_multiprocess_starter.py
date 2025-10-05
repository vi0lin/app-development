from api2_multiprocess_variant_ssl_in_multiprocess import API2Multiprocess
from api1_Thread import API1
from threading import Thread
import socket               # Import socket module

class API2(object):
    holder = []

#from multiprocessing import Process, Pipe, Queue
import multiprocessing

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)         # Create a socket object
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

hostip = socket.gethostbyname(socket.gethostname())
if hostip == '127.0.1.1': # Linux
    import psutil
    host = '{WERA_STEUERUNG_API_DOMAIN}' # Serving for Outsiders.
    localhost='127.0.0.1'
else: # Windows
    host = 'localhost'
    localhost='localhost'


# remote_host = '127.0.0.1'
port = 9000 # Reserve a port for your service.

import redis
r = redis.Redis(host=localhost, port=6379, db=0)

import sys

# result_queue = multiprocessing.Queue()

kill = False

def multiprocessing_func(holder, c, processPort, addr, addrPort, child_conn, parent_conn):
    # print("Test!")

    identifier = 'addr:'+str(addr)+':'+str(addrPort)+'->'+str(processPort)

    c1 = ClientThread(c, localhost, processPort, child_conn, identifier)
    a1 = API2Multiprocess(processPort, addr, addrPort, API2.holder, child_conn, identifier)

    c1.start()
    a1.start()
    # p1.join()
    # c1.join()
    # print("---")
    # print("---")
    # print(kill)
    """ while not kill:
        # print("---")
        event = parent_conn.recv()
        # print(event)
        if event is None:
            break
        if event.startswith('update '):
            print("update triggered")#OnUpdate()
        elif event.startswith('kill '):
            print("kill triggered")
            key = event.split(" ",1)[1]
            print("Event: ")
            print(event)
            child_conn.send("killbill " + key)
            print("key: " + key)
            remove_Holder(key)
            break """
    c1.join()
    a1.join()
    print("going out of multiprocess_func")
    

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
    def __init__(self, clientSocket, targetHost, targetPort, child_conn, identifier):
        threading.Thread.__init__(self)
        # print("trying to connect internal")
        self.__clientSocket = clientSocket
        self.__targetHost = targetHost
        self.__targetPort = targetPort
        self.identifier = identifier
        self.child_conn = child_conn
        # self.__p = p
        
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
        # self.__p.kill()
        self.child_conn.send("killbill "+self.identifier)



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
def getIdentifyer(addr, processPort):
    return "addr:"+addr[0]+":"+str(addr[1])+"->"+str(processPort)
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

        memory = psutil.virtual_memory()
        # memory = 0
        
        if memory.percent <= 80:
            
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

                writeSub = Thread(target=writeSubprocess, args=(p,))
                writeSub.start()

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
                ClientThread(c, localhost, processPort).start()
        else:
            print("preventing out of mem: %s connections." % len(clients))
            c.close()
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
# global acceptCounter
# acceptCounter = 0
def socketBinding2():
    # print(str(host)+':'+str(port)+' already in use?')
    print("API2 #> "+ str(host)+':'+str(port))
    s.bind((host, port))
    s.listen(5)
    # global acceptCounter
    while not kill:
        # for p in processes:                    'HAS NOT WORKED
        #     stdout, stderr = p.communicate()   'HAS NOT WORKED
        #     print(stdout)                      'HAS NOT WORKED
        c, addr = s.accept()
        # acceptCounter = acceptCounter+1
        # print(str(acceptCounter))
        
        #print("ACCEPT")
        # print(addr in r.lrange("ips", 0, -1))
        memory = psutil.virtual_memory()
        if memory.percent <= 80:
            if addr not in clients:
                
                # clients.append(addr)

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
                
                
                # > p = subprocess.Popen(['stdbuf', '--output=L', "python3", "-u",
                # >     "api2_multiprocess_variant_ssl_in_multiprocess.py",
                # >     str(processPort),
                # >     str(addr[0]),
                # >     str(addr[1])],
                # >     bufsize=1, stdout=PIPE, stderr=STDOUT, close_fds=True,
                # >     stdin=subprocess.PIPE
                # >     # stdout=subprocess.PIPE,
                # >     # stderr=sys.stdout,
                # >     # shell=True,
                # >     )
                child_conn, parent_conn = multiprocessing.Pipe()
                p = multiprocessing.Process(target=multiprocessing_func, args=([API2.holder], c, processPort, addr[0], addr[1], child_conn, parent_conn))

                # processes.append(p)
                p.start()

                API2.holder.append(((getIdentifyer(addr, processPort), p, c, addr, processPort, child_conn, parent_conn)))

                def test(parent_conn):
                    while True:
                        event = parent_conn[0].recv()
                        if event is None:
                            break
                        elif event.startswith('killbill '):
                            key = event.split(" ",1)[1]
                            # print("key in killbill: " + key)
                            # print("holder in killbill:")
                            # print(API2.holder)
                            remove_Holder(key)
                            break
                import threading
                t = threading.Thread(target=test, args=([parent_conn],))
                t.daemon = True
                t.start()

                # > writeSub = Thread(target=writeSubprocess, args=(p,))
                # > writeSub.start()

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
                # p.join()
        else:
            print("preventing out of mem: %s connections." % len(clients))
            c.close()
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

def socketBinding3():
    import asyncio
    import json
    import logging
    import websockets
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)

    logging.basicConfig()

    STATE = {"value": 0}

    USERS = set()


    def state_event():
        return json.dumps({"type": "state", **STATE})

    def users_event():
        return json.dumps({"type": "users", "count": len(USERS)})

    async def notify_state():
        if USERS:  # asyncio.wait doesn't accept an empty list
            message = state_event()
            await asyncio.wait([user.send(message) for user in USERS])

    async def notify_users():
        if USERS:  # asyncio.wait doesn't accept an empty list
            message = users_event()
            await asyncio.wait([user.send(message) for user in USERS])

    async def notify_message(message):
        if USERS:  # asyncio.wait doesn't accept an empty list
            json.dumps({"type": "message", "message": message})
            await asyncio.wait([user.send(message) for user in USERS])

    async def register(websocket):
        USERS.add(websocket)
        await notify_users()

    async def unregister(websocket):
        USERS.remove(websocket)
        await notify_users()

    async def counter(websocket, path):
        # register(websocket) sends user_event() to websocket
        await register(websocket)
        try:
            await websocket.send(state_event())
            async for message in websocket:
                print(message)
                data = json.loads(message)
                if data["action"] == "minus":
                    STATE["value"] -= 1
                    await notify_state()
                elif data["action"] == "plus":
                    STATE["value"] += 1
                    await notify_state()
                elif data["action"] == "message":
                    await notify_message(data["message"])
                else:
                    logging.error("unsupported event: {}", data)
        finally:
            await unregister(websocket)

    start_server = websockets.serve(counter, "0.0.0.0", 5005)
    print("ws:// or wws://")
    asyncio.get_event_loop().run_until_complete(start_server)
    asyncio.get_event_loop().run_forever()
    # import asyncio
    # import pathlib
    # import ssl
    # import websockets

    # loop = asyncio.new_event_loop()
    # asyncio.set_event_loop(loop)

    # async def hello(websocket, path):
    #     print("hello")
    #     name = await websocket.recv()
    #     print(f"< {name}")

    #     greeting = f"Hello {name}!"

    #     await websocket.send(greeting)
    #     print(f"> {greeting}")

    #                         # import socket, ssl

    #                         # context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    #                         # context.load_cert_chain(certfile="ssl/server.crt", keyfile="ssl/server.key")

    #                         # bindsocket = socket.socket()
    #                         # bindsocket.bind((host, 10777))
    #                         # bindsocket.listen(5)
    #                         # print("running TCP server")
    #                         # while True:
    #                         #     newsocket, fromaddr = bindsocket.accept()
    #                         #     print("recieving")
    #                         #     connstream = context.wrap_socket(newsocket, server_side=True)


    # ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    # # localhost_pem = pathlib.Path(__file__).with_name("ssl/server.pem")
    # # ssl_context.load_cert_chain(localhost_pem)
    # ssl_context.load_cert_chain('ssl/server.pem')

    # start_server = websockets.serve(
    #     hello, "127.0.1.1", 5005, ssl=ssl_context
    # )

    # asyncio.get_event_loop().run_until_complete(start_server)
    # asyncio.get_event_loop().run_forever()

def do_something(connstream, data):
    print("recieving Data.")
    print(data)  
def deal_with_client(connstream):
    data = connstream.read()
    # null data means the client is finished with us
    while data:
        if not do_something(connstream, data):
            # we'll assume do_something returns False
            # when we're finished with client
            break
        data = connstream.read()
    # finished with client
def tcpList():
    import socket, ssl

    context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    context.load_cert_chain(certfile="ssl/server.crt", keyfile="ssl/server.key")

    bindsocket = socket.socket()
    bindsocket.bind((host, 10777))
    bindsocket.listen(5)
    print("running TCP server")
    while True:
        newsocket, fromaddr = bindsocket.accept()
        print("recieving")
        connstream = context.wrap_socket(newsocket, server_side=True)
        print("handshaked?")
        try:
            
            deal_with_client(connstream)
        finally:
            connstream.shutdown(socket.SHUT_RDWR)
            connstream.close()





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

def writeSubprocess(p):
    for stdout_line in iter(p.stdout.readline, ""):
        if currentThread == p or readAll:
            print(stdout_line)
        if p.poll() != None:
            break
    # while True:
    #     line = p.stdout.readline()
    #     print(line.decode(), end='')
    #     if not line:
    #         break
    #     sleep(1)

def writeSubprocessLoop():
    global readAll
    while True:
    #     # print("subprocess loop disabled.")
    #     # print(currentThread)
    #     # for p in processes:
    #     #     print(p.stdout.read())
    #     #working
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
            sleep(3)

def remove_Holder(key):
    # print("holder in remove_Holder: ")
    # print(API2.holder)
    # print(key)
    # print(holder)
    #newHolder = list(filter(lambda x : x != key, holder))
    #print(newHolder)
    # print("###")
    # print(holder[0][0])
    # print(type(holder[0][0]))
    # print(key)
    # print(type(key))
    # print("###")
    indices = [i for i, v in enumerate(API2.holder) if str(v[0]) == str(key)]
    for i in indices:
        print(API2.holder[i][1])
        API2.holder[i][1].terminate()
    # print(indices)

    # for i in indices:
    #    holder.remove(i)
    API2.holder=[holder for holder in API2.holder if holder[0] != key]
    #holder = newHolder

# def queueLoop():
#     while True:
#             event = result_queue.get()
#             if event is None:
#                 break
#             if event.startswith('update'):
#                 print("update triggered")#OnUpdate()
#             elif event.startswith('kill'):
#                 print("kill triggered")
#                 key = event.split(" ",1)[1]
#                 # print(key)
#                 remove_Holder(key)


def killLoop():
    # global currentThread
    # currentThread = None
    while True:
        print(API2.holder)
        for h in API2.holder:
            key = h[0]
            print(key)
            # print(">> %s" % key)
            # print(r.get(key))
            if r.get(key) == None:
                h[1].terminate()
                API2.holder=[holder for holder in API2.holder if holder[0] != key]
            # if key not in r.get("addr:*"):
            #     print(">> %s not in redis" % key)
            #     print("something has to happen.")
                # holder=[holder for holder in holder if holder[0] != key]

        # for key in r.scan_iter("addr:*"):
        #     # print(r.get(key))
        #     #print(r.get(key))
        #     # key   r.get(key)
        #     #print(key)
        #     #print(type(key))
        #     #print(len(key))
        #     #if [item for item in holder if item[0] == key]:
        #     for h in holder:
        #         #print(h[0])
        #         #print(type(h[0]))
        #         #print(len(h[0]))
        #         if key.decode() == h[0]:
        #             #print("true")
        #             print("verschont!")
        #         else:
        #             print("kill!")
        #             h[1].terminate()
        #             h[2].close()
        #             print("killed" + h[0])
        #             holder.remove(h)
        #     # if [item for item in holder if key in item]:
        #         # print(item)
        #         # print("found...")
    
        ## CHANGE TO holder...
        # for p in processes:
        #     if not p.is_alive():
        #     #if p.poll() != None:
        #         # print(currentThread)
        #         # print("killing")
        #         if currentThread == p:
        #             currentThread = None
        #         processes.remove(p) 
                
        sleep(5)


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

# global cleanDead
# cleanDead = Thread(target=killLoop)
# cleanDead.daemon = True
# cleanDead.start()

# global q1
# q1 = Thread(target=queueLoop)
# q1.daemon = True
# q1.start()

global writeSub
writeSub = Thread(target=writeSubprocessLoop)
writeSub.daemon = True
writeSub.start()

global t
t = Thread(target=socketBinding2)
t.daemon = True
t.start()

global ws
ws = Thread(target=socketBinding3)
ws.daemon = True
ws.start()
# global tcp
# tcp = Thread(target=tcpList)
# t.daemon = True

API1(host, localhost, 9777).start()

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
            # print("currentThread:")
            # print(currentThread)
            # print("")
            # print("processes:")
            # for p in processes:
            #     print(p)#print(processes)
            #     try:
            #         # if p.poll() == None:
            #         if p.is_alive():
            #             print("\talive")
            #         else:
            #             print("\tdead")
            #     except:
            #         print("find another solution for poll()")
            # # print(str(len(clients)) + " clients")
            print(str(len(API2.holder)) + " connections")
            print(API2.holder)
            #print(str(len(processes)) + " processes")
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
        if i.split(' ', 2)[0] in ["w", "write", "a", "ans", "answer", "s", "send", "notify"]:
            # print(i.split(' ', 1)[1])
            # push.append(i.split(' ', 1)[1])
            try:
                if i.split(' ', 2)[1] == "all":
                    for h in API2.holder:
                        h[6].send("%s" % ('%s\n' % i.split(' ', 2)[2]))
                    # for p in processes:
                    #     # print(p)
                    #     p.stdin.write(('%s\n' % i.split(' ', 2)[2]).encode())
                    #     p.stdin.flush()
                elif i.split(' ', 2)[1].isdigit():
                    print("API2.holder")
                    print(API2.holder)
                    API2.holder[int(i.split(' ', 2)[1])][6].send("%s" % ('%s\n' % i.split(' ', 2)[2]))
                    # p = processes[int(i.split(' ', 2)[1])]
                    # print(p)
                    # p.stdin.write(('%s\n' % i.split(' ', 2)[2]).encode())
                    # p.stdin.flush()
                
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
        if i in ["holder"]:
            print(API2.holder)
        if i in ["redis"]:
            
            #print(push)
            # print(processes)
            #print(clients)
            #print(r.lrange("ips", 0, -1))
            for key in r.scan_iter("addr:*"):
                # delete the key
                print(str(key) + ' -> ' + str(r.get(key)))
            
            for key in r.scan_iter("<3:*"):
                # delete the key
                print(str(key) + ' -> ' + str(r.get(key)))
        # except:
        #    print("type help")
        if i in ["who", "users", "online"]:
            for key in r.scan_iter("isonline:*"):
                # delete the key
                print(str(key) + ' -> ' + str(r.get(key)))
        if i.split(' ', 2)[0] in ["remove"]:
            connection = API1.connect()
            cursor = connection.cursor()
            command = i.split(' ', 2)[1]
            if command == "permission":

                #sql = "select CONCAT('fiUser ', fiUser), permission.* from userPermission join permission on fiPermission = idPermission"
                sql = "select * from userPermission join permission on fiPermission = idPermission"
                cursor.execute(sql)
                result = cursor.fetchall()
                # print(cursor.description)
                for a in cursor.description:
                    print(a[0], end = ' ')
                print("")
                for r in result:
                    print(r)
                    try:
                        print(r["fiUser"])
                    except:
                        print("fail")

                print("which User you want to delete the Permission from?")
                fiUser = input()
                
                print("Which Permission you want to revoke? ")
                fiPermission = input()

                sql = "delete from userPermission where fiUser = %s and fiPermission = %s;"
                cursor.execute(sql, (fiUser, fiPermission))
                if cursor.rowcount > 0:
                    connection.commit()
                
            if command == "superuser":
                sql = "select * from superuser"
                cursor.execute(sql)
                result = cursor.fetchall()
                for r in result:
                    print(r)
                
                print("Which User you wish to affect?")
                user = input()

                sql = "delete from superuser where fiUser = %s;"
                cursor.execute(sql, (user,))
                if cursor.rowcount > 0:
                    connection.commit()
        if i.split(' ', 2)[0] in ["add"]:
            connection = API1.connect()
            cursor = connection.cursor()
            command = i.split(' ', 2)[1]
            if command == "permission":

                sql = "select * from user"
                cursor.execute(sql)
                result = cursor.fetchall()
                for r in result:
                    print(r)

                print("Which User you wish to affect?")
                user = input()

                sql = "select * from permission"
                cursor.execute(sql)
                result = cursor.fetchall()
                for r in result:
                    print(r)

                print("Which Permission you want to add?")
                permission = input()



                sql = "insert into userPermission values (%s, %s)"
                cursor.execute(sql, (user, permission))
                if cursor.rowcount > 0:
                    connection.commit()
            if command == "superuser":
                sql = "select * from user"
                cursor.execute(sql)
                result = cursor.fetchall()
                for r in result:
                    print(r)

                print("Which User you wish to affect?")
                user = input()

                sql = "insert into superuser values (%s);"
                cursor.execute(sql, (user,))
                if cursor.rowcount > 0:
                    connection.commit()
                
        if i.split(' ', 2)[0] in ["get"]:
            uid = i.split(' ', 2)[2]
            print(uid)
            connection = API1.connect()
            cursor = connection.cursor()
            sql = "select * from userpermission up"\
                  " JOIN permission p on up.fiPermission = p.idPermission WHERE fiUser = %s"
            cursor.execute(sql, (uid,))
            result = cursor.fetchall()
            for r in result:
                print(r)
            # print(id)

            # check userPermissions
            # sql = "select fiUser from userPermission WHERE fiUser = %s AND requestMethod = %s AND requestEndpoint = %s"
            # cursor.execute(sql, (uid, requestMethod, requestPath))
            
            # check bundlePermissions
            # sql = "select fiUser from bundlePermission WHERE fiUser = %s AND requestMethod = %s AND requestEndpoint = %s"
            # cursor.execute(sql, (uid, requestMethod, requestPath))

            # check defaultPermissions
            # sql = "select * from defaultPermission WHERE fiPermission = %s"
            # cursor.execute(sql, (id,))
            # cursor.fetchall()
    except Exception as e:
        print(e)


# #cli
# i = None
# while i not in ["quit", "exit", "bye", "q", "s"]:
#     # try:
#     try:
#         i = input('> ')
#         # print(f'you printed {i}')
#         if i in ["whoami", "whereami", "who"]:
#             print("mainprocess")
#         # if i in ["a"]:
#         #     currentThread=processes[0]
#         # if i in ["b"]:
#         #     currentThread=processes[1]
#         if i in ["c"]:
#             currentThread = None
#             print(currentThread)
        
#         if i in ["proc", "p", "pr"]:
#             # print(processes[len(processes)-1].communicate()[0])
#             print("currentThread:")
#             print(currentThread)
#             print("")
#             print("processes:")
#             for p in processes:
#                 print(p)#print(processes)
#                 try:
#                     # if p.poll() == None:
#                     if p.is_alive():
#                         print("\talive")
#                     else:
#                         print("\tdead")
#                 except:
#                     print("find another solution for poll()")
#             # print(str(len(clients)) + " clients")
#             print(str(len(holder)) + " connections")
#             print(holder)
#             #print(str(len(processes)) + " processes")
#             # import fcntl
#             # import select
#             # import os
#             # p = processes[len(processes)-1]
#             # fcntl.fcntl(
#             #     p.stdout.fileno(),
#             #     fcntl.F_SETFL,
#             #     fcntl.fcntl(p.stdout.fileno(), fcntl.F_GETFL) | os.O_NONBLOCK,
#             # )
#             # while p.poll() == None:
#             #     readx = select.select([p.stdout.fileno()], [], [])[0]
#             #     if readx:
#             #         chunk = p.stdout.read()
#             #         print(chunk)
#         if i in ["ips", "ip"]:
#             print(r.lrange("ips", 0, -1))
#         if i in ["help", "h", "how", "?"]:
#             usage()
#         if i.split(' ', 1)[0] in ["r", "read"]:
#             try:
#                 # if i.split(' ', 1)[1] == "all":
#                 #     for p in processes:
#                 #         print(p)
#                 #         # # for line in p.stdout: 
#                 #         # #     print(">>> " + str(line.rstrip())) 
#                 #         # #     p.stdout.flush()
#                 #         # line = await asyncio.wait_for(p.stdout.readline(), 20)
#                 #         # if not line: # EOF
#                 #         #     break
#                 #         # else: 
#                 #         #     print(line) # while some criterium is satisfied
#                 #         # try:
#                 #         #     while True:
#                 #         #         print(p.stdout.readline())
#                 #         # except KeyboardInterrupt:
#                 #         #     pass
#                 #         # def readThread(p):
#                 #         #     try:
#                 #         #         # print(p)
#                 #         #         # from time import sleep
#                 #         #         # for number in range(1,20):
#                 #         #         #     b.stdout.flush()
#                 #         #         #      
#                 #         #         #     print(p.stdout.readline())
#                 #         #         nbsr = NBSR(p.stdout)
#                 #         #         sleep(1)
#                 #         #         while True:
#                 #         #             output = nbsr.readline(0.1)
#                 #         #             # 0.1 secs to let the shell output the result
#                 #         #             if not output:
#                 #         #                 print('[No more data]')
#                 #         #                 t2._stop()
#                 #         #                 break
#                 #         #             print(output)
#                 #         #     except:
#                 #         #         pass
#                 #         #         print("readThread closed.")
#                 #         # t2 = Thread(target=readThread(p))
#                 #         # t2.start()
#                 #             # line = run_with_timeout(2, None, p.stdout.readline)
#                 #             # if line is None:
#                 #             #     break
#                 #             # else:
#                 #             #     print(line)
#                 # elif i.split(' ', 1)[1].isdigit():
#                 if i.split(' ', 1)[1].isdigit():
#                     # print(i.split(' ', 1)[1])
#                     # print(processes)
#                     readAll = False
#                     currentThread = processes[int(i.split(' ', 1)[1])]
#                     print(currentThread)
#                     # for line in processes[i.split(' ', 1)[1]].stdout: 
#                     #     print(">>> " + str(line.rstrip())) 
#                     #     p.stdout.flush()
#                 elif i.split(' ', 1)[1].upper() == "ALL":
#                     readAll = True
#                     currentThread = None
#                 else:#elif i.split(' ', 1)[1].upper() == "NONE":
#                     readAll = False
#                     currentThread = None
                
#                 # print(i.split(' ', 1)[0])
#                 # print(i.split(' ', 1)[1])
#             except Exception as e:
#                 print("r read [0...n/all]")
#                 print(str(e))
#         if i.split(' ', 2)[0] in ["w", "write", "ans", "answer"]:
#             # print(i.split(' ', 1)[1])
#             # push.append(i.split(' ', 1)[1])
#             try:
#                 if i.split(' ', 2)[1] == "all":
#                     for p in processes:
#                         # print(p)
#                         p.stdin.write(('%s\n' % i.split(' ', 2)[2]).encode())
#                         p.stdin.flush()
#                 elif i.split(' ', 2)[1].isdigit():
#                     p = processes[int(i.split(' ', 2)[1])]
#                     print(p)
#                     p.stdin.write(('%s\n' % i.split(' ', 2)[2]).encode())
#                     p.stdin.flush()
                
#                 # print(i.split(' ', 2)[0])
#                 # print(i.split(' ', 2)[1])
#                 # print(i.split(' ', 2)[2])
#             except Exception as e:
#                 print("a/ans/answer [0...n/all] message")
#                 print("a/ans/answer [0...n/all] help")
#                 print("a/ans/answer [0...n/all] a Test")
#                 print("a/ans/answer [0...n/all] ls")
#                 print(str(e))
#                 # # def thread(p):
#                 # # p.communicate(input=b'a Broadcast Push')[0]
#                 # # p.stdin.write(b'a test\n')
#                 # # p.communicate()
#                 # # read, write = os.pipe()
#                 # # os.write(write, b'a Broadcast Push')
#                 # # os.close(write)
#                 # # p.check_call(['a test2'], stdin=read)
                
#                 # # x = p.stdin
#                 # # p.stdin = subprocess.PIPE
#                 # # print(i.split(' ', 1)[1])
#                 # # p.stdin.write(i.split(' ', 1)[1].encode()) #expects a bytes type object
#                 # #p.stdin.write(b'brc') #expects a bytes type object
#                 # # p.check_output(["a ", "brc"], universal_newlines=True)
#                 # # p.stdin.close()
#                 # # p.stdin.write(b'a brc\n') # <<--- wokring!!
#                 # p.stdin.write(('a %s\n' % i.split(' ', 1)[1]).encode())
#                 # p.stdin.flush()
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # print(p.stdout.readline())
#                 # # p.stdout.flush()
#                 # # p.communicate(b'a brc\n')[0]
#                 # # print("after timeout.")
#                 # # sys.stdin.read()
#                 # # p.stdin.close()
#                 # # p.stdin = x
#                 # # def readThread():
#                 # #     print(p.stdout.readline())
#                 # #     t2._stop()
#                 # # t2 = Thread(target=readThread(p))
#                 # # t2.start()
#                 # # t2.join()
#         if i in ["holder"]:
#             print(holder)
#         if i in ["redis"]:
#             print("redis!")
#             #print(push)
#             # print(processes)
#             #print(clients)
#             #print(r.lrange("ips", 0, -1))
#             for key in r.scan_iter("addr:*"):
#                 # delete the key
#                 print(str(key) + ' -> ' + str(r.get(key)))
            
#             for key in r.scan_iter("<3:*"):
#                 # delete the key
#                 print(str(key) + ' -> ' + str(r.get(key)))
#         # except:
#         #    print("type help")
#     except Exception as e:
#         print(e)

t._stop()
s.shutdown()
s.close()
kill = True





    
# if __name__ == "__main__":
#     main()
