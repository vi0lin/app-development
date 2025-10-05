# Copyright 2019 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""An example of multiprocess concurrency with gRPC."""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from concurrent import futures
import contextlib
import datetime
import logging
import math
import multiprocessing
import time
import socket
import sys

import grpc

import api2_pb2_grpc
import api2_pb2

_LOGGER = logging.getLogger(__name__)

_ONE_DAY = datetime.timedelta(days=1)
_PROCESS_COUNT = multiprocessing.cpu_count()
_THREAD_CONCURRENCY = _PROCESS_COUNT


def is_prime(n):
    for i in range(2, int(math.ceil(math.sqrt(n)))):
        if n % i == 0:
            return False
    else:
        return True


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


def _wait_forever(server):
    try:
        while True:
            time.sleep(_ONE_DAY.total_seconds())
    except KeyboardInterrupt:
        server.stop(None)


def _run_server(bind_address):
    """Start a server in a subprocess."""
    _LOGGER.info('Starting new server.')
    options = (('grpc.so_reuseaddr', 1),) #('grpc.so_broadcast', 1),

    server = grpc.server(futures.ThreadPoolExecutor(
        max_workers=_THREAD_CONCURRENCY,),
                         options=options)
    api2_pb2_grpc.add_API2Servicer_to_server(API2Server(), server)
    server.add_insecure_port(bind_address)
    server.start()
    _wait_forever(server)


@contextlib.contextmanager
def _reserve_port():
    """Find and reserve a port for all subprocesses to use."""
    sock = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    if sock.getsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR) == 0:
        raise RuntimeError("Failed to set SO_REUSEADDR.")
    # sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    # if sock.getsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST) == 0:
    #     raise RuntimeError("Failed to set SO_BROADCAST.")
    # sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
    # if sock.getsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT) == 0:
    #     raise RuntimeError("Failed to set SO_REUSEPORT.")
    sock.bind(('', 0))
    try:
        yield sock.getsockname()[1]
    finally:
        sock.close()


def main():
    with _reserve_port() as port:
        port = 9001
        print(port)
        # variante 1
        # bind_address = 'localhost:{}'.format(port)
        # variante 2
        bind_address = '0.0.0.0:{}'.format(port)
        _LOGGER.info("Binding to '%s'", bind_address)
        sys.stdout.flush()
        workers = []
        for _ in range(_PROCESS_COUNT):
            # NOTE: It is imperative that the worker subprocesses be forked before
            # any gRPC servers start up. See
            # https://github.com/grpc/grpc/issues/16001 for more details.
            worker = multiprocessing.Process(target=_run_server,
                                             args=(bind_address,))
            worker.start()
            workers.append(worker)
        for worker in workers:
            worker.join()


if __name__ == '__main__':
    handler = logging.StreamHandler(sys.stdout)
    formatter = logging.Formatter('[PID %(process)d] %(message)s')
    handler.setFormatter(formatter)
    _LOGGER.addHandler(handler)
    _LOGGER.setLevel(logging.INFO)
    main()