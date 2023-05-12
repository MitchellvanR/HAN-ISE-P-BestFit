<!-- TODO - Add guide to install the repo and add some styling-->
<!-- Also, expand the current descriptions to bigger texts-->

1. Installeer Python 3.*
   https://www.python.org/downloads/


2. Run in een terminal:

```
pip install pandas
pip install pyodbc
pip install redis
pip install faker
pip install sqlalchemy
```

3. Installeer de ODBC 18 Driver For SQL Server
   https://learn.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-ver16


4. Installeer Docker Desktop
   https://www.docker.com/products/docker-desktop/


5. Herstart je PC


6. Start Docker Desktop
   (Zet in de instellingen "Open Docker Dashboard at startup" uit om te zorgen dat je RAM overhoud wanneer je Docker niet gebruikt)


7. Run in je IDE in de map staging-area/prototype:

```
docker compose up -d
```

8. Run daarna een van de volgende commands op basis welk script je wilt uitvoeren

```
python generateTestData.py
python cacheReservations.py
python getPersonalRoster.py
```
