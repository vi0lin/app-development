from time import sleep
from subprocess import *
import subprocess
import sys

# import asyncio

# async def run(cmd):
#     proc = await asyncio.create_subprocess_shell(
#         cmd,
#         stdout=asyncio.subprocess.PIPE,
#         stderr=asyncio.subprocess.PIPE)

#     stdout, stderr = await proc.communicate()

#     print(f'[{cmd!r} exited with {proc.returncode}]')
#     if stdout:
#         print(f'[stdout]\n{stdout.decode()}')
#     if stderr:
#         print(f'[stderr]\n{stderr.decode()}')

# asyncio.run(run('subp.py'))

import threading
# class ProcThread(threading.Thread):
#     def run(self):
#         # while True:
#         #     print 'first'
#         # global p1
#         self.p = subprocess.Popen([sys.executable,
#             "subp.py",
#             str("A")],
#             stdin=subprocess.PIPE,
#             stdout=subprocess.PIPE,
#             stderr=sys.stdout,
#             shell=True)
#         # while True:
#         #     print("A")
#         #     sleep(1)

# class ProcThread2(threading.Thread):
#     # def __init__(self, p):
#     #     self.p = p
#     def run(self):
#         # global p2
#         self.p = subprocess.Popen([sys.executable,
#             "subp.py",
#             str("B")],
#             stdin=subprocess.PIPE,
#             stdout=subprocess.PIPE,
#             stderr=sys.stdout,
#             shell=True)
#         # while True:
#         #     print("B")
#         #     sleep(1)

global recievingInput
recievingInput = False

# import daemon
# global p1
# with daemon.DaemonContext():
p1 = subprocess.Popen(['stdbuf', '--output=L', "python3", "-u",
    "subp.py",
    str("A")],
    bufsize=1, stdout=PIPE, stderr=STDOUT, close_fds=True
    # stdin=subprocess.PIPE,
    # stdout=subprocess.PIPE,
    # stderr=sys.stdout,
    # shell=True,
    )
# p1.stdout.close()

# global p2
# with daemon.DaemonContext():
p2 = subprocess.Popen(['stdbuf', '--output=L', "python3", "-u",
    "subp.py",
    str("B")],
    bufsize=1, stdout=PIPE, stderr=STDOUT, close_fds=True
    # stdin=subprocess.PIPE,
    # stdout=subprocess.PIPE,
    # stderr=sys.stdout,
    # shell=True,
    )
# p2.stdout.close()

# p1 = ProcThread()
# p1.daemon = True
# p1.start()

# p2 = ProcThread2()
# p2.daemon = True
# p2.start()


global currentThread
currentThread = None
        
from threading import Thread


def loop():
    while True:
        # if currentThread:
        #     print(currentThread.stdout.read())
        # else:
        #     sleep(1)
        # print(".")
        # print("Test")
        # if currentThread:
            # print("A")
            # sleep(1)
            # for stdout_line in iter(currentThread.stdout.readline, ""):
            #     print(stdout_line)
                # yield stdout_line
            # currentThread.stdout.close()
        # else:
        #     sleep(1)
        if currentThread:
            buffer = currentThread
            if not recievingInput:
                # try:
                    # print("r")
                    # sleep(1)
                    # while True:
                # print("start reading line")
                line = currentThread.stdout.readline()
                # print("line was read")
                print(line.decode(), end='')
                if not line:
                    break
            # print(line)


                # for line in iter(currentThread.stdout.readline,''):
                #     # print(line.rstrip())
                #     print(line)
                #     if not currentThread:
                #         break
                # w = currentThread.stdout.readline()

                # while w:
                #     print("r")
                #     print(w)
                #     w = currentThread.stdout.readline()
            # except:
            #     print("cancled")
            # print(".")
            # buffer = currentThread
            #list_of_strings = [x.decode('utf-8').rstrip('\n') for x in iter(currentThread.stdout.readlines())]
            #print(list_of_strings)
            # sleep(1)
            # for ln in currentThread.stdout:
            #     print(ln) # kann man zwei zeilen runter tun. aber dann geht ie zeile leider verloren.
            # if buffer != currentThread:
            #     break
            # a,b = currentThread.communicate()
            # # print("+")
            # for line in a.splitlines():
            #     print(line)
            # # print(b)
            # b = b
            # line = currentThread.stdout.readline()
            # print(line)
            # if not line:
            #     break
            # # sys.stdout.write(line.decode())
            # print(line.decode(), end='', flush=True)
            # sleep(1)
            # yield line.decode()
        else:
            # print(".")
            sleep(1)

    # while True:
    #     #     #     line = proc.stdout.readline()
    #     #     #     if line != '':
    #     #     #         #the real code does filtering here
    #     #     #         print("test:", line.rstrip())
    #     #     #     else:
    #     #     #         break
    #     #         # print("loop")
    #         if currentThread:
    #     #         #     print(currentThread)
    #     #         #     # print(currentThread.stdout.read())
    #     #         #     # print(currentThread.stdout.readline())
    #     #         #     # print(currentThread.stdout)
    #             # for line in currentThread.stdout:
    #             #     print(line.rstrip())
    #     #         #     # for line in iter(currentThread.stdout.readline,''):
    #     #         #     #     # print(line.rstrip())
    #     #         #     #     print(line)
    #     #         #     #     if not currentThread:
    #     #         #     #         break
    #     #         #     #   Windows only =(
    #             line = currentThread.stdout.readline()
    #             if not line:
    #                 break
    #             print(line.decode(), end='')
    #     #         #     # print(line.rstrip())
    #         else:
    #             sleep(1)
    #     #         # elif not currentThread:
    #     #         #     print("closing")
    #     #         #     break
    #     #         # else:
    #     #         #     break
    #     #         # else:
    #     #         # for line in iter(p2.stdout.readline,''):
    #     #         #     print(line)
    #     #         #     sleep(1)
    #     #         # sleep(1)

global t
t = Thread(target=loop)
t.daemon = True
t.start()

# def signal_handler(sig, frame):
    # currentThread = None
    # print("EXIT")
    # quit()
    # p1.p.kill()
    # p2.p.kill()
    # t._stop()
    # print("signal_handler")
    # sys.exit(0)
    # subprocess.Popen.kill(p1)
    # subprocess.Popen.kill(p2)
    # sys.exit(0)
    # currentThread=None
    # p1.join()
    # p2.join()

# import signal
# signal.signal(signal.SIGINT, signal_handler)

while True:
    try:
    #cli
        i = None
        while i not in ["quit", "exit", "bye", "q", "s"]:
            i = input('> ')
            # sys.stdout = sys.__stdout__
            # if i in ["t"]:

            if i in ["c"]:
                print(currentThread)
            if i in ["a"]:
                currentThread=p1
                # sys.stdout = p1.stdout
                # p1.stdout = sys.stdout
                # p2.stdout = subprocess.PIPE
                # print("a")
            if i in ["b"]:
                # sys.stdout = p2.stdout
                currentThread=p2
                # p1.stdout = subprocess.PIPE
                # p2.stdout = sys.stdout
                # print("b")
            if i in ["x"]:
                # p1.stdout = subprocess.PIPE
                # p2.stdout = subprocess.PIPE
                currentThread=None
                sys.stdout = sys.__stdout__
        quit()
    except:
        break