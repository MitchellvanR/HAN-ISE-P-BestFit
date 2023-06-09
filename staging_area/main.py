"""
This is the main module for the BestFit staging area. It is the entry point for
the application. It provides a menu for the user to choose from.
"""

import sys
from bestfit import bestfit_cacher
from bestfit import bestfit_roster
from bestfit import bestfit_generator


def main() -> None:
  """
  This is the main function for the BestFit staging area. It is the entry point
  for the application. It provides a menu for the user to choose from.

  Parameters:
  None

  Returns:
  None

  """

  print("Choose an option:")
  print("1. Cache employee schedule")
  print("2. Cache member reservations")
  print("3. Get employee schedule")
  print("4. Get member reservations")
  print("5. Generate test data")
  print("6. Exit")

  choice = int(input("Enter your choice [1-6]: "))

  mssql_host = "127.0.0.1"
  db = "BestFit"
  db_username = "LOG_BEST_FIT_STAGING"
  db_password = "BestFitStagingExamplePassword0?"
  # When deploying to production, change db_password to a
  # secure password and store it in a secure location

  redis_host = "localhost"
  redis_port = 6379

  cacher = bestfit_cacher(mssql_host, db, db_username,
                          db_password,
                          redis_host,
                          redis_port)
  roster = bestfit_roster(redis_host, redis_port)
  generator = bestfit_generator(mssql_host, db, db_username, db_password,)

  if choice == 1:
    cacher.cache_schedule()
    print("\nSchedule cached!\n")
    main()
  elif choice == 2:
    cacher.cache_reservations()
    print("\nReservations cached!\n")
    main()
  elif choice == 3:
    employee_id = str(input("Enter employee ID: "))
    roster.get_employee_schedule(employee_id)
    print("\nSchedule retrieved!\n")
    main()
  elif choice == 4:
    member_id = str(input("Enter member ID: "))
    roster.get_member_reservations(member_id)
    print("\nReservations retrieved!\n")
    main()
  elif choice == 5:
    generator.generate_test_data()
    print("\nTest data generated!\n")
    main()
  elif choice == 6:
    print("\nExiting...")
    sys.exit()
  else:
    print("\nInvalid choice!\n")
    main()


if __name__ == "__main__":
  main()
