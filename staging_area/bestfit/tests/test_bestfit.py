"""
This module contains unit tests for the BestFit Module.
"""

import unittest
from unittest.mock import MagicMock, patch
import os
from io import StringIO
from datetime import datetime, timedelta
import json
import pandas as pd
from pandas.testing import assert_frame_equal
import pyodbc
import sqlalchemy
import redis

import bestfit


class TestBestFitCacher(unittest.TestCase):
  """
  This class contains unit tests for the BestFitCacher class.
  """

  def setUp(self):
    # Reset Redis and clear any previous cached data before each test
    self.cacher = bestfit.bestfit_cacher(
      server="test_server",
      database="test_database",
      username="test_user",
      password="test_password",
      redishost="test_redishost",
      redisport=6379
    )

  def test_cache_schedule(self):
    """
    T-01
    This method tests the cache_schedule method of the BestFitCacher class.

    Expected Result: The method should call the get_from_db method with the
    correct parameters and call the put_in_cache method with the correct
    parameters.
    """
    expected_data = [
      {
        "employee_id": 1,
        "class_name": "Class 1",
        "room_id": 1,
        "start_timestamp": "2023-05-30 10:00:00.000",
        "end_timestamp": "2023-05-30 11:00:00.000",
      }
    ]
    expected_df = pd.DataFrame(expected_data)

    expected_df["start_timestamp"] = \
      pd.to_datetime(expected_df["start_timestamp"]) \
        .dt.strftime("%Y-%m-%d %H:%M:%S.%f")
    expected_df["end_timestamp"] = \
      pd.to_datetime(expected_df["end_timestamp"]) \
        .dt.strftime("%Y-%m-%d %H:%M:%S.%f")

    expected_json = expected_df.to_json(orient="records")

    # Mock the Redis set method
    mock_put_in_cache = MagicMock()
    mock_put_in_cache.return_value = None
    self.cacher.put_in_cache = mock_put_in_cache

    # Mock the get_from_db method
    mock_get_from_db = MagicMock()
    mock_get_from_db.return_value = expected_df
    self.cacher.get_from_db = mock_get_from_db

    # Call the method under test
    self.cacher.cache_schedule()

    # Assertions
    mock_get_from_db.assert_called_once_with("sproc_getEmployeeSchedules")
    mock_put_in_cache.assert_called_once_with("schedule",
                                              json.dumps(expected_json))

  def test_cache_schedule_pyodbc_exception(self):
    """
    T-02
    This method tests the cache_schedule method of the BestFitCacher class.

    Expected Result: The method should print an error message
    like the following:
    "Error connecting to database: <error message>"
    """

    # Patch the standard output to capture printed messages
    mock_get_from_db = MagicMock(side_effect=pyodbc.Error)
    self.cacher.get_from_db = mock_get_from_db
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.cacher.cache_schedule()

      # Check if the expected error message is printed
      self.assertIn("Error connecting to database:", fake_out.getvalue())

  def test_cache_schedule_pd_exception(self):
    """
    T-03
    This method tests the cache_schedule method of the BestFitCacher class.

    Expected Result: The method should print an error message
    like the following:
    "Error executing SQL query: <error message>"
    """

    # Patch the standard output to capture printed messages
    mock_get_from_db = MagicMock(side_effect=pd.errors.DatabaseError)
    self.cacher.get_from_db = mock_get_from_db
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.cacher.cache_schedule()

      # Check if the expected error message is printed
      self.assertIn("Error executing SQL query:", fake_out.getvalue())

  def test_cache_schedule_value_error_exception(self):
    """
    T-04
    This method tests the cache_schedule method of the BestFitCacher class.

    Expected Result: The method should print an error message
     like the following:
    "Error converting data: <error message>"
    """

    # Patch the standard output to capture printed messages
    mock_get_from_db = MagicMock(side_effect=ValueError)
    self.cacher.get_from_db = mock_get_from_db
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.cacher.cache_schedule()

      # Check if the expected error message is printed
      self.assertIn("Error converting data:", fake_out.getvalue())

  def test_cache_reservation(self):
    """
    T-01
    This method tests the cache_reservation method of the BestFitCacher class.

    Expected Result: The method should call the get_from_db method with the
    correct parameters and call the put_in_cache method with the correct
    parameters.
    """

    expected_data = [
      {
        "member_id": 1,
        "class_name": "Class 1",
        "room_id": 1,
        "start_timestamp": "2023-05-30 10:00:00.000",
        "end_timestamp": "2023-05-30 11:00:00.000",
      }
    ]
    expected_df = pd.DataFrame(expected_data)

    expected_df["start_timestamp"] = \
      pd.to_datetime(expected_df["start_timestamp"]) \
        .dt.strftime("%Y-%m-%d %H:%M:%S.%f")
    expected_df["end_timestamp"] = \
      pd.to_datetime(expected_df["end_timestamp"]) \
        .dt.strftime("%Y-%m-%d %H:%M:%S.%f")

    expected_json = expected_df.to_json(orient="records")

    # Mock the Redis set method
    mock_put_in_cache = MagicMock()
    mock_put_in_cache.return_value = None
    self.cacher.put_in_cache = mock_put_in_cache

    # Mock the get_from_db method
    mock_get_from_db = MagicMock()
    mock_get_from_db.return_value = expected_df
    self.cacher.get_from_db = mock_get_from_db

    # Call the method under test
    self.cacher.cache_reservations()

    # Assertions
    mock_get_from_db.assert_called_once_with("sproc_viewMemberReservations")
    mock_put_in_cache.assert_called_once_with("reservations",
                                              json.dumps(expected_json))

  def test_cache_reservation_pyodbc_exception(self):
    """
    T-02
    This method tests the cache_reservation method of the BestFitCacher class.

    Expected Result: The method should print an error message
    like the following:
    "Error connecting to database: <error message>"
    """

    # Patch the standard output to capture printed messages
    mock_get_from_db = MagicMock(side_effect=pyodbc.Error)
    self.cacher.get_from_db = mock_get_from_db
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.cacher.cache_reservations()

      # Check if the expected error message is printed
      self.assertIn("Error connecting to database:", fake_out.getvalue())

  def test_cache_reservation_pd_exception(self):
    """
    T-03
    This method tests the cache_reservation method of the BestFitCacher class.

    Expected Result: The method should print an error message
    like the following:
    "Error executing SQL query: <error message>"
    """

    # Patch the standard output to capture printed messages
    mock_get_from_db = MagicMock(side_effect=pd.errors.DatabaseError)
    self.cacher.get_from_db = mock_get_from_db
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.cacher.cache_reservations()

      # Check if the expected error message is printed
      self.assertIn("Error executing SQL query:", fake_out.getvalue())

  def test_cache_reservation_value_error_exception(self):
    """
    T-04
    This method tests the cache_reservation method of the BestFitCacher class.

    Expected Result: The method should print an error message
    like the following:
    "Error converting data: <error message>"
    """

    # Patch the standard output to capture printed messages
    mock_get_from_db = MagicMock(side_effect=ValueError)
    self.cacher.get_from_db = mock_get_from_db
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.cacher.cache_reservations()

      # Check if the expected error message is printed
      self.assertIn("Error converting data:", fake_out.getvalue())

  @patch("pyodbc.connect")
  @patch("pandas.read_sql_query")
  def test_get_from_db(self, mock_read_sql_query, mock_connect):
    """
    T-01
    This method tests the get_from_db method of the BestFitCacher class.

    Expected Result: The method should call the pyodbc.connect function with
    the correct parameters and call the pd.read_sql_query function with the
    """

    # Mock the pd.read_sql_query function and its return value
    expected_data = [
      {"employee_id": 1, "class_name": "Class 1", "room_id": 1,
       "start_timestamp": "2023-05-30 10:00:00.000",
       "end_timestamp": "2023-05-30 11:00:00.000"},
      {"employee_id": 2, "class_name": "Class 2", "room_id": 2,
       "start_timestamp": "2023-05-30 12:00:00.000",
       "end_timestamp": "2023-05-30 13:00:00.000"}
    ]
    expected_df = pd.DataFrame(expected_data)

    mock_read_sql_query.return_value = expected_data

    # Mock the pyodbc.connect function and its return value
    mock_conn = MagicMock()
    mock_connect.return_value = mock_conn

    # Mock the self.engine.connect method
    self.cacher.engine.connect = MagicMock(return_value=mock_conn)

    # Call the method under test
    result = self.cacher.get_from_db("test_procedure")

    # Assertions
    mock_read_sql_query.assert_called_once_with("EXEC test_procedure",
                                                mock_conn)
    assert_frame_equal(expected_df, result)

  # pylint: disable=unused-argument
  @patch("pyodbc.connect", side_effect=pyodbc.Error)
  @patch("pandas.read_sql_query")
  def test_get_from_db_pyodbc_exception(self, mock_read_sql_query,
                                        mock_connect):
    """
    T-02
    This method tests the get_from_db method of the BestFitCacher class.

    Expected Result: The method should print an error message
    like the following:
    "Error connecting to database: <error message>"
    """

    # Mock the self.engine.connect method
    self.cacher.engine.connect = mock_connect

    # Patch the standard output to capture printed messages
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.cacher.get_from_db("test_procedure")

      # Check if the expected error message is printed
      self.assertIn("Error connecting to database:", fake_out.getvalue())

  # pylint: disable=unused-argument
  @patch("pyodbc.connect")
  @patch("pandas.read_sql_query", side_effect=pd.errors.DatabaseError)
  def test_get_from_db_pd_exception(self, mock_read_sql_query, mock_connect):
    """
    T-03
    This method tests the get_from_db method of the BestFitCacher class.

    Expected Result: The method should print an error message
    like the following:
    "Error executing SQL query: <error message>"
    """

    # Mock the self.engine.connect method
    self.cacher.engine.connect = mock_connect

    # Patch the standard output to capture printed messages
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.cacher.get_from_db("test_procedure")

      # Check if the expected error message is printed
      self.assertIn("Error executing SQL query:", fake_out.getvalue())

  # pylint: disable=unused-argument
  @patch("pyodbc.connect", side_effect=sqlalchemy.exc.ResourceClosedError)
  @patch("pandas.read_sql_query")
  def test_get_from_db_resources_closed_error_exception(self,
                                                        mock_read_sql_query,
                                                        mock_connect):
    """
    T-04
    This method tests the get_from_db method of the BestFitCacher class.

    Expected Result: The method should return an empty dataframe
    """

    expected_df = pd.DataFrame(columns=["employee_id", "class_name",
                                        "room_id",
                                        "start_timestamp",
                                        "end_timestamp"])

    # Mock the self.engine.connect method
    self.cacher.engine.connect = mock_connect

    # Call the method under test
    result = self.cacher.get_from_db("test_procedure")

    # Assertions
    assert_frame_equal(expected_df, result)

  @patch("redis.Redis")
  def test_put_in_cache(self, mock_redis_cls):
    """
    T-01
    This method tests the put_in_cache method of the BestFitCacher class.

    Expected Result: The method should call the redis.Redis.set method with the
    correct parameters.
    """

    # Mock the redis.Redis class and its return value
    mock_redis_conn = MagicMock()
    mock_redis_cls.return_value = mock_redis_conn
    self.cacher.redis_conn = mock_redis_conn

    # Call the method under test
    self.cacher.put_in_cache("test_key", "test_value")

    # Assertions
    mock_redis_conn.set.assert_called_once_with("test_key", "test_value")

  @patch("redis.Redis", side_effect=redis.RedisError)
  def test_put_in_cache_exception(self, mock_redis_cls):
    """
    T-02
    This method tests the put_in_cache method of the BestFitCacher class.

    Expected Result: The method should print an error message
    like the following:
    "Error inserting data into Redis: <error message>"
    """

    # Mock the redis.Redis class and its return value
    self.cacher.redis_conn.set = mock_redis_cls

    # Patch the standard output to capture printed messages
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.cacher.put_in_cache("test_key", "test_value")

      # Check if the expected error message is printed
      self.assertIn("Error inserting data into Redis:", fake_out.getvalue())


class TestBestFitRoster(unittest.TestCase):
  """
  This class contains unit tests for the bestfit_roster function
  """

  def setUp(self):
    """
    This method is called before each test and sets up the test environment

    :return:
    """

    self.roster = bestfit.bestfit_roster(
      "test_host",
      "test_post"
    )

  def test_get_employee_schedule(self):
    """
    T-01
    This method tests the get_employee_schedule method of the BestFitRoster
    class.

    Expected Result: The method should return a dataframe with the correct
    data
    """

    # Define the expected data
    expected_data = pd.DataFrame([
      {"class_name": "Class 1", "room_id": 1,
       "start_timestamp": "2023-05-30 10:00:00.000",
       "end_timestamp": "2023-05-30 11:00:00.000"}
    ])

    # Mock the get_from_cache method
    self.roster.get_from_cache = MagicMock(
      return_value='[{"employee_id": "ABCDEFGHIJK-123456789012-ABCDEFGHIJK", '
                   '"class_name": "Class 1", "room_id": 1, '
                   '"start_timestamp": "2023-05-30 10:00:00.000", '
                   '"end_timestamp": "2023-05-30 11:00:00.000"}]')

    # Call the method under test
    self.roster.get_employee_schedule("ABCDEFGHIJK-123456789012-ABCDEFGHIJK")

    # Check if the schedule file exists
    self.assertTrue(os.path.exists("schedule.csv"))

    # Read the contents of the schedule file
    schedule_df = pd.read_csv("schedule.csv")

    # Assert the actual and expected dataframes are equal
    pd.testing.assert_frame_equal(expected_data, schedule_df)

    # Remove the schedule file
    os.remove("schedule.csv")

  def test_get_employee_schedule_value_error(self):
    """
    T-02
    This method tests the get_employee_schedule method of the BestFitRoster
    class.

    Expected Result: The method should print an error message
    like the following:
    "Please enter a valid value!"
    """

    # Patch the standard output to capture printed messages
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.roster.get_employee_schedule(1)

      # Check if the expected error message is printed
      self.assertIn("Please enter a valid value!", fake_out.getvalue())

  def test_get_employee_schedule_connection_error(self):
    """
    T-03
    This method tests the get_employee_schedule method of the BestFitRoster
    class.

    Expected Result: The method should print an error message
    like the following:
    "Failed to connect to Redis: <error message>"
    """

    # Mock the get_from_cache method
    self.roster.get_from_cache = MagicMock(side_effect=redis.ConnectionError)

    # Patch the standard output to capture printed messages
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.roster.get_employee_schedule("ABCDEFGHIJK-123456789012-ABCDEFGHIJK")

      # Check if the expected error message is printed
      self.assertIn("Failed to connect to Redis", fake_out.getvalue())

  def test_get_employee_schedule_type_error(self):
    """
    T-04
    This method tests the get_employee_schedule method of the BestFitRoster
    class.

    Expected Result: The method should print an error message
    like the following:
    "No records found!"
    """

    # Mock the get_from_cache method
    self.roster.get_from_cache = MagicMock(side_effect=TypeError)

    # Patch the standard output to capture printed messages
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.roster.get_employee_schedule("ABCDEFGHIJK-123456789012-ABCDEFGHIJK")

      # Check if the expected error message is printed
      self.assertIn("No records found!", fake_out.getvalue())

  def test_get_member_reservations(self):
    """
    T-01
    This method tests the get_member_reservations method of the BestFitRoster
    class.

    Expected Result: The method should return a dataframe with the correct
    data
    """

    # Define the expected data
    expected_data = pd.DataFrame([
      {"class_name": "Class 1", "room_id": 1,
       "start_timestamp": "2023-05-30 10:00:00.000",
       "end_timestamp": "2023-05-30 11:00:00.000"}
    ])

    # Mock the get_from_cache method
    self.roster.get_from_cache = MagicMock(
      return_value='[{"member_id": "ABCDEFGHIJK-123456789012-ABCDEFGHIJK", '
                   '"class_name": "Class 1", "room_id": 1, '
                   '"start_timestamp": "2023-05-30 10:00:00.000", '
                   '"end_timestamp": "2023-05-30 11:00:00.000"}]')

    # Call the method under test
    self.roster.get_member_reservations("ABCDEFGHIJK-123456789012-ABCDEFGHIJK")

    # Check if the reservations file exists
    self.assertTrue(os.path.exists("reservations.csv"))

    # Read the contents of the reservations file
    reservations_df = pd.read_csv("reservations.csv")

    # Assert the actual and expected dataframes are equal
    pd.testing.assert_frame_equal(expected_data, reservations_df)

    # Remove the reservations file
    os.remove("reservations.csv")

  def test_get_member_reservations_value_error(self):
    """
    T-02
    This method tests the get_member_reservations method of the BestFitRoster
    class.

    Expected Result: The method should print an error message
    like the following:
    "Please enter a valid value!"
    """

    # Patch the standard output to capture printed messages
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.roster.get_member_reservations(1)

      # Check if the expected error message is printed
      self.assertIn("Please enter a valid value!", fake_out.getvalue())

  def test_get_member_reservations_connection_error(self):
    """
    T-03
    This method tests the get_member_reservations method of the BestFitRoster
    class.

    Expected Result: The method should print an error message
    like the following:
    "Failed to connect to Redis: <error message>"
    """

    # Mock the get_from_cache method
    self.roster.get_from_cache = MagicMock(side_effect=redis.ConnectionError)

    # Patch the standard output to capture printed messages
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.roster. \
        get_member_reservations("ABCDEFGHIJK-123456789012-ABCDEFGHIJK")

      # Check if the expected error message is printed
      self.assertIn("Failed to connect to Redis", fake_out.getvalue())

  def test_get_member_reservations_type_error(self):
    """
    T-04
     This method tests the get_member_reservations method of the BestFitRoster
     class.

    Expected Result: The method should print an error message
    like the following:
    "No records found!"
    """

    # Mock the get_from_cache method
    self.roster.get_from_cache = MagicMock(side_effect=TypeError)

    # Patch the standard output to capture printed messages
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.roster. \
        get_member_reservations("ABCDEFGHIJK-123456789012-ABCDEFGHIJK")

      # Check if the expected error message is printed
      self.assertIn("No records found!", fake_out.getvalue())

  def test_get_from_cache(self):
    """
    T-01
    This method tests the get_from_cache method of the BestFitRoster
    class.

    Expected Result: The method should return the expected value
    """

    # Mock the Redis connection and get method
    mock_redis_conn = MagicMock()
    mock_redis_conn.get.return_value = '[{"data": "value"}]'
    self.roster.redis_conn = mock_redis_conn

    # Call the method under test
    result = self.roster.get_from_cache("key")

    # Assert the Redis connection and get method were called
    mock_redis_conn.get.assert_called_once_with("key")

    # Assert the result is the expected value
    self.assertEqual(result, [{"data": "value"}])

  def test_get_from_cache_key_none(self):
    """
    T-02
    This method tests the get_from_cache method of the BestFitRoster
    class.

    Expected Result: The method should return None
    """

    # Mock the Redis connection and get method
    mock_redis_conn = MagicMock()
    mock_redis_conn.get.return_value = None
    self.roster.redis_conn = mock_redis_conn

    # Call the method under test
    result = self.roster.get_from_cache("key")

    # Assert the Redis connection and get method were called
    mock_redis_conn.get.assert_called_once_with("key")

    # Assert the result is the expected value
    self.assertEqual(result, "[]")

  def test_get_from_cache_connection_error(self):
    """
    T-03
    This method tests the get_from_cache method of the BestFitRoster
    class.

    Expected Result: The method should print an error message
    like the following:
    "Failed to connect to Redis: <error message>"
    """

    mock_redis_conn = MagicMock(side_effect=redis.ConnectionError)
    self.roster.redis_conn.get = mock_redis_conn

    # Patch the standard output to capture printed messages
    with patch("sys.stdout", new=StringIO()) as fake_out:
      # Call the method under test
      self.roster.get_from_cache("key")

      # Check if the expected error message is printed
      self.assertIn("Failed to connect to Redis", fake_out.getvalue())


class BestFitGeneratorTestCase(unittest.TestCase):
  """
  This class contains unit tests for the bestfit_generator function
  """

  def setUp(self):
    """
    This method is called before each test and sets up the test environment

    :return:
    """

    self.generator = bestfit.bestfit_generator("test_server",
                                               "test_database",
                                               "test_username",
                                               "test_password")

  def test_generate_random_timestamps(self):

    occupied_timestamps = [
      datetime(2023, 5, 1, 10, 0),
      datetime(2023, 5, 1, 11, 0),
      datetime(2023, 5, 1, 12, 0)
    ]

    self.generator.fake.date_time_this_month = MagicMock(side_effect=[
      datetime(2023, 5, 1, 13, 0),
      datetime(2023, 5, 1, 10, 0),
      datetime(2023, 5, 1, 15, 0),
      datetime(2023, 5, 1, 16, 0),
    ])

    start_timestamps = self.generator. \
      generate_random_timestamps(3,
                                 occupied_timestamps)

    # Check if the generated timestamps are unique and not occupied
    for timestamp in start_timestamps:
      self.assertTrue(all(
        timestamp < t + timedelta(hours=1) or t < timestamp +
        timedelta(hours=1)
        for t in occupied_timestamps
      ))
      occupied_timestamps.append(timestamp)

    # Check if the number of generated timestamps matches the expected amount
    self.assertEqual(len(start_timestamps), 3)

  def test_generate_random_timestamps_no_occupied_timestamps(self):

    occupied_timestamps = [
    ]

    start_timestamps = self.generator.generate_random_timestamps(3, None)

    # Check if the generated timestamps are unique and not occupied
    for timestamp in start_timestamps:
      self.assertTrue(all(
        timestamp < t + timedelta(hours=1) or t < timestamp +
        timedelta(hours=1)
        for t in occupied_timestamps
      ))
      occupied_timestamps.append(timestamp)

    # Check if the number of generated timestamps matches the expected amount
    self.assertEqual(len(start_timestamps), 3)


if __name__ == "__main__":
  unittest.main()
