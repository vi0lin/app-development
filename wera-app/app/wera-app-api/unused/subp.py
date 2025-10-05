from time import sleep
import sys
i = 0
while True:
    try:
        print(sys.argv[1]+'->'+str(i), flush=True)
        #sys.stdout<<"Test"
        # sys.stdout<<"Test"
        # sys.stdout<<"4"
        # sys.stdout.flush()
        sleep(1)
        i = i+1
        #i++
    except Exception as e:
        print(e)
        sys.stdout.flush()