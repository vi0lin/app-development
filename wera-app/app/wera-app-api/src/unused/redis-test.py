import redis
r = redis.Redis(host='127.0.0.1', port=6379, db=0)

r.rpush("ips", "HALLO")
r.rpush("ips", "HALLO")
r.lrange("ips", 0, -1)