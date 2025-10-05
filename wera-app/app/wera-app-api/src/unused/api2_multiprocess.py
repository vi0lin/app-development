from threading import Thread
from concurrent import futures

import sys
import grpc
import api2_pb2_grpc
import api2_pb2
from queue import Queue, Empty

import api2Auth

import redis
r = redis.Redis(host='127.0.0.1', port=6379, db=0)
print("client started")


address = '127.0.0.1'
SERVER_ID = 1

q = Queue()
my_queues = [];
my_threads = [];
clients = [];
messages = [];
messages.append("message1")
messages.append("message2")
messages.append("message3")
messages.append("message4")
# RLock https://github.com/grpc/grpc/issues/19119

push = []

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


def usage():
    print("[][][] WELCOME TO SUBPROCESS")
    print("h help how ?          prints help")
    print("a [message]           answer ")
    print("q quit exit bye s     quit")
    print("ls                    list all pushes")

def cli():
    # import signal
    # signal.signal(signal.SIGINT, signal_handler)

    #cli
    i = None
    while True: # i not in ["quit", "exit", "bye", "q", "s"]:
        try:
            i = input('>> ')
            # print(f'you printed {i}')
            if i in ["help", "h", "how", "?"]:
                usage()
            if i.split(' ', 1)[0] in ["a", "ans", "answer", "r", "res", "response"]:
                # print(i.split(' ', 1)[1])
                push.append(i.split(' ', 1)[1])
            if i in ["ls"]:
                print(push)
        except:
            print("type help")
    cliThread._stop()

def main():
    print("subprocess main :')")
    port = sys.argv[1] # <------------------------- eigenes portmapping muss her!!!
    clientNumber = sys.argv[2]
    # variante 1
    server = grpc.server(futures.ThreadPoolExecutor())
    
    x = API2Server()
    x.addComment(clientNumber)
    api2_pb2_grpc.add_API2Servicer_to_server(x, server)
    

    server.add_insecure_port(address+':'+port)
    server.start()
    print("server started at "+ address+':'+port)

    global cliThread
    cliThread = Thread(target=cli)
    cliThread.start()
    cliThread.join()

    server.wait_for_termination()

if __name__ == '__main__':
    main()
