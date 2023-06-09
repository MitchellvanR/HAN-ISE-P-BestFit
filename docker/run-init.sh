#!/bin/bash
# set -x

DB_USER=sa
DB_PASSWORD=BestFitSAExamplePassword0?
# When deploying to production, change DB_PASSWORD to a strong password and store it in a secure manner.

MAIN_DB=BestFit
TEST_DB=Test_BestFit

CONNECTION_STRING="-S localhost -U $DB_USER -P $DB_PASSWORD"

echo $'\nWaiting for SQL Server to start... \n'

sleep 20

is_database_started() {
    query="SELECT 1"
    /opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -Q "$query" >/dev/null 2>&1
    return $?
}

while ! is_database_started; do
    echo $'\nWaiting for the database to start...\n'
    sleep 2
done

echo $'\nCreating database... \n'
/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/000_create_db.sql

echo $'\nCreating test database... \n'
/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/001_create_test_db.sql

echo $'\nCreating database login and users... \n'
/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/002_create_db_login_users.sql

DB_USER=LOG_BEST_FIT_ADMIN
DB_PASSWORD=BestFitAdminExamplePassword0?
# When deploying to production, change DB_PASSWORD to a strong password and store it in a secure manner.

echo $'\nConfiguring T-SQL... \n'
/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/tsqlt/PrepareServer.sql -d "$TEST_DB"
/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/tsqlt/tSQLt.class.sql -d "$TEST_DB"

sleep 3

echo $'\nAdding procedures for testing... \n'
for i in scripts/procedures/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i "$i" -d "$TEST_DB"
done

/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/003_add_hist_procedures.sql -d "$TEST_DB"

echo $'\nAdding triggers for testing... \n'
for i in scripts/triggers/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i "$i" -d "$TEST_DB"
done

echo $'\nAdding tests for procedures... \n'
for i in scripts/procedure_tests/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i "$i" -d "$TEST_DB"
done

/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/004_add_hist_procedures_tests.sql -d "$TEST_DB"

echo $'\nAdding tests for triggers... \n'
for i in scripts/trigger_tests/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i "$i" -d "$TEST_DB"
done

sleep 5

echo $'\nRunning tests... \n'
/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/005_run_tests.sql -d "$TEST_DB"

sleep 5

echo $'\nCreating history tables in main database... \n'
/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/003_add_hist_procedures.sql -d "$MAIN_DB"

sleep 1

/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/006_run_hist_procedures.sql -d "$MAIN_DB"

echo $'\nAdding procedures... \n'
for i in scripts/procedures/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i "$i" -d "$MAIN_DB"
done

echo $'\nAdding triggers to main database... \n'
for i in scripts/triggers/*.sql;
do
    /opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i "$i" -d "$MAIN_DB"
done

echo $'\nInserting data... \n'
/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/007_insert.sql -d "$MAIN_DB"

echo $'\nCreating staging area user... \n'
/opt/mssql-tools/bin/sqlcmd $CONNECTION_STRING -i scripts/008_create_staging_area_user.sql

echo $'\nDone!'