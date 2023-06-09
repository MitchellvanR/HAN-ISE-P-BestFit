import pyodbc
from faker import Faker
import time

driver = '{ODBC Driver 18 for SQL Server}'
server = '127.0.0.1'
database = 'ise_project_prototype'
username = 'sa'
password = 'ISE_project'
connection_string = f'DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password};TrustServerCertificate=yes'
conn = pyodbc.connect(connection_string)
cursor = conn.cursor()

fake = Faker()

def generate_fake_data():
    try:

        fake_count = int(input("Enter the number of fake reservations to generate: "))
        begin_time = time.time()

        for i in range(fake_count):
                member_id = fake.random_int(min=1, max=10)
                member = fake.name()
                title = fake.sentence(nb_words=1)
                date = fake.date_between(start_date='-1y', end_date='today')
                start_time = fake.time(pattern='%H:%M:%S', end_datetime=None)
                end_time = fake.time(pattern='%H:%M:%S', end_datetime=None)
                persons = fake.random_int(min=1, max=10)

                # Insert the fake data into the database
                sql = "INSERT INTO reservations (member_id, member, title, date, start_time, end_time, persons) VALUES (?, ?, ?, ?, ?, ?, ?)"
                val = (member_id, member, title, date, start_time, end_time, persons)
                cursor.execute(sql, val)

        conn.commit()

        end_time = time.time()
        time_diff = int((end_time - begin_time) * 1000)
        print("Finished inserting fake data into database in", time_diff, "ms")

        conn.close()

    except ValueError:
            print("Please enter a number!")
            generate_fake_data()
    except pyodbc.Error as e:
        print("Error connecting to database:", e)

generate_fake_data()

