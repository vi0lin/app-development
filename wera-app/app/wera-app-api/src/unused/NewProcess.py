from threading import Thread
from concurrent import futures
import sys
import grpc
import api2_pb2_grpc
import api2_pb2
from queue import Queue, Empty
from time import sleep

import sys

# class Logger(object):
#     def __init__(self, filename="Default.log"):
#         self.terminal = sys.stdout
#         self.log = open(filename, "a")

#     def write(self, message):
#         self.terminal.write(message)
#         self.log.write(message)

# sys.stdout = Logger("logfile")
#sys.stdout = open('~/src/log/logfile', 'w')

#from contextlib import redirect_stdout

#with open('logfile', 'w') as f:
#    with redirect_stdout(f):
#        print('it now prints to `help.text`')

import api2Auth
import redis

class API2Server(api2_pb2_grpc.API2Servicer):

        uid = None
        decoded_token = None

        def addComment(self, clientCount):
            self.clientCount = clientCount

        def bidirectionalStream(self, request_iterator, context):
            # print(context.peek())
            print("BidirectionalStreamingMethod called by client...")

            # Open a sub thread to receive data
            def parse_request():
                for request in request_iterator:
                    print("recv from requestData(%s)" % (request.request_data))

            t = Thread(target=parse_request)
            t.start()

            for i in range(5):
                yield api2_pb2.Response(response_data=("send by Python server, message= %d" % i))
            t.join()


        def pushStream(self, request_iterator, context):
            # print(context.peek())
            print("pushStream called by client...")
            # Open a sub thread to receive data
            def parse_request():
                for request in request_iterator:
                    print(request)
                    
                    #idToken.append(request.idToken)
                    # print(request)
                    # print(request.idToken)
                    # idToken = request.idToken
                    
                    if(request.idToken != ""):
                        a, b = api2Auth.isAuthorized(request.idToken)
                        self.uid = a
                        self.decoded_token = b
                    # print(decoded_token)

                    # print(idToken[0])
                    # print(idToken2)
                    #print(request.message)

                    # print("recv from idToken(%s)" % (request.idToken))
                    # idToken = request.idToken
                    # print(idToken)

            t = Thread(target=parse_request)
            t.start()

            # for i in range(5):
            #     yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %d - client#%s" % (i, self.clientCount))
            # import time;
            # time.sleep(10)
            # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t10", self.clientCount))
            # time.sleep(10)
            # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t10", self.clientCount))
            # time.sleep(300)
            # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t300", self.clientCount))
            # time.sleep(3000)
            # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t3000", self.clientCount))

            from time import sleep
            while True:
                for p in push:
                    print("found pushes...")
                    yield api2_pb2.PushResponse(idUser=self.uid, message=p)
                    push.remove(p)
                sleep(3)

            t.join()

class NewProcess:

    def __init__(self, processPort, addr, addrPort):
        self.processPort = sys.argv[1]
        self.addr = sys.argv[2]
        self.addrPort = sys.argv[3]
        self.push = []

        self.r = redis.Redis(host='127.0.0.1', port=6379, db=0)
        print("client started")


        self.address = '127.0.0.1'
        self.SERVER_ID = 1

        self.q = Queue()
        self.my_queues = [];
        self.my_threads = [];
        self.clients = [];
    # messages = [];
    # messages.append("message1")
    # messages.append("message2")
    # messages.append("message3")
    # messages.append("message4")
    # RLock https://github.com/grpc/grpc/issues/19119

    

    
    def usage(self):
        print("[][][] WELCOME TO SERVER ")
        print("h help how ?          prints help")
        print("a ans answer [message]answer ")
        print("q quit exit bye s     quit")
        print("ls                    list all pushes")

    def cli(self):
        # import signal
        # signal.signal(signal.SIGINT, signal_handler)

        #cli
        i = None
        while i not in ["quit", "exit", "bye", "q", "s"]:
            try:
                i = input('>> ')
                # print(f'you printed {i}')
                if i in ["help", "h", "how", "?"]:
                    self.usage()
                if i.split(' ', 1)[0] in ["a", "ans", "answer"]:
                    # print(i.split(' ', 1)[1])
                    self.r.set('addr:'+str(self.addr)+':'+str(self.addrPort), str(self.processPort), ex=5)
                    self.push.append(i.split(' ', 1)[1])
                if i in ["ls"]:
                    print(self.push)
            except:
                print("type help")
        cliThread._stop()

    def killSelf(self):
        while True:
            if not self.r.exists("addr:"+str(self.addr)+':'+str(self.addrPort)):
                i=i+200
                self.r.set('addr:'+str(self.addr)+':'+str(self.addrPort), str(i), ex=3)
                #cliThread._stop()
                print('sayonara.')
                #quit()
            sleep(10)
            print('s')

    def start(self):
        print("subprocess main :")


        r.set('addr:'+str(self.addr)+':'+str(self.addrPort), str(self.processPort), ex=5)
        # variante 1
        server = grpc.server(futures.ThreadPoolExecutor())
        
        with open('key.pem', 'rb') as f:
            private_key = f.read()
        with open('chain.pem', 'rb') as f:
            certificate_chain = f.read()
        server_credentials = grpc.ssl_server_credentials( ( (private_key, certificate_chain), ) )
        

        x = API2Server()
        x.addComment(self.addr)
        api2_pb2_grpc.add_API2Servicer_to_server(x, server)
        

        #server.add_insecure_port(address+':'+port)
        print("server started at "+ self.address+':'+self.processPort)
        server.add_secure_port(self.address+':'+self.processPort, server_credentials)
        server.start()
        print("server started at "+ self.address+':'+self.processPort)

    
        selbstZerstoerung = Thread(target=self.killSelf)
        selbstZerstoerung.start()
        
        global cliThread
        cliThread = Thread(target=self.cli)
        cliThread.start()
        

        selbstZerstoerung.join()
        cliThread.join()




        server.wait_for_termination()