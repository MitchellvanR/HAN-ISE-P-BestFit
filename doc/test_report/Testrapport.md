# Testrapport

## Inhoudsopgave
- [1 Inleiding](#1-inleiding)
- [2 Testresultaten voor de stored procedures](#2-testresultaten-voor-de-stored-procedures)
  - [2.1 Stored procedure: SPROC-01 sproc_addMember](#21-stored-procedure-sproc-01-sprocaddmember)
  - [2.2 Stored procedure: SPROC-02 sproc_subscribeMember](#22--stored-procedure-sproc-02-sprocsubscribemember)
  - [2.3 Stored procedure: SPROC-03 sproc_prolongSubscription](#23-stored-procedure-sproc-03-sprocprolongsubscription)
  - [2.4 Stored procedure: SPROC-04 sproc_getSubscriptionInformation](#24-stored-procedure-sproc-04-sprocgetsubscriptioninformation)
  - [2.5 Stored procedure: SPROC-05 sproc_cancelSubscription](#25-stored-procedure-sproc-05-sproccancelsubscription)
  - [2.6 Stored procedure: SPROC-06 sproc_scheduleGroupClass](#26-stored-procedure-sproc-06-sprocschedulegroupclass)
  - [2.7 Stored procedure: SPROC-07 sproc_viewGroupClass](#27-stored-procedure-sproc-07-sprocviewgroupclass)
  - [2.8 Stored procedure: SPROC-08 sproc_signInGroupClass](#28-stored-procedure-sproc-08-sprocsigningroupclass)
  - [2.9 Stored procedure: SPROC-09 sproc_getEmployeeSchedules](#29-stored-procedure-sproc-09-sprocgetemployeeschedules)
  - [2.10 Stored procedure: SPROC-10 sproc_cancelGroupClass](#210-stored-procedure-sproc-10-sproccancelgroupclass)
  - [2.11 Stored procedure: SPROC-11 sproc_signOutGroupClass](#211-stored-procedure-sproc-11-sprocsignoutgroupclass)
  - [2.12 Stored procedure: SPROC-12 sproc_assignEmployee](#212-stored-procedure-sproc-12-sprocassignemployee)
  - [2.13 Stored procedure: SPROC-13 sproc_viewMemberReservations](#213-stored-procedure-sproc-13-sprocviewmemberreservations)
  - [2.14 Stored procedure: SPROC-14 sproc_editGroupClass](#214-stored-procedure-sproc-14-sproceditgroupclass)
  - [2.15 Stored procedure: SPROC-15 sproc_cancelReservation](#215-stored-procedure-sproc-15-sproccancelreservation)
  - [2.16 Stored procedure: SPROC-16 sproc_bookSquashRoom](#216-stored-procedure-sproc-16-sprocbooksquashroom)
  - [2.17 Stored procedure: SPROC-17 sproc_bookMachine](#217-stored-procedure-sproc-17-sprocbookmachine)
  - [2.18 Stored procedure: SPROC-18 sproc_switchMachineStatus](#218-stored-procedure-sproc-18-sprocswitchmachinestatus)
  - [2.19 Stored procedure: SPROC-19 sproc_editMachineReservation](#219-stored-procedure-sproc-19-sproceditmachinereservation)
  - [2.20 Stored procedure: SPROC-20 sproc_editSquashRoomReservation](#220-stored-procedure-sproc-20-sproceditsquashroomreservation)
- [3 Testresultaten voor de triggers](#3-testresultaten-voor-de-triggers)
  - [3.1 Trigger: TRG-01 trg_checkGroupClass](#31-trigger-trg-01-trggroupclassinsertupdate)
  - [3.2 Trigger: TRG-02 trg_MemberGroupClass_insertUpdate](#32-trigger-trg-02-trgmembergroupclassinsertupdate)
  - [3.3 Trigger: TRG-03 trg_Subscription_insertUpdate](#33-trigger-trg-03-trgsubscriptioninsertupdate)
  - [3.4 Trigger: TRG-04 trg_FitnessRoomSchedule_insertUpdate](#34-trigger-trg-04-trgfitnessroomscheduleinsertupdate)
  - [3.5 Trigger: TRG-05 trg_RoomReservation_insertUpdate](#35-trigger-trg-05-trgroomreservationinsertupdate)
  - [3.6 Trigger: TRG-06 trg_MachineReservation_insertUpdate](#36-trigger-trg-06-trgmachinereservationinsertupdate)
- [4 Conclusie](#4-conclusie)


## 1. Inleiding
Dit document is geschreven als vervolg op het testplan. In het testplan worden de teststrategie, testomgeving en de
testgevallen beschreven. In dit document wordt toegelicht waar de testresultaten te vinden zijn en hoe deze gegenereerd 
kunnen worden. Bij elke stored procedure en trigger wordt toegelicht welke test class deze heeft en wordt per test scenario genoteerd 
welke test case erbij hoort. Tot slot wordt in de conclusie een oordeel gevormd over de mate waarop het systeem getest 
wordt. 

### 1.1 Notatie van de testresultaten
In hoofdstuk twee van dit document worden de testresultaten van de stored procedures beschreven en in hoofdstuk drie worden de 
testresultaten van de triggers beschreven. Deze hoofdstukken volgen dezelfde structuur als de hoofdstukken in het testplan. Het 
enige verschil hierbij is het nummer van het hoofdstuk zelf. Hoofdstuk twee van het testrapport is namelijk gekoppeld aan hoofdstuk 
vier van het testplan. Ditzelfde geldt voor hoofdstuk drie van het testrapport, die gekoppeld is aan hoofdstuk vijf van het 
testplan. Als voorbeeld komt hoofdstuk 2.1 van het testrapport overeen met hoofdstuk 4.1 van het testplan en komt hoofdstuk 3.2 
van het testrapport overeen met hoofdstuk 5.2 van het testplan. 

Om kwaliteit van de code te waarborgen worden de testresultaten op twee manieren beschreven, namelijk als de test coverage en
de testresultaten. 

#### 1.1.1 Test coverage database
De test coverage is te vinden onder de map `~/doc/test_report/coverage/results/Coverage.html`. Bij deze coverage 
is te zien dat niet elk van de tests een coverage van 100% geeft. Dit komt doordat elke test uitgevoerd wordt als een transaction. 
In elke stored procedure die een transaction uitvoert, wordt een maatregel genomen dat wanneer de stored procedure een error 
geeft als de transaction nog niet is uitgevoerd, deze als volgt wordt opgevangen:

```sql
    IF XACT_STATE() = -1 AND @startTrancount = 0
        BEGIN 
            ROLLBACK TRANSACTION
        END
```

Aangezien de tests worden uitgevoerd als een transaction en dus de `@startTrancount` bij het testen altijd minimaal 1 is, 
wordt dit stuk code nooit bereikt en dus ook niet getest. Dit verklaart waarom bij de meeste test cases de code een coverage 
van ±95% heeft. 

Op het moment van oplevering is de meest recente versie van het eerdergenoemde Coverage.html bestand bijgeleverd. Mocht het 
echter nodig zijn om op een later moment nieuwe testresultaten te genereren, kan dit als volgt:

Navigeer naar de map `~/doc/test_report/coverage` en run het volgende command in de terminal:

```powershell
powershell RunSQLCover.ps1
```

Na het uitvoeren van dit commando wordt de test coverage gegenereerd en als `Coverage.html` geplaatst onder de 
map `~/doc/test_report/coverage/results`. Als het bestand in een browser wordt geopend is te zien dat de code die gedekt 
wordt door de tests in het groen gemarkeerd is. 

#### 1.1.2 Testresultaten database
Alle resultaten die gegenereerd zijn door de tSQLt unittests zijn te vinden in een .csv-bestand in de map `./results/`. 
In deze map staat naast het bestand `test_results.csv` ook een bestand `TestResults.ps1`. Dit bestand kan worden
uitgevoerd om het .csv-bestand te genereren met de meest actuele testresultaten.

Om dit bestand te runnen moet er een powershell terminal geopend worden in de map `./results/`. Vervolgens kan het
volgende worden uitgevoerd:
```powershell
powershell TestResults.ps1
```
In het .csv-bestand staan de volgende kolommen:
- **Class**: De naam van de class waar de test in staat.
- **TestCase**: De naam van de test.
- **Result**: Het resultaat van de test
- **Msg**: De boodschap die de test geeft wanneer deze faalt.

Bij elk subhoofdstuk wordt in het resultaat verwezen naar de Class en de TestCase om op deze manier de testresultaten
te kunnen koppelen aan de testgevallen uit het testplan.

### 1.1.3 Test coverage staging area
Alle coverage van de test van de staging area zijn gegenereerd door de dependency pytest-cov en door de tests in de
map `~/staging_area/bestfit/test/`. Om de test coverage te genereren moet er een terminal geopend worden in de map
`~/staging_area/bestfit/`. Vervolgens kan het volgende commando worden uitgevoerd:

```
poetry run pytest --cov=src/ --cov-report=html:./../../doc/test_report/coverage/staging_area
```

Na het uitvoeren van dit commando wordt er een map `staging_area` aangemaakt in de map `~/doc/test_report/coverage`. In deze map
staat een bestand `index.html`. Als dit bestand in een browser wordt geopend, is te zien hoeveel procent van de code
gedekt wordt door de tests. Als er op `src/bestfit/bestfit.py` wordt geklikt, is te zien welke regels van de code
gedekt worden door de tests.

### 1.1.4 Testresultaten staging area
Om de resultaten te krijgen van de gemaakte tests voor de staging area kan het volgende commando uitgevoerd worden in de
map `~/staging_area/bestfit`:

```
poetry run pytest -sv --html=./../../doc/test_report/results/staging_area/test_results.html
```
 Na het uitvoeren van dit commando wordt er een bestand `test_results.html` aangemaakt in de map `~/doc/test_report/results/staging_area`. Als dit bestand in een browser wordt geopend, is te zien welke tests er zijn uitgevoerd en wat de resultaten zijn van deze tests.

## 2. Testresultaten voor de stored procedures
Hieronder is te vinden welke testgevallen er zijn uitgevoerd voor de stored procedures. De testgevallen zijn opgedeeld
in de stored procedures waar ze bij horen en de testgevallen zijn genummerd. Dezelfde nummering is terug te vinden in het testplan.
Voor de stored procedures die horen bij het genereren van geschiedenis tabellen is er een tabel gemaakt, aangezien elk 
van deze stored procedures maar 1 testgeval heeft.

| Stored procedure                  | TestCase                               |
|-----------------------------------|----------------------------------------|
| sproc_generateHistoryTable        | test generating history table          |
| sproc_generateHistoryTableTrigger | test generating history table triggers |
| sproc_generateHistoryTables       | test if sprocs are called correctly    |

### 2.1 Stored procedure: SPROC-01 sproc_addMember

Deze stored procedure heeft als **Class** `testAddMember`.

| **Code** | **TestCase**                                                            |
|----------|-------------------------------------------------------------------------|
| T-01     | test if a member can be added and get a subscription correctly.         |
| T-02     | test if an underage member can be added with guardian information.      |
| T-03     | test if a member can't be added with the same email as someone else.    |
| T-04     | test if an underage member can't be added without guardian information. |

### 2.2  Stored procedure: SPROC-02 sproc_subscribeMember

Deze stored procedure heeft als **Class** `testSubscribeMember`.

| **Code** | **TestCase**                                                     |
|----------|------------------------------------------------------------------|
| T-01     | test if a member can add a subscription                          |
| T-02     | test if a member can't add a subscription twice                  |
| T-03     | test if a non-existing member can't add a subscription           |
| T-04     | test if a member can't add a non-existing subscription           |

### 2.3 Stored procedure: SPROC-03 sproc_prolongSubscription

Deze stored procedure heeft als **Class** `testProlongSubscription`.

| **Code** | **TestCase**                                                               |
|----------|----------------------------------------------------------------------------|
| T-01     | test if a subscription can be prolonged.                                   |
| T-02     | test if a subscription can't be prolonged when it does not exist.          |
| T-03     | test if a subscription can be prolonged when the member doesn't exist.     |
| T-04     | test if a subscription can't be shortened.                                 |

### 2.4 Stored procedure: SPROC-04 sproc_getSubscriptionInformation

Deze stored procedure heeft als **Class** `testGetSubscriptionInformation`.

| **Code** | **TestCase**                                                                    |
|----------|---------------------------------------------------------------------------------|
| T-01     | test if stored procedure returns correct single subscription row of a member    |
| T-02     | test if stored procedure returns correct multiple subscription rows of a member |

### 2.5 Stored procedure: SPROC-05 sproc_cancelSubscription

Deze stored procedure heeft als **Class** `testCancelSubscription`.

| **Code** | **TestCase**                                            |
|----------|---------------------------------------------------------|
| T-01     | test if an subscription can be cancelled successfully   |
| T-02     | test if an non-existing subscription can't be cancelled |
| T-03     | test if an inactive subscription can't be cancelled     |

### 2.6 Stored procedure: SPROC-06 sproc_scheduleGroupClass

Deze stored procedure heeft als **Class** `testScheduleGroupClass`.

| **Code** | **TestCase**                                                               |
|----------|----------------------------------------------------------------------------|
| T-01     | test to verify that a valid group class gets inserted correctly            |
| T-02     | test if an employee that doesn't exist can be assigned as an instructor    |
| T-03     | test if a room that doesn't exist can be assigned as a group class room    |
| T-04     | test if a group class can be scheduled for a class type that doesn't exist |

### 2.7 Stored procedure: SPROC-07 sproc_viewGroupClass

Deze stored procedure heeft als **Class** `testViewGroupClass`.

| **Code** | **TestCase**                                                                |
|----------|-----------------------------------------------------------------------------|
| T-01     | test if a member can view their sign ins for group classes.                 |
| T-02     | test if a non-existing member cannot view their sign ins for group classes. |

### 2.8 Stored procedure: SPROC-08 sproc_signInGroupClass

Deze stored procedure heeft als **Class** `testSignInGroupClass`.

| **Code** | **TestCase**                                                                                                 |
|----------|--------------------------------------------------------------------------------------------------------------|
| T-01     | test if a member can sign in for a group class.                                                              |
| T-02     | test if a member can't sign in for a group class that already happened.                                      |

### 2.9 Stored procedure: SPROC-09 sproc_getEmployeeSchedules

Deze stored procedure heeft als **Class** `testGetEmployeeSchedules`.

| **Code** | **TestCase**                                                                             |
|----------|------------------------------------------------------------------------------------------|
| T-01     | test if stored procedure correctly returns schedule for all employees for the next month |

### 2.10 Stored procedure: SPROC-10 sproc_cancelGroupClass

Deze stored procedure heeft als **Class** `testCancelGroupClass`.

| **Code** | **TestCase**                                                                    |
|----------|---------------------------------------------------------------------------------|
| T-01     | test if a group class can be cancelled successfully                             |
| T-02     | test if a group class can't be cancelled when the room_id does not match        |
| T-03     | test if a group class can't be cancelled when the start_timestamp does't match  |
| T-04     | test if a non-existing group class can't be cancelled                           |
| T-05     | test if a group class can't be cancelled when the teacher does not match        |

### 2.11 Stored procedure: SPROC-11 sproc_signOutGroupClass

Deze stored procedure heeft als **Class** `testSignOutGroupClass`.

| **Code** | **TestCase**                                                                        |
|----------|-------------------------------------------------------------------------------------|
| T-01     | test if a member can sign out of a group class.                                     |
| T-02     | test if a member cannot sign out of a group class that they are not registered for. |
| T-03     | test if a member cannot sign out of a group class that has started.                 |

### 2.12 Stored procedure: SPROC-12 sproc_assignEmployee

Deze stored procedure heeft als **Class** `testAssignEmployee`.

| **Code** | **TestCase**                                                                                   |
|----------|------------------------------------------------------------------------------------------------|
| T-01     | test if an employee can be assigned to a fitness room.                                         |
| T-02     | test if an employee cannot be assigned to a fitness room in the past.                          |

### 2.13 Stored procedure: SPROC-13 sproc_viewMemberReservations

Deze stored procedure heeft als **Class** `testViewMemberReservations`.

| **Code** | **TestCase**                                                                            |
|----------|-----------------------------------------------------------------------------------------|
| T-01     | test if the relevant information of the reservations all members gets fetched correctly |


### 2.14 Stored procedure: SPROC-14 sproc_editGroupClass

Deze stored procedure heeft als **Class** `testEditGroupClass`.

| **Code** | **TestCase**                                                                                              |
|----------|-----------------------------------------------------------------------------------------------------------|
| T-01     | test to verify that title gets updated correctly                                                          |
| T-02     | test to verify that room gets updated correctly                                                           |
| T-03     | test to verify that start_timestamp gets updated correctly                                                |
| T-04     | test to verify that employee_id gets updated correctly                                                    |
| T-05     | test to verify that end_timestamp gets updated correctly                                                  |
| T-06     | test to verify that title gets updated correctly when entering NULL values for other parameters           |
| T-07     | test to verify that room gets updated correctly when entering NULL values for other parameters            |
| T-08     | test to verify that start_timestamp gets updated correctly when entering NULL values for other parameters |
| T-09     | test to verify that employee_id gets updated correctly when entering NULL values for other parameters     |
| T-10     | test to verify that end_timestamp gets updated correctly when entering NULL values for other parameters   |
| T-11     | test to verify that room_id can't be updated to a room_id that isn't coupled to an existing room          |
| T-12     | test to verify that start_timestamp can't be updated to a start_timestamp that is past the end_timestamp  |
| T-13     | test to verify that employee_id can't be updated to an employee_id that isn't registered to an employee   |
| T-14     | test to verify that end_timestamp can't be updated to an end_timestamp that is before the start_timestamp |
| T-15     | test to verify that the identifying class_name has to exist                                               |
| T-16     | test to verify that the identifying room_id has to exist                                                  |
| T-17     | test to verify that the identifying start_timestamp has to exist                                          |

### 2.15 Stored procedure: SPROC-15 sproc_cancelReservation

Deze stored procedure heeft als **Class** `testCancelReservation`.

| **Code** | **TestCase**                                                                |
|----------|-----------------------------------------------------------------------------|
| T-01     | test if room reservation can be cancelled.                                  |
| T-02     | test if machine reservation can be cancelled.                               |
| T-03     | test if a reservation with an invalid reservation type cannot be cancelled. |
| T-04     | test if a non-existent room reservation cannot be cancelled.                |
| T-05     | test if a non-existent machine reservation cannot be cancelled.             |
| T-06     | test if a room reservation that has already ended cannot be cancelled.      |
| T-07     | test if a machine reservation that has already ended cannot be cancelled    |

### 2.16 Stored procedure: SPROC-16 sproc_bookSquashRoom

| **Code** | **TestCase**                                                  |
|----------|---------------------------------------------------------------|
| T-01     | test if a squash room reservation can be created successfully |

### 2.17 Stored procedure: SPROC-17 sproc_bookMachine

Deze stored procedure heeft als **Class** `testBookMachine`.

| **Code** | **TestCase**                                                                         |
|----------|--------------------------------------------------------------------------------------|
| T-01     | test that a member can successfully book a machine                                   |
| T-02     | test that a member cannot book a machine in the past                                 |
| T-03     | test that a member cannot book a machine where the end time is before the start time |


### 2.18 Stored procedure: SPROC-18 sproc_switchMachineStatus

Deze stored procedure heeft als **Class** `testSwitchMachineStatus`.

| **Code** | **TestCase**                                                          |
|----------|-----------------------------------------------------------------------|
| T-01     | test if a machine status can be switched from active to out of order. |
| T-02     | test if a machine status can be switched from out of order to active. |
| T-03     | test if a non-existing machine cannot be switched.                    |

### 2.19 Stored procedure: SPROC-19 sproc_editMachineReservation

Deze stored procedure heeft als **Class** `testEditMachineReservation`.

| **Code** | **Testcase**                                                                               |
|----------|--------------------------------------------------------------------------------------------|
| T-01     | Edit a machine reservation in a way that should be allowed.                                |
| T-02     | Attempt to edit the machine_id of a machine reservation to machine_id that doesn't exist.  |
| T-03     | Attempt to edit a machine reservation that doesn't exist.                                  |

### 2.20 Stored procedure: SPROC-20 sproc_editSquashRoomReservation

Deze stored procedure heeft als **Class** `testEditSquashRoomReservation`.

| **Code** | **Testcase**                                                                     |
|----------|----------------------------------------------------------------------------------|
| T-01     | Attempt to edit the room_id of a room reservation to a room that doesn't exist.  |
| T-02     | Edit a room reservation in a way that should be allowed.                         |
| T-03     | Attempt to edit a room reservation that doesn't exist.                           |


## 3. Testresultaten voor de triggers

#### 3.1 Trigger: TRG-01 trg_GroupClass_insertUpdate

Deze trigger heeft als **Class** `testTriggerGroupClass`.

| **Code** | **TestCase**                                                                                                   |
|----------|----------------------------------------------------------------------------------------------------------------|
| T-01     | test to verify that a valid group class gets through trigger checks                                            |            
| T-02     | test to verify that data does not get inserted because employee isn't qualified to teach class                 |
| T-03     | test to verify that data does not get inserted because room isn't suitable for group classes                   |
| T-04     | test to verify that data does not get inserted because employee is not available at the selected time          |
| T-05     | test to verify that data does not get inserted because room is not available at the selected time              |
| T-06     | test to verify that batches of data do not get inserted because employee isn't qualified to teach class        |
| T-07     | test to verify that batches of data do not get inserted because room isn't suitable for group classes          |
| T-08     | test to verify that batches data of do not get inserted because employee is not available at the selected time |
| T-09     | test to verify that batches of data do not get inserted because room is not available at the selected time     |

#### 3.2 Trigger: TRG-02 trg_MemberGroupClass_insertUpdate

Deze trigger heeft als **Class** `testTriggerMemberGroupClass`.

| **Code** | **TestCase**                                                                                                                  |
|----------|-------------------------------------------------------------------------------------------------------------------------------|
| T-01     | test to verify that a member can sign in to a group class.                                                                    |
| T-02     | test if the member is already registered for the group class.                                                                 |
| T-03     | test if the member is already registered for another group class that is still ongoing.                                       |
| T-04     | test if the member is already registered for another group class that starts during the group class.                          |
| T-05     | test if the member cannot sign in when the class starts during a machine reservation.                                         |
| T-06     | test if the member cannot sign in when the class ends during a machine reservation.                                           |
| T-07     | test if the member cannot sign in when the class starts during a room reservation.                                            |
| T-08     | test if the member cannot sign in when the class ends during a room reservation.                                              |
| T-09     | test if the member cannot sign in when the class is full.                                                                     |
| T-10     | test if the member cannot sign in when they do not have an ongoing subscription that fits the group class.                    |
| T-11     | test to verify that multiple members can sign in to group classes.                                                            |
| T-12     | test if multiple members cannot sign up when one of them is already registered for the group class.                           |
| T-13     | test if multiple members cannot sign up when one of them is already registered for another group class that is still ongoing. |
| T-14     | test if multiple members cannot sign up when one of them is already registered for another group class that starts during it. |
| T-15     | test if multiple members cannot sign up when one of the classes starts during a machine reservation.                          |
| T-16     | test if multiple members cannot sign up when one of the classes ends during a machine reservation.                            |
| T-17     | test if multiple members cannot sign up when one of the classes ends during a room reservation.                               |
| T-18     | test if multiple members cannot sign up when one of the classes starts during a room reservation.                             |
| T-19     | test if multiple members cannot sign in when the class is full.                                                               |
| T-20     | test if multiple members cannot sign in when they do not have an ongoing subscription that fits the group class.              |

#### 3.3 Trigger: TRG-03 trg_Subscription_insertUpdate

Deze trigger heeft als **Class** `testTriggerSubscription`.

| **Code** | **TestCase**                                                                                 |
|----------|----------------------------------------------------------------------------------------------|
| T-01     | test inserting member that is too young for a subscription                                   |
| T-02     | test inserting old member that is too old for a subscription                                 |
| T-03     | test if a subscription with correct data gets inserted correctly                             |
| T-04     | test updating a member's subscription to a subscription that is too young                    |
| T-05     | test updating a member's subscription to a subscription that is too old                      |
| T-06     | test if a subscription with correct data gets updated correctly                              |
| T-07     | test inserting the same subscription twice for a member                                      |
| T-08     | test if a member can insert two subscriptions of different types                             |
| T-09     | test updating a member's subscription to a subscription that is already active               |
| T-10     | test if an existing subscription can be updated while having a different subscription active |

#### 3.4 Trigger: TRG-04 trg_FitnessRoomSchedule_insertUpdate

Deze trigger heeft als **Class** `testTriggerFitnessRoomSchedule`.

| **Code** | **TestCase**                                                                                               |
|----------|------------------------------------------------------------------------------------------------------------|
| T-01     | test to verify that an employee can be assigned to a fitness room                                          |
| T-02     | test if an employee can be assigned to a room that is not a fitness room.                                  |
| T-03     | test if an employee cannot be assigned when they are already assigned to a fitness room at that time.      |
| T-04     | test if an employee cannot be assigned when they give a group class at that time.                          |
| T-05     | test if an employee cannot be assigned to a fitness room when do not have the role Employee.               |
| T-06     | test if an employee cannot be assigned when another employee is already assigned.                          |
| T-07     | test to verify that multiple employees can be assigned to a fitness room                                   |
| T-08     | test if multiple employees can be assigned while one room is not a fitness room.                           |
| T-09     | test if multiple employees cannot be assigned when one is already assigned to a fitness room at that time. |
| T-10     | test if multiple employees cannot be assigned when one gives a group class at that time.                   |
| T-11     | test if multiple employees cannot be assigned to a fitness room when one does not have the role Employee.  |
| T-12     | test if multiple employees cannot be assigned when another employee is already assigned.                   |

#### 3.5 Trigger: TRG-05 trg_RoomReservation_insertUpdate

Deze stored procedure heeft als **Class** `testTriggerRoomReservation`.

| **Code** | **TestCase**                                                                                                               |
|----------|----------------------------------------------------------------------------------------------------------------------------|
| T-01     | test to verify that a valid squash room reservation gets through trigger checks                                            |
| T-02     | test to verify that a valid squash room reservation gets through trigger checks (batch)                                    |
| T-03     | test to verify that the trigger throws an error when a member tries to make an overlapping squash room reservation         |
| T-04     | test to verify that the trigger throws an error when a member tries to make two overlapping squash room reservations       |
| T-05     | test to verify that the trigger throws an error when a member tries to make a squash reservation in a non-existing room    |
| T-06     | test to verify that the trigger throws an error when a member tries to make two squash reservations in a non-existing room |
| T-07     | test to verify that the trigger throws an error when a reservation is made when a member is not available                  |
| T-08     | test to verify that the trigger throws an error when two reservation are made when a member is not available               |

#### 3.6 Trigger: TRG-06 trg_MachineReservation_insertUpdate

Deze trigger heeft als **Class** `testTriggerMachineReservation`.

| **Code** | **TestCase**                                                                                                           |
|----------|------------------------------------------------------------------------------------------------------------------------|
| T-01     | test if reservation is inserted when all data is correct                                                               |
| T-02     | test if the reservation is not inserted at a date where the member has no subscription                                 |
| T-03     | test if the reservation is not inserted when the machine is out of order                                               |
| T-04     | test if the reservation is not inserted when the given member already booked this machine at the given start time      |
| T-05     | test if the reservation is not inserted when the given member already booked this machine at the given end time        |
| T-06     | test if the reservation is not inserted when the given machine is already booked at the given start time               |
| T-07     | test if the reservation is not inserted when the given machine is already booked at the given end time                 |
| T-08     | test if the reservation is not inserted when the given member already has a group class at the given start time        |
| T-09     | test if the reservation is not inserted when the given member already has a group class at the given end time          |
| T-10     | test if the reservation is not inserted when the given member already has a squash reservation at the given start time |
| T-11     | test if the reservation is not inserted when the given member already has a squash reservation at the given end time   |

## 4. Conclusie
Alle tests die vastgelegd zijn in het testplan, slagen naar verwachting. Alle resultaten van de tests voldoen aan onze
verwachting, waaraan we kunnen concluderen dat de functionaliteiten, hoe ze nu zijn geïmplementeerd, werken.
