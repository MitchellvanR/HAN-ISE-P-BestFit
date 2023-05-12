import json
import pandas as pd
import pyodbc

try:
    conn = pyodbc.connect('''DRIVER={SQL Server}; Server=127.0.0.1;
                        UID=ISE_PROJECT; PWD=ISE_PROJECT; DataBase=ise_project_prototype''')
except pyodbc.Error as e:
    print("Error connecting to database:", e)

try:
    sql_query = pd.read_sql_query('''select * from dbo.Reservations''', conn)
    data = pd.DataFrame(sql_query)
except pd.errors.DatabaseError as e:
    print("Error executing SQL query:", e)

try:
    result = data.to_json(orient="records")
except ValueError as e:
    print("Error converting data to JSON:", e)

json_output = json.dumps(result)

with open("reservations.json", "w") as outfile:
    outfile.write(json_output)
