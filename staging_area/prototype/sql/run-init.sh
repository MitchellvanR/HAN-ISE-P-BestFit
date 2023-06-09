#!/bin/bash
# set -x

echo $'\nWaiting for SQL Server to start... \n'
sleep 20

echo $'\nCreating database... \n'
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ISE_project -i /scripts/000_create.sql

echo $'\nInserting data... \n'
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ISE_project -i /scripts/001_insert.sql

echo $'\nDone!'