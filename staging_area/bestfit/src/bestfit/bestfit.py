"""
This module contains al the functions
for the staging area of the BestFit Gym.
"""

import json
import time
import random
from datetime import date
from datetime import datetime
from datetime import timedelta
from dateutil.relativedelta import relativedelta
import redis
import pandas as pd
import pyodbc
import sqlalchemy
from sqlalchemy.sql import text
from faker import Faker


class BestFitCacher:
  """
  This class caches data from the BestFit Gym database
  """

  def __init__(self, server: str,
               database: str,
               username: str,
               password: str,
               redishost: str,
               redisport: int) -> None:
    """
    This function initializes the BestFitCacher class.

    :param server:
    :param database:
    :param username:
    :param password:
    :param redishost:
    :param redisport:
    """

    self.engine = sqlalchemy.create_engine(
      f"mssql+pyodbc://{username}:{password}@{server}:1433/{database}?"
      f"driver=ODBC+Driver+18+for+SQL+Server&TrustServerCertificate=yes"
    )
    self.engine.begin()

    self.redis_conn = redis.Redis(host=redishost, port=redisport,
                                  decode_responses=True)

  def cache_schedule(self) -> None:
    """
    This function caches the employee schedule found in MSSQL in Redis.

    :return:
    """

    try:
      df_emp_schedule = self.get_from_db("sproc_getEmployeeSchedules")

      df_emp_schedule["start_timestamp"] = \
        pd.to_datetime(df_emp_schedule["start_timestamp"]) \
          .dt.strftime("%Y-%m-%d %H:%M:%S.%f")
      df_emp_schedule["end_timestamp"] = \
        pd.to_datetime(df_emp_schedule["end_timestamp"]) \
          .dt.strftime("%Y-%m-%d %H:%M:%S.%f")

      json_emp_schedule = df_emp_schedule.to_json(orient="records")

      self.put_in_cache("schedule", json.dumps(json_emp_schedule))

    except pyodbc.Error as e:
      print("Error connecting to database:", e)
    except pd.errors.DatabaseError as e:
      print("Error executing SQL query:", e)
    except ValueError as e:
      print("Error converting data:", e)

  def cache_reservations(self) -> None:
    """
    This function caches the member reservations found in MSSQL in Redis.

    :return:
    """

    try:
      df_memb_reserv = self.get_from_db("sproc_viewMemberReservations")

      df_memb_reserv["start_timestamp"] = \
        pd.to_datetime(df_memb_reserv["start_timestamp"]) \
          .dt.strftime("%Y-%m-%d %H:%M:%S.%f")
      df_memb_reserv["end_timestamp"] = \
        pd.to_datetime(df_memb_reserv["end_timestamp"]) \
          .dt.strftime(
          "%Y-%m-%d %H:%M:%S.%f")
      json_memb_reserv = df_memb_reserv.to_json(orient="records")

      self.put_in_cache("reservations",
                        json.dumps(json_memb_reserv))

    except pyodbc.Error as e:
      print("Error connecting to database:", e)
    except pd.errors.DatabaseError as e:
      print("Error executing SQL query:", e)
    except ValueError as e:
      print("Error converting data:", e)

  def get_from_db(self, procedure: str) -> pd.DataFrame:
    """
    This function retrieves data from the BestFit Gym database.

    :param procedure:
    :return:
    """

    raw_data = None

    try:
      raw_data = pd.read_sql_query(f"""EXEC {procedure}""",
                                   self.engine.connect())
    except pyodbc.Error as e:
      print("Error connecting to database:", e)
    except pd.errors.DatabaseError as e:
      print("Error executing SQL query:", e)
    except sqlalchemy.exc.ResourceClosedError:
      return pd.DataFrame(columns=["employee_id", "class_name",
                                   "room_id",
                                   "start_timestamp",
                                   "end_timestamp"])

    return pd.DataFrame(raw_data)

  def put_in_cache(self, key: str, value: str) -> None:
    try:
      self.redis_conn.set(key, value)
    except redis.RedisError as e:
      print("Error inserting data into Redis:", e)


class BestFitRoster:
  """
  This class retrieves a roster of a member or an employee
  from a redis cache and saves it to a csv file.
  """

  def __init__(self, host: str, port: int) -> None:
    """
    This function initializes the BestFitRoster class.

    :param host:
    :param port:
    """

    self.redis_conn = redis.Redis(host=host, port=port, decode_responses=True)

  def get_employee_schedule(self, employee_id: str) -> None:
    """
    This function retrieves the schedule of an employee from Redis
    and saves it to a csv file.

    :param employee_id:
    :return:
    """

    try:
      schedule_df = pd.read_json(self.get_from_cache("schedule"))

      schedule_roster = schedule_df[schedule_df["employee_id"] == employee_id]
      schedule_roster = schedule_roster.drop(columns=["employee_id"], axis=1)

      schedule_roster.to_csv("schedule.csv", index=False)

    except ValueError:
      print("Please enter a valid value!")
    except redis.ConnectionError:
      print("Failed to connect to Redis")
    except TypeError:
      print("No records found!")

  def get_member_reservations(self, member_id: str) -> None:
    """
    This function retrieves the reservations of a member from Redis
    and saves it to a csv file.

    :param member_id:
    :return:
    """

    try:
      reserv_df = pd.read_json(self.get_from_cache("reservations"))

      reserv_roster = reserv_df[reserv_df["member_id"] == member_id]
      reserv_roster = reserv_roster.drop(columns=["member_id"], axis=1)

      reserv_roster.to_csv("reservations.csv", index=False)

    except ValueError:
      print("Please enter a valid value!")
    except redis.ConnectionError:
      print("Failed to connect to Redis")
    except TypeError:
      print("No records found!")

  def get_from_cache(self, key: str) -> str:
    """
    This function retrieves data from Redis.

    :param key:
    :return:
    """

    try:
      result = self.redis_conn.get(key)

      if result is not None:
        return json.loads(result)
      else:
        return "[]"
    except redis.ConnectionError:
      print("Failed to connect to Redis")


class BestFitGenerator:
  """
  This class generates data for the BestFit Gym database.
  """

  def __init__(self, server: str,
               database: str,
               username: str,
               password: str) -> None:
    """
    This function initializes the BestFitGenerator class.

    :param server:
    :param database:
    :param username:
    :param password:
    """

    self.engine = sqlalchemy.create_engine(
      f"mssql+pyodbc://{username}:{password}@{server}:1433/{database}?"
      f"driver=ODBC+Driver+18+for+SQL+Server&TrustServerCertificate=yes"
    )
    self.engine.begin()
    self.fake = Faker()

  def generate_test_data(self) -> None:
    """
    This function generates test data for the BestFit Gym database.

    :return:
    """

    try:
      employee_count = int(
        input(
          "Enter the number of employees to generate: "
        )
      )
      group_class_count_maximum = int(
        input(
          "Enter the maximum amount of group classes to "
          "generate per employee. A random number of group classes "
          "between 0 and the selected number will be generated: "
        )
      )
      fitness_room_schedule_count_maximum = int(
        input(
          "Enter the maximum amount of shifts to generate "
          "per employee. A random number of shifts between 0 and the "
          "selected number will be generated: "
        )
      )
      member_count = int(
        input(
          "Enter the number of members to generate: "
        )
      )

      begin_time = time.time()

      self.generate_employees(employee_count, group_class_count_maximum,
                              fitness_room_schedule_count_maximum)

      self.generate_members(member_count)

      end_time = time.time()
      time_diff = int((end_time - begin_time) * 1000)
      print("Finished inserting fake data into database in", time_diff, "ms")

    # except ValueError:
    #   print("Please enter a number!")
    #   self.generate_test_data()
    except pyodbc.Error as e:
      print("Error connecting to database:", e)

  def generate_random_timestamps(self, amount, occupied_timestamps=None):
    """
    This function generates a certain amount of random timestamps based on
    an optional list of occupied timestamps.

    :param amount:
    :param occupied_timestamps:

    :return:
    """

    if occupied_timestamps is None:
      occupied_timestamps = []

    initial_timestamp = self.fake.date_time_between_dates(
      datetime_start=datetime.now(),
      datetime_end=datetime.now() + timedelta(days=30)
    )
    self.fake.date_time_this_month()
    start_timestamps = [initial_timestamp]
    occupied_timestamps.append(initial_timestamp)

    # pylint: disable=unused-variable
    for i in range(amount - 1):
      unique_start_timestamp = False
      while not unique_start_timestamp:
        start_timestamp = self.fake.date_time_between_dates(
          datetime_start=datetime.now(),
          datetime_end=datetime.now() + timedelta(days=30)
        )

        for timestamp in occupied_timestamps:
          unique_start_timestamp = True
          if timestamp < start_timestamp + timedelta(hours=1) \
              and start_timestamp < timestamp + timedelta(hours=1):
            unique_start_timestamp = False
            break

      start_timestamps.append(start_timestamp)
      occupied_timestamps.append(start_timestamp)

    return start_timestamps

  def generate_group_classes(self, amount, employee_id, class_name,
                             start_timestamps):
    """
    This function generates a certain amount of group classes for a
    specific employee.

    :param amount:
    :param employee_id:
    :param class_name:
    :param start_timestamps:

    :return:
    """

    # pylint: disable=unused-variable
    for i in range(amount):
      with self.engine.connect() as conn:
        result = pd.read_sql_query("""SELECT room_id FROM Room
        WHERE functionality = 'GroupClass'""", conn)

      data = pd.DataFrame(result)
      group_class_rooms = data.values.tolist()

      room_id = random.choice(group_class_rooms)[0]
      start_timestamp = start_timestamps[i]
      end_timestamp = start_timestamps[i] + timedelta(hours=1)

      sql = text("""INSERT INTO GroupClass (class_name, room_id,
      start_timestamp, employee_id, end_timestamp)
        VALUES (:class_name, :room_id, :start_timestamp, :employee_id,
        :end_timestamp)""")
      val = ({"class_name": class_name, "room_id": room_id,
              "start_timestamp": start_timestamp,
              "employee_id": employee_id, "end_timestamp": end_timestamp})
      with self.engine.connect() as conn:
        conn.execute(sql, val)
        conn.commit()

  def generate_fitness_room_schedules(self, amount, employee_id,
                                      start_timestamps):
    """
    This function generates a certain amount of fitness room schedules
    for a specific employee.

    :param amount:
    :param employee_id:
    :param start_timestamps:

    :return:
    """

    for i in range(amount):
      with self.engine.connect() as conn:
        result = pd.read_sql_query("""SELECT room_id FROM Room
        WHERE functionality = 'Fitness'""", conn)

      data = pd.DataFrame(result)
      fitness_rooms = data.values.tolist()

      room_id = random.choice(fitness_rooms)[0]
      start_timestamp = start_timestamps[i]
      end_timestamp = start_timestamps[i] + timedelta(hours=1)

      sql = text(
        """INSERT INTO FitnessRoomSchedule (employee_id, room_id, 
        start_timestamp, end_timestamp) 
        VALUES (:employee_id, :room_id, :start_timestamp, 
        :end_timestamp)""")
      val = ({"employee_id": employee_id, "room_id": room_id,
              "start_timestamp": start_timestamp,
              "end_timestamp": end_timestamp})
      with self.engine.connect() as conn:
        conn.execute(sql, val)
        conn.commit()

  def generate_employees(self, employee_count,
                         group_class_count_maximum_per_employee,
                         fitness_room_schedule_count_maximum_per_employee):
    """
    This function generates a certain amount of employees along with
    a random amount of group classes and fitness room schedules which are
    both based on a given maximum.

    :param employee_count:
    :param group_class_count_maximum_per_employee:
    :param fitness_room_schedule_count_maximum_per_employee

    :return:
    """

    # pylint: disable=unused-variable
    for i in range(employee_count):
      employee_id = self.fake.uuid4()
      first_name = self.fake.first_name()
      last_name = self.fake.last_name()

      sql = text(
        """INSERT INTO Employee (employee_id, first_name, last_name) 
        VALUES (:employee_id, :first_name, :last_name)
        """
      )
      val = ({"employee_id": employee_id, "first_name": first_name,
              "last_name": last_name})
      with self.engine.connect() as conn:
        conn.execute(sql, val)
        conn.commit()

      sql = text(
        """
        INSERT INTO EmployeeRole (employee_id, role_name)
        VALUES (:employee_id, 'Employee')
        """
      )
      val = {"employee_id": employee_id}
      with self.engine.connect() as conn:
        conn.execute(sql, val)
        conn.commit()

      with self.engine.connect() as conn:
        result = pd.read_sql_query(
          """SELECT class_name FROM GroupClassType""",
          conn
        )

      data = pd.DataFrame(result)
      group_class_types = data.values.tolist()

      class_name = random.choice(group_class_types)[0]

      sql = text(
        """INSERT INTO EmployeeGroupClassType (employee_id, class_name) 
        VALUES (:employee_id, :class_name)"""
      )
      val = ({"employee_id": employee_id, "class_name": class_name})
      with self.engine.connect() as conn:
        conn.execute(sql, val)
        conn.commit()

      group_class_count = \
        random.randrange(0, group_class_count_maximum_per_employee + 1)

      group_class_start_timestamps = \
        self.generate_random_timestamps(group_class_count)

      self.generate_group_classes(group_class_count, employee_id, class_name,
                                  group_class_start_timestamps)

      fitness_room_schedule_count = \
        random.randrange(0,
                         fitness_room_schedule_count_maximum_per_employee + 1)

      fitness_room_schedule_start_timestamps = \
        self.generate_random_timestamps(fitness_room_schedule_count,
                                        group_class_start_timestamps)

      self. \
        generate_fitness_room_schedules(fitness_room_schedule_count,
                                        employee_id,
                                        fitness_room_schedule_start_timestamps)

  def generate_member_group_class(self, member_id):
    """
    This function generates a random amount of group class registrations
    for a given member.

    :param member_id:

    :return group_class_registration_start_timestamps:
    """

    with self.engine.connect() as conn:
      result = pd.read_sql_query(
        """SELECT class_name, room_id, start_timestamp FROM GroupClass""",
        conn
      )

    data = pd.DataFrame(result)
    group_class_registrations = \
      random.sample(data.values.tolist(),
                    random.randrange(0, len(data) + 1))

    group_class_registration_start_timestamps = []

    subscription_end = datetime.now() + timedelta(days=90)

    sql = text(
      """INSERT INTO Subscription (member_id, type, 
      start_date, end_date) 
      VALUES (:member_id, :subscription_type, :start_date, :end_date)""")
    val = ({"member_id": member_id, "subscription_type": "Adult monthly",
            "start_date": datetime.now(), "end_date": subscription_end})
    with self.engine.connect() as conn:
      conn.execute(sql, val)
      conn.commit()

    for group_class_registration in group_class_registrations:
      class_name = group_class_registration[0]
      room_id = group_class_registration[1]
      start_timestamp = group_class_registration[2]

      group_class_registration_start_timestamps.append(start_timestamp)

      sql = text(
        """
        IF NOT EXISTS (SELECT * FROM GroupClassTypeSubscriptionType
        WHERE class_name = :class_name AND type = :subscription_type)
        BEGIN
        INSERT INTO GroupClassTypeSubscriptionType (class_name, type) 
        VALUES (:class_name, :subscription_type)
        END
        """)
      val = ({"class_name": class_name, "subscription_type": "Adult monthly"})
      with self.engine.connect() as conn:
        conn.execute(sql, val)
        conn.commit()

      sql = text(
        """INSERT INTO MemberGroupClass (member_id, class_name, room_id, 
        start_timestamp) 
        VALUES (:member_id, :class_name, :room_id, :start_timestamp)""")
      val = ({"member_id": member_id, "class_name": class_name,
              "room_id": room_id, "start_timestamp": start_timestamp})
      with self.engine.connect() as conn:
        conn.execute(sql, val)
        conn.commit()

    return group_class_registration_start_timestamps

  def generate_machine_reservations(self, member_id, occupied_timestamps):
    """
    This function generates a random amount of machine reservations for a
    given member based on a list of occupied_timestamps.

    :param member_id:
    :param occupied_timestamps:

    :return machine_reservation_start_timestamps:
    """

    with self.engine.connect() as conn:
      result = pd.read_sql_query(
        """SELECT machine_id FROM Machine""",
        conn
      )

    data = pd.DataFrame(result)
    machines = \
      random.sample(data.values.tolist(),
                    random.randrange(0, len(data) + 1))

    machine_reservation_start_timestamps = \
      self.generate_random_timestamps(
        len(machines),
        occupied_timestamps
      )

    i = 0
    for machine in machines:
      machine_id = machine[0]
      start_timestamp = machine_reservation_start_timestamps[i]
      end_timestamp = (machine_reservation_start_timestamps[i] +
                       timedelta(hours=1))

      sql = text(
        """INSERT INTO MachineReservation (machine_id, member_id, 
        start_timestamp, end_timestamp) 
        VALUES (:machine_id, :member_id, :start_timestamp, 
        :end_timestamp)"""
      )
      val = ({"machine_id": machine_id, "member_id": member_id,
              "start_timestamp": start_timestamp,
              "end_timestamp": end_timestamp})
      with self.engine.connect() as conn:
        conn.execute(sql, val)
        conn.commit()
      i += 1
      return machine_reservation_start_timestamps

  def generate_room_reservations(self, member_id, occupied_timestamps):
    """
    This function generates a random amount of room reservations for a
    given member based on a list of occupied_timestamps.

    :param member_id:
    :param occupied_timestamps:

    :return:
    """

    with self.engine.connect() as conn:
      result = pd.read_sql_query(
        """SELECT room_id FROM Room WHERE functionality = 'Squash'""",
        conn
      )

    data = pd.DataFrame(result)
    squash_room_reservations = \
      random.sample(data.values.tolist(),
                    random.randrange(0, len(data) + 1))

    squash_room_reservation_start_timestamps = \
      self.generate_random_timestamps(
        len(squash_room_reservations),
        occupied_timestamps
      )

    i = 0
    for squash_room_reservation in squash_room_reservations:
      room_id = squash_room_reservation[0]
      start_timestamp = squash_room_reservation_start_timestamps[i]
      end_timestamp = (squash_room_reservation_start_timestamps[i] +
                       timedelta(hours=1))
      quantity = random.randrange(2, 7)

      sql = text(
        """INSERT INTO RoomReservation (member_id, room_id, 
        start_timestamp, end_timestamp, quantity) 
        VALUES (:member_id, :room_id, :start_timestamp, 
        :end_timestamp, :quantity)"""
      )
      val = ({"member_id": member_id, "room_id": room_id,
              "start_timestamp": start_timestamp,
              "end_timestamp": end_timestamp, "quantity": quantity})
      with self.engine.connect() as conn:
        conn.execute(sql, val)
        conn.commit()
      i += 1

  def generate_members(self, member_count):
    """
    This function generates a certain amount of members along with a
    random amount of group class registrations, machine reservations
     and room reservations.

    :param member_count:

    :return:
    """

    # pylint: disable=unused-variable
    for i in range(member_count):
      member_id = self.fake.uuid4()
      first_name = self.fake.first_name()
      last_name = self.fake.last_name()
      phone_number = self.fake.numerify("##########")
      email = self.fake.email()
      birthdate = date.today() + relativedelta(years=-20)

      sql = text(
        """INSERT INTO Member (member_id, first_name, last_name, 
        phone_number, email, birthdate) 
        VALUES (:member_id, :first_name, :last_name, :phone_number, 
        :email, :birthdate)""")
      val = (
        {"member_id": member_id, "first_name": first_name,
         "last_name": last_name, "phone_number": phone_number,
         "email": email, "birthdate": birthdate}
      )
      with self.engine.connect() as conn:
        conn.execute(sql, val)
        conn.commit()

      group_class_registration_start_timestamps = \
        self.generate_member_group_class(member_id)

      machine_reservation_start_timestamps = self. \
        generate_machine_reservations \
        (member_id,
         group_class_registration_start_timestamps)

      self.generate_room_reservations \
        (member_id,
         machine_reservation_start_timestamps
         + group_class_registration_start_timestamps)
