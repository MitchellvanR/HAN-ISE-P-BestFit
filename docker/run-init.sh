#!/bin/bash
# set -x

DB_USER=sa
DB_PASSWORD=ISE_project

MAIN_DB=BestFit
TEST_DB=Test_BestFit

echo $'\nWaiting for SQL Server to start... \n'

sleep 25

echo $'\nCreating database... \n'
/opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i scripts/000_create_db.sql

sleep 2

echo $'\nCreating test database... \n'
/opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i scripts/001_create_test_db.sql

sleep 5

echo $'\nConfiguring T-SQL... \n'
/opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i scripts/tsqlt/PrepareServer.sql -d "$TEST_DB"
/opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i scripts/tsqlt/tSQLt.class.sql -d "$TEST_DB"

sleep 5

echo $'\nAdding procedures for testing... \n'
for i in scripts/procedures/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i "$i" -d "$TEST_DB"
done

sleep 5

echo $'\nAdding triggers for testing... \n'
for i in scripts/triggers/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i "$i" -d "$TEST_DB"
done

sleep 10

echo $'\nTesting procedures... \n'
for i in scripts/procedure_tests/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i "$i" -d "$TEST_DB"
done

sleep 10

echo $'\nTesting triggers... \n'
for i in scripts/trigger_tests/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i "$i" -d "$TEST_DB"
done

sleep 10

echo $'\nCreating history tables in main database... \n'
/opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i scripts/002_create_hist.sql -d "$MAIN_DB"

sleep 5

echo $'\nAdding procedures to main database... \n'
for i in scripts/procedures/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i "$i" -d "$MAIN_DB"
done

sleep 5

echo $'\nAdding triggers to main database... \n'
for i in scripts/triggers/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i "$i" -d "$MAIN_DB"
done

sleep 5

echo $'\nInserting data... \n'
/opt/mssql-tools/bin/sqlcmd -S localhost -U "$DB_USER" -P "$DB_PASSWORD" -i scripts/003_insert.sql -d "$MAIN_DB"

echo $'\nDone!'