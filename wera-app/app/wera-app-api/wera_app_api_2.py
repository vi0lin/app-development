# .\wera-app-api\Scripts\activate

### class version

global DEBUG
DEBUG = False

global killAll
killAll = False

import flask
from time import sleep
from threading import Thread
from concurrent import futures
import sys
import grpc
import api2_pb2_grpc
import api2_pb2
import threading
import api2Auth
import redis
#import multiprocessing
r = redis.Redis(host='127.0.0.1', port=6379, db=0)

class API2Server(api2_pb2_grpc.API2Servicer):
    # uid = None
    # decoded_token = None
    def __init__(self, push, addr, addrPort, processPort, identifier, child_conn):
        api2_pb2_grpc.API2Servicer.__init__(self)
        self.push = push
        self.addr = addr
        self.addrPort = addrPort
        self.processPort = processPort
        self.identifier = identifier
        self.child_conn = child_conn

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
            try:
                for request in request_iterator:
                    data = str(request).rstrip()
                    # print(request.idToken)
                    #print(flask.jsonify(data)["idToken"])
                    
                    #print(data)#, flush=True)
                    #code = "<41Lq4u6j8L1WIsUtBc05yWCOpnsWOjhCF0tCtjw2FOxwkHjkRx6YjWKkVH0THXbjHoszlcF07zK7kGqT4GCa6d2rcIyngJcu92v3i3SqEjedwWk615KZxcVA3gIsWYt4R4qk42GL7d8jZi1sAm1bAtnoJOmPOnV1iXwqwoxIptMgZmjL7MdypvuYOe4l93o5ykEFpcIOKdAnVGFlnO50jKd7qYIkXTbhHTmeWFdkvedpLswUFtbyuqa6auL8S30E3";
                    #if str(request).rstrip() != code:
                    if request.idToken != "":
                        #print("setting")
                        #print(identifier)
                        a = 0
                        r.set(self.identifier, '<3:'+request.idToken, ex=15)
                    #killAll=True
                    # sys.stdout.flush()
                    ####r.set('addr:'+str(addr)+':'+str(addrPort), str(processPort), ex=5)
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
            except Exception as e:
                print("Exception raised...")
                # print(str(e))
                # killAll = True
                # cliThread.process.stdin.write('%s\n' % "exit")
                # cliThread.process.stdin.flush()
                # cliThread._stop()
                # print(self.identifier)
                self.child_conn.send("killbill "+self.identifier)
                # print("removing %s" % self.identifier)
                r.delete(self.identifier)
                server.stop(1).wait()
        t = Thread(target=parse_request)
        # t.daemon = True
        t.start()

        #for i in range(5):
        #    yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %d - client#%s" % (i, self.clientCount))
        # import time;
        # time.sleep(10)
        # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t10", self.clientCount))
        # time.sleep(10)
        # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t10", self.clientCount))
        # time.sleep(300)
        # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t300", self.clientCount))
        # time.sleep(3000)
        # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t3000", self.clientCount))

        
        while not killAll:
            # print("waiting for pushes.")
            for p in self.push:
                print("found pushes>>")
                yield api2_pb2.PushResponse(idUser=self.uid, message=p)
                self.push.remove(p)
            sleep(3)
            # print("killAll: " + str(killAll))

        # import sched, time
        # s = sched.scheduler(time.time, time.sleep)
        # def do_something(sc): 
        #     for p in push:
        #         print("found pushes...")
        #         yield api2_pb2.PushResponse(idUser=self.uid, message=p)
        #         push.remove(p)
        #         s.enter(60, 1, do_something, (sc,))
        # s.enter(60, 1, do_something, (s,))
        # s.run()
        
        t.join()

#class API2Multiprocess(threading.Thread):
class API2Multiprocess(threading.Thread):
    def __init__(self, processPort, addr, addrPort, holder, child_conn, identifier):
        threading.Thread.__init__(self)
        if DEBUG:
            self.processPort = "9000"
            self.addr = "0.0.0.0"
            self.addrPort = 0 
            self.address = "0.0.0.0"
        else:
            self.processPort = str(processPort)
            self.addr = str(addr)
            self.addrPort = addrPort
            self.address = 'localhost'
        import redis
        self.r = redis.Redis(host='127.0.0.1', port=6379, db=0)
        self.push = []
        self.holder = holder
        self.child_conn = child_conn
        self.identifier = identifier
        


    def usage(self):
        print("[][][] WELCOME TO SUBPROCESS")
        print("h help how ?          prints help")
        print("a ans answer [message]answer ")
        print("q quit exit bye s     quit")
        print("ls                    list all pushes")

    def cli(self):
        global killAll
        # import signal
        # signal.signal(signal.SIGINT, signal_handler)

        #cli
        i = None
        while i not in ["quit", "exit", "bye", "q", "s"]:
            # print("killAll " + str(killAll))
            if killAll:
                break
            try:
                i = input('>> ')
                # print(f'you printed {i}')
                if i in ["help", "h", "how", "?"]:
                    self.usage()
                if i in ["whoami", "whereami", "w", "who"]:
                    print("subprocess")
                if i.split(' ', 1)[0] in ["a", "ans", "answer"]:
                    try:
                        # print(i.split(' ', 1)[1])
                        # r.set('addr:'+str(addr)+':'+str(addrPort), str(processPort), ex=5)
                        print("append push")
                        self.push.append(i.split(' ', 1)[1])
                    except Exception as e:
                        print(str(e))
                if i in ["ls"]:
                    print(self.push)
                if i in ["kill"]:
                    server.stop(1).wait()
                    killAll = True
                    # cliThread._stop()
                    # quit()
                    # sys.exit(1)
            except Exception as e:
                # print("type help")
                print(e)
        # cliThread._stop()

    def run(self):
        # print("subprocess main :")

        ####r.set('addr:'+str(addr)+':'+str(addrPort), str(processPort), ex=5)
        # variante 1
        global server
        server = grpc.server(futures.ThreadPoolExecutor())
        
        # var cacert = File.ReadAllText(@"ca.crt");
        # var servercert = File.ReadAllText(@"server.crt");
        # var serverkey = File.ReadAllText(@"server.key");
        # var keypair = new KeyCertificatePair(servercert, serverkey);
        # var sslCredentials = new SslServerCredentials(new List<KeyCertificatePair>() { keypair }, cacert, false);
        # 
        # var server = new Server
        # {
        #     Services = { GrpcTest.BindService(new GrpcTestImpl(writeToDisk)) },
        #     Ports = { new ServerPort("0.0.0.0", 555, sslCredentials) }
        # };
        # server.Start();

        # with open('ssl/server.key', 'rb') as f:
        #     private_key = f.read()
        # with open('ssl/server.crt', 'rb') as f:
        #     certificate_chain = f.read()
        with open('key.pem', 'rb') as f:
            private_key = f.read()
        with open('cert.pem', 'rb') as f:
            certificate_chain = f.read()
        server_credentials = grpc.ssl_server_credentials( ( (private_key, certificate_chain), ) )
        

        x = API2Server(self.push, self.addr, self.addrPort, self.processPort, self.identifier, self.child_conn)
        x.addComment(self.addr)
        api2_pb2_grpc.add_API2Servicer_to_server(x, server)
        

        #server.add_insecure_port(address+':'+port)
        server.add_secure_port(self.address+':'+self.processPort, server_credentials)
        # server.add_secure_port('[::]:' + processPort, server_credentials)
        server.start()
        

    
        # selbstZerstoerung = Thread(target=killSelf)
        # selbstZerstoerung.start()
        
        # > global cliThread
        # > cliThread = Thread(target=self.cli)
        # > cliThread.start()
        

        # selbstZerstoerung.join()
        # cliThread.join()


        # while True:
            # print("a")
            # sleep(1)
        # print("waiting for termination")

        # print(self.getIdentifier())
        
        # global killAll
        # while not killAll:
        while True:
            timeout = self.child_conn.poll(2)
            #print(timeout)
            if timeout:
                event = self.child_conn.recv()
                print(event)
                if event.startswith('a '):
                    print(event.split(" ",1)[1])
                    message = event.split(" ",1)[1]
                    self.push.append(message)
                """if event.startswith('kill '):
                    killAll = True
                    server.stop(1).wait()
                    self.child_conn.send("killbill "+self.identifier) """
            # kill self if not found in redis
            
            ## redis check ausgestellt.
            # # # # # # #if r.get(self.getIdentifier()) != None:
            # # # # # # #    # still alive. instance found inside of redis.
            # # # # # # #    a = 0
            # # # # # # #    # self.child_conn.send("update")
            # # # # # # #    # print(r.get(self.getIdentifier()))
            # # # # # # #else:
            # # # # # # #    killAll = True
            # # # # # # #    server.stop(1).wait()
            # # # # # # #    self.child_conn.send("kill "+self.getIdentifier())
            # # # # # # #    # break
            # print(self.holder)
            

        server.wait_for_termination()
        # cliThread.join()


'''

### global version


from threading import Thread
from concurrent import futures
import sys
import grpc
import api2_pb2_grpc
import api2_pb2
# from queue import Queue, Empty
from time import sleep

global DEBUG
DEBUG = False

global processPort
global addr
global addrPort

if DEBUG:
    processPort = "9000"
    addr = "0.0.0.0"
    addrPort = 0 
    address = "0.0.0.0"
else:
    processPort = sys.argv[1]
    addr = sys.argv[2]
    addrPort = sys.argv[3]
    address = 'localhost'
    #elif not DEBUG:
# else:
#     processPort = "9000"
#     addr = "localhost"
#     addrPort = 0 
#     address = "localhost"

import sys
# global sys.stdout = open('device.log', 'w')
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
r = redis.Redis(host='127.0.0.1', port=6379, db=0)
# print("client started")

global killAll
killAll = False

#  SERVER_ID = 1

# q = Queue()
# my_queues = [];
# my_threads = [];
# clients = [];
# messages = [];
# messages.append("message1")
# messages.append("message2")
# messages.append("message3")
# messages.append("message4")
# RLock https://github.com/grpc/grpc/issues/19119

global push
push = []

class API2Server(api2_pb2_grpc.API2Servicer):
    # uid = None
    # decoded_token = None

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
            try:
                for request in request_iterator:
                    print(str(request).rstrip())#, flush=True)
                    # sys.stdout.flush()
                    ####r.set('addr:'+str(addr)+':'+str(addrPort), str(processPort), ex=5)
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
            except Exception as e:
                print("Exception raised...")
                print(str(e))
                killAll = True
                # cliThread.process.stdin.write('%s\n' % "exit")
                # cliThread.process.stdin.flush()
                # cliThread._stop()
                server.stop(1).wait()
        t = Thread(target=parse_request)
        # t.daemon = True
        t.start()

        #for i in range(5):
        #    yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %d - client#%s" % (i, self.clientCount))
        # import time;
        # time.sleep(10)
        # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t10", self.clientCount))
        # time.sleep(10)
        # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t10", self.clientCount))
        # time.sleep(300)
        # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t300", self.clientCount))
        # time.sleep(3000)
        # yield api2_pb2.PushResponse(idUser="1", message="pushResponse= %s - client#%s" % ("t3000", self.clientCount))

        
        while not killAll:
            for p in push:
                print("found pushes...")
                yield api2_pb2.PushResponse(idUser=self.uid, message=p)
                push.remove(p)
            sleep(3)

        # import sched, time
        # s = sched.scheduler(time.time, time.sleep)
        # def do_something(sc): 
        #     for p in push:
        #         print("found pushes...")
        #         yield api2_pb2.PushResponse(idUser=self.uid, message=p)
        #         push.remove(p)
        #         s.enter(60, 1, do_something, (sc,))
        # s.enter(60, 1, do_something, (s,))
        # s.run()
        
        t.join()

def usage():
    print("[][][] WELCOME TO SUBPROCESS")
    print("h help how ?          prints help")
    print("a ans answer [message]answer ")
    print("q quit exit bye s     quit")
    print("ls                    list all pushes")

def cli():
    global killAll
    # import signal
    # signal.signal(signal.SIGINT, signal_handler)

    #cli
    i = None
    while i not in ["quit", "exit", "bye", "q", "s"]:
        # print("killAll " + str(killAll))
        if killAll:
            break
        try:
            i = input('>> ')
            # print(f'you printed {i}')
            if i in ["help", "h", "how", "?"]:
                usage()
            if i in ["whoami", "whereami", "w", "who"]:
                print("subprocess")
            if i.split(' ', 1)[0] in ["a", "ans", "answer"]:
                try:
                    # print(i.split(' ', 1)[1])
                    # r.set('addr:'+str(addr)+':'+str(addrPort), str(processPort), ex=5)
                    print("append push")
                    push.append(i.split(' ', 1)[1])
                except Exception as e:
                    print(str(e))
            if i in ["ls"]:
                print(push)
            if i in ["kill"]:
                server.stop(1).wait()
                killAll = True
                # cliThread._stop()
                # quit()
                # sys.exit(1)
        except Exception as e:
            # print("type help")
            print(e)
    cliThread._stop()

# i = 0

# def killSelf():
#     while True:
#         if not r.exists("addr:"+str(addr)+':'+str(addrPort)):
#             i=i+200
#             r.set('addr:'+str(addr)+':'+str(addrPort), str(i), ex=3)
#             #cliThread._stop()
#             print('sayonara.')
#             #quit()
#         sleep(10)
#         print('s')
#         sys.stdout.flush()

def main():

    # print("subprocess main :")

    ####r.set('addr:'+str(addr)+':'+str(addrPort), str(processPort), ex=5)
    # variante 1
    global server
    server = grpc.server(futures.ThreadPoolExecutor())
    
    # var cacert = File.ReadAllText(@"ca.crt");
    # var servercert = File.ReadAllText(@"server.crt");
    # var serverkey = File.ReadAllText(@"server.key");
    # var keypair = new KeyCertificatePair(servercert, serverkey);
    # var sslCredentials = new SslServerCredentials(new List<KeyCertificatePair>() { keypair }, cacert, false);
    # 
    # var server = new Server
    # {
    #     Services = { GrpcTest.BindService(new GrpcTestImpl(writeToDisk)) },
    #     Ports = { new ServerPort("0.0.0.0", 555, sslCredentials) }
    # };
    # server.Start();

    # with open('ssl/server.key', 'rb') as f:
    #     private_key = f.read()
    # with open('ssl/server.crt', 'rb') as f:
    #     certificate_chain = f.read()
    with open('key.pem', 'rb') as f:
        private_key = f.read()
    with open('cert.pem', 'rb') as f:
        certificate_chain = f.read()
    server_credentials = grpc.ssl_server_credentials( ( (private_key, certificate_chain), ) )
    

    x = API2Server()
    x.addComment(addr)
    api2_pb2_grpc.add_API2Servicer_to_server(x, server)
    

    #server.add_insecure_port(address+':'+port)
    server.add_secure_port(address+':'+processPort, server_credentials)
    # server.add_secure_port('[::]:' + processPort, server_credentials)
    server.start()
    print("server started at "+ address+':'+processPort)

   
    # selbstZerstoerung = Thread(target=killSelf)
    # selbstZerstoerung.start()
    
    global cliThread
    cliThread = Thread(target=cli)
    cliThread.start()
    

    # selbstZerstoerung.join()
    # cliThread.join()


    # while True:
        # print("a")
        # sleep(1)
    # print("waiting for termination")
    server.wait_for_termination()
    cliThread.join()

if __name__ == '__main__':
    main()
'''