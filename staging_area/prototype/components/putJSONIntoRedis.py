import json
import redis
import pandas as pd

try:
    redis_conn = redis.Redis(host='localhost', port=6379)
    data = json.loads(open('reservations.json').read())
    redis_conn.set('reservations', json.dumps(data))
except ValueError as e:
    print("Error converting data to JSON:", e)
except redis.RedisError as e:
    print("Error inserting data into Redis:", e)