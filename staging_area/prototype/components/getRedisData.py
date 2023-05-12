import redis
import json
import pandas as pd

redis_conn = redis.Redis(host='localhost', port=6379, decode_responses=True)


def get_redis_reservations():
    try:
        member_id = int(input("Enter an id to search for: "))

        res = json.loads(redis_conn.get("reservations"))

        pd.DataFrame([x for x in res if x['member_id'] == member_id]).to_csv('output.csv', index=False)

        print("Done and saved to output.csv!")

    except ValueError:
        print("Please enter a number!")
        get_redis_reservations()
    except redis.ConnectionError:
        print("Failed to connect to Redis")
    except TypeError:
        print("No reservations found in database!")


get_redis_reservations()
