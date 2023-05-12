import json
import pandas as pd
import pyodbc
import redis

driver = '{ODBC Driver 18 for SQL Server}'
server = '127.0.0.1'
database = 'ise_project_prototype'
username = 'sa'
password = 'ISE_project'


from sqlalchemy.engine import URL
connection_string = f'DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password};TrustServerCertificate=yes'
connection_url = URL.create("mssql+pyodbc", query={"odbc_connect": connection_string})

from sqlalchemy import create_engine
engine = create_engine(connection_url)

try:
    with engine.begin() as conn:
        print("Connected to database!")
        sql_query = pd.read_sql_query('''select * from dbo.Reservations''', conn)
    print("Data retrieved!")

    data = pd.DataFrame(sql_query)
    result = data.to_json(orient="records")
    print("Data converted to JSON!")

except pyodbc.Error as e:
    print("Error connecting to database:", e)
except pd.errors.DatabaseError as e:
    print("Error executing SQL query:", e)
except ValueError as e:
    print("Error converting data to JSON:", e)

data = json.dumps(result)
print("Data saved!")

try:
    redis_conn = redis.Redis(host='localhost', port=6379)
    redis_conn.set('reservations', data)
    print("Data inserted into Redis!")
except ValueError as e:
    print("Error converting data to JSON:", e)
except redis.RedisError as e:
    print("Error inserting data into Redis:", e)