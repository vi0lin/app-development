import asyncio
from threading import Thread
import socket               # Import socket module
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)         # Create a socket object
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
host = '0.0.0.0' # socket.gethostname() # Get local machine name
remote_host = '127.0.0.1'
port = 9000 # Reserve a port for your service.
print(host+':'+str(port))
print('Server started!')
print('Waiting for clients...')


import asyncio
import sys
from asyncio.subprocess import PIPE, STDOUT



kill = False


import redis
r = redis.Redis(host='127.0.0.1', port=6379, db=0)


clients = []
processes = []



import os
# from multiprocessing import Pool
import subprocess
from subprocess import Popen, PIPE, STDOUT
from subprocess import *
import sys
import threading
from nbstreamreader import NonBlockingStreamReader as NBSR
from time import sleep

def handle(buffer):
    return buffer

def transfer(p, clientSrc, clientPort, src, dst, direction):
    src_name = src.getsockname()
    src_address = src_name[0]
    src_port = src_name[1]
    dst_name = dst.getsockname()
    dst_address = dst_name[0]
    dst_port = dst_name[1]
    while True:
        try:
            buffer = src.recv(0x400)
            if len(buffer) == 0:
                print("[-] No data received! Breaking...")
                break
            # print "[+] %s:%d => %s:%d [%s]" % (src_address, src_port, dst_address, dst_port, repr(buffer))
            if direction:
                print("[+] %s:%d >|> %s:%d >>> %s:%d [%d]" % (clientSrc, clientPort, src_address, src_port, dst_address, dst_port, len(buffer)))
            else:
                print("[+] %s:%d <|< %s:%d <<< %s:%d [%d]" % (clientSrc, clientPort, dst_address, dst_port, src_address, src_port, len(buffer)))
            dst.send(handle(buffer))
        except OSError:
            # print("OSERROR!!" + e)
            #if p in processes:
            #    processes.remove(p)
            #    p.kill()
            pass
        except:
            pass
            # print("error.")
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
def cli():
    #cli
    i = None
    while i not in ["quit", "exit", "bye", "q", "s"]:
        # try:
        i = input('> ')
        # print(f'you printed {i}')
        if i in ["proc", "p", "pr"]:
            print(processes[len(processes)-1].communicate()[0])
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
                if i.split(' ', 1)[1] == "all":
                    for p in processes:
                        print(p)
                        # # for line in p.stdout: 
                        # #     print(">>> " + str(line.rstrip())) 
                        # #     p.stdout.flush()
                        # line = await asyncio.wait_for(p.stdout.readline(), 20)
                        # if not line: # EOF
                        #     break
                        # else: 
                        #     print(line) # while some criterium is satisfied
                        # try:
                        #     while True:
                        #         print(p.stdout.readline())
                        # except KeyboardInterrupt:
                        #     pass
                        # def readThread(p):
                        #     try:
                        #         # print(p)
                        #         # from time import sleep
                        #         # for number in range(1,20):
                        #         #     b.stdout.flush()
                        #         #      
                        #         #     print(p.stdout.readline())
                        #         nbsr = NBSR(p.stdout)
                        #         sleep(1)
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
                            # line = run_with_timeout(2, None, p.stdout.readline)
                            # if line is None:
                            #     break
                            # else:
                            #     print(line)
                elif i.split(' ', 1)[1].isdigit():
                    for line in processes[i.split(' ', 1)[1]].stdout: 
                        print(">>> " + str(line.rstrip())) 
                        p.stdout.flush()
                # print(i.split(' ', 1)[0])
                # print(i.split(' ', 1)[1])
            except:
                print("r read [0...n/all]")
        if i.split(' ', 2)[0] in ["a", "ans", "answer"]:
            # print(i.split(' ', 1)[1])
            # push.append(i.split(' ', 1)[1])
            try:
                if i.split(' ', 2)[1] == "all":
                    for p in processes:
                        print(p)
                        p.stdin.write(('%s\n' % i.split(' ', 2)[2]).encode())
                        p.stdin.flush()
                elif i.split(' ', 2)[1].isdigit():
                    p = processes[i.split(' ', 2)[1]]
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
        if i in ["ls"]:
            print(push)
            print(processes)
            print(clients)
            print(r.lrange("ips", 0, -1))
            for key in r.scan_iter("addr:*"):
                # delete the key
                print(str(key) + ' -> ' + str(r.get(key)))
        # except:
        #    print("type help")


    t._stop()
    s.shutdown()
    s.close()
    kill = True

global t
t = Thread(target=cli)
t.start()

s.bind((host, port))
s.listen(5)

from contextlib import closing

def find_free_port():
    with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as s:
        s.bind(('', 0))
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        return s.getsockname()[1]

while not kill:
    # for p in processes:                    'HAS NOT WORKED
    #     stdout, stderr = p.communicate()   'HAS NOT WORKED
    #     print(stdout)                      'HAS NOT WORKED
    c, addr = s.accept()
    # print(addr in r.lrange("ips", 0, -1))
    if addr not in clients:
        #clients.append(addr)
        #r.rpush("ips", *addr)
        
        processPort = find_free_port()#30000+(len(clients)) # r.llen("ips")
        
        r.set('addr:'+str(addr), str(processPort), ex=5)
        
        print(addr[0] + ':' + str(addr[1]) + ' -> ' + str(processPort))
        #print(str(len(clients))) # r.llen("ips")
        # if False:                                                                       # r.llen("ips")
        # p = subprocess.Popen([sys.executable,
        #     "api2_multiprocess - variant ssl in multiprocess.py",
        #     str(processPort),
        #     str(addr)],
        #     stdin=subprocess.PIPE,
        #     stdout=subprocess.PIPE,
        #     stderr=subprocess.PIPE,
        #     shell=False)#, creationflags=CREATE_NEW_CONSOLE)#, capture_output=True),# start_new_session=False, shell=False, #  stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        p = subprocess.Popen([sys.executable,
        "api2_multiprocess - variant ssl in multiprocess.py",
        str(processPort),
        str(addr)],
        stdin=PIPE,
        stdout=PIPE,
        stderr=PIPE)
        # else:
        #     p = subprocess.Popen([sys.executable, "api2_multiprocess.py", str(processPort), str(r.llen("ips"))], stdin=PIPE, stderr=PIPE, stdout=PIPE, shell=True)#, creationflags=CREATE_NEW_CONSOLE)#, capture_output=True),# start_new_session=False, shell=False, #  stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        processes.append(p)

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

        # try transfer
        remote_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        import ssl
        wrappedSocket = ssl.wrap_socket(remote_socket, ssl_version=ssl.PROTOCOL_TLSv1_2)
        
        print(remote_host)
        print(processPort)
        
        # remote_socket.connect((remote_host, processPort))
        print("[+] Tunnel connected! Tranfering data...")
        # threads = []
        send = threading.Thread(target=transfer, args=(p, addr[0], addr[1], wrappedSocket, c, False))
        recv = threading.Thread(target=transfer, args=(p, addr[0], addr[1], c, wrappedSocket, True))
        # threads.append(s)
        # threads.append(r)
        send.start()
        recv.start()

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


# if __name__ == "__main__":
#     main()
