import redis
import json
import pandas as pd

redis_conn = redis.Redis(host='localhost', port=6379, decode_responses=True)

def get_personal_roster():
    try:
        member_id = int(input("Enter an id to search for: "))
        res = json.loads(redis_conn.get("reservations"))
        df = pd.read_json(res)
        print("Data retrieved!")

        personalRoster = df[df["member_id"] == member_id]
        print("Data filtered!")

        personalRoster.to_csv('roster.csv', index=False)
        print("Data saved to roster.csv!")

    except ValueError:
        print("Please enter a number!")
        get_personal_roster()
    except redis.ConnectionError:
        print("Failed to connect to Redis")
    except TypeError as e:
        print("No reservations found in database!", e)


get_personal_roster()