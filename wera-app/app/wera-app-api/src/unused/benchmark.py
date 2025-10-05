import time

cycles = 10000000


def normal_print(value):
    value

def calculate(value):
    value = value + value 
    value = value + value 
    value = value + value 

options = {
        0: normal_print,
        1: calculate,
    }

def operate(select, value):
    options[select](value)

def func():
    i = 0
    j = 0
    while j < len(options):
        start_time = time.time()
        print(options[j])
        while i < cycles:
            operate(j, i)
            i=i+1
        print(time.time() - start_time)
        j=j+1

def funcGenerators():
    i = 0
    j = 0
    while j < len(options):
        start_time = time.time()
        print(options[j])
        while i < cycles:
            operate(j, i)
            i=i+1
        print(time.time() - start_time)
        j=j+1

def funcMultithreading():
    i = 0
    j = 0
    while j < len(options):
        start_time = time.time()
        print(options[j])
        while i < cycles:
            operate(j, i)
            i=i+1
        print(time.time() - start_time)
        j=j+1


def funcMultiprocessing():
    i = 0
    j = 0
    while j < len(options):
        start_time = time.time()
        print(options[j])
        while i < cycles:
            operate(j, i)
            i=i+1
        print(time.time() - start_time)
        j=j+1

func();

