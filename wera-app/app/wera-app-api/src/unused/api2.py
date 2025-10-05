from threading import Thread
from concurrent import futures

import grpc
import api2_pb2_grpc
import api2_pb2
from queue import Queue, Empty
from my_server_interceptor import MyServerInterceptor

address = '0.0.0.0:9001'
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
class API2Server(api2_pb2_grpc.API2Servicer):

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
        # watch config file seperately in new thread https://github.com/grpc/grpc/issues/19119
        # using queue.Queue https://stackoverflow.com/questions/1886090/return-value-from-thread
        
        params = ""

        def client(self, queue):
            # print(dir(context))
            # print(dir(context.peer))
            # print(context.peek())
            # print("pushStreamingMethod called by client...")
            clients.append("client")
            # clients.append(context.peek())
            print(clients)
            # Open a sub thread to receive data
            def parse_request():
                for request in request_iterator:
                    # print("recv from idToken(%s) message(%s)" % (request.idToken, request.message))
                    # print("idToken(%s)" % request.idToken)
                    print("request" + request.idToken[:10])
                    # yield api2_pb2.PushResponse(idUser="1", message="request added")
                    messages.append(request.idToken[:4])
            t = Thread(target=parse_request)
            t.start()

            # for i in range(5):
            #     yield api2_pb2.PushResponse(idUser="1", message=("message(%s)" % i))
            # yield api2_pb2.PushResponse(idUser=1, message="quit")
            while True:
                import time
                while len(messages) > 0:
                    # yield api2_pb2.PushResponse(idUser="1", message=messages.pop())
                    queue.put(api2_pb2.PushResponse(idUser="1", message=messages.pop()))
                # print(clients)
                time.sleep(3)
            t.join()
            # what is join https://stackoverflow.com/questions/15085348/what-is-the-use-of-join-in-python-threading

        t = Thread(target=client, name="client", args=[params, q],)
        t.deamon = True
        t.start()
        my_threads.append(t)
        my_queues.append(q)
        # for t in my_threads:
        # my_threads.append(t)
        
        # yield item from a thread https://stackoverflow.com/questions/6324318/yield-item-from-a-thread
        while True: 
            try:
                # variant 1
                for que in my_queues:
                    answer = que.get(True, 1)
                    for t in my_threads:
                        yield answer
                # variante 2 (die pakete sind geteilt.)
                # yield q.get(True, 1)
            except Empty:
                # break
                print("no messages")

        t.join()



def main():
    def pushThread():
        import time
        from datetime import datetime
        while(True):
            zeitpunkt = datetime.now().strftime("%H:%M:%S")
            print("pushing message " + zeitpunkt)
            messages.append('timebased push ' + zeitpunkt)
            time.sleep(4)
    t = Thread(target=pushThread)
    t.start()

    #server = grpc.server(
    #    futures.ThreadPoolExecutor(max_workers=1000),
    #    options=(('grpc.max_send_message_length', 1000 * 1024 * 1024,), ('grpc.max_receive_message_length', 1000 * 1024 * 1024,),),
    #    interceptors=(MyServerInterceptor())
    #)


    # variante 1
    # server = grpc.server(futures.ThreadPoolExecutor())
    # variante 2
    #server = grpc.server(futures.ThreadPoolExecutor(max_workers=1000))
    # variante 3
    server = grpc.server(
        futures.ThreadPoolExecutor(max_workers=10),
        options=(('grpc.max_send_message_length', 1000 * 1024 * 1024,), ('grpc.max_receive_message_length', 1000 * 1024 * 1024,),),
        interceptors=MyServerInterceptor
    )
    # use intercept_service method to recieve infos.
    
    api2_pb2_grpc.add_API2Servicer_to_server(API2Server(), server)

    server.add_insecure_port(address)
    print("------------------start Python GRPC server")
    server.start()
    server.wait_for_termination()
    t.join()

if __name__ == '__main__':
    main()