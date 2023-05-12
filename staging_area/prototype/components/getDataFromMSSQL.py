import pandas as pd
import pyodbc

try:
    conn = pyodbc.connect('''DRIVER={SQL Server}; Server=127.0.0.1;
                        UID=ISE_PROJECT; PWD=ISE_PROJECT; DataBase=ise_project_prototype''')
except pyodbc.Error as e:
    print("Error connecting to database:", e)

sql_query = pd.read_sql_query('''select * from dbo.Members''', conn)

df = pd.DataFrame(sql_query)
df.to_csv (r'./output.csv', index = False)