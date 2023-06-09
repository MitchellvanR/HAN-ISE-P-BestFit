EXEC tSQLt.NewTestClass 'testTriggerFitnessRoomSchedule';
GO

DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[SetUp]
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO Room (room_id, functionality) VALUES (1, 'Fitness')

    EXEC tSQLt.FakeTable 'dbo', 'GroupClass';

    EXEC tSQLt.FakeTable 'dbo', 'FitnessRoomSchedule';
    EXEC [tSQLt].[ApplyTrigger] @TableName = 'dbo.FitnessRoomSchedule',
         @TriggerName = 'trg_FitnessRoomSchedule_insertUpdate'

    EXEC tSQLt.FakeTable 'dbo', 'EmployeeRole';
    INSERT INTO EmployeeRole (employee_id, role_name) VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 'Employee'),
                                                             ('LMNOPQURSTU-987654321012-LMNOPQURSTU', 'Employee');
END
GO

/**
* T-01
* An employee can be assigned to a fitness room.
*
* Expects
*   - The employee is assigned to the room.
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test to verify that an employee can be assigned to a fitness room];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test to verify that an employee can be assigned to a fitness room]
AS
BEGIN
    --Assemble
    IF OBJECT_ID('[testTriggerFitnessRoomSchedule].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testTriggerFitnessRoomSchedule].[expected]

    SELECT TOP 0 *
    INTO [testTriggerFitnessRoomSchedule].[expected]
    FROM dbo.FitnessRoomSchedule;

    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);

    INSERT INTO [testTriggerFitnessRoomSchedule].[expected]
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate);

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate);

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testTriggerFitnessRoomSchedule.expected', 'dbo.FitnessRoomSchedule', '',
         'Tables do not match!';
END;
GO

/**
* T-02
* An employee cannot be assigned to a room that is not a fitness room.
*
* Expects
*   - Exception: 'The room is not a fitness room.'
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test if an employee can be assigned to a room that is not a fitness room.];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test if an employee can be assigned to a room that is not a fitness room.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);

    UPDATE Room SET functionality = 'Squash' WHERE room_id = 1;

    --Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The room is not a fitness room.';

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate);

END;
GO

/**
* T-03
* An employee cannot be assigned to a fitness room when they are already assigned to a fitness room at that time.
*
* Expects
*   - Exception: 'The employee has already been assigned at this time to a fitness room.'
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test if an employee cannot be assigned when they are already assigned to a fitness room at that time.];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test if an employee cannot be assigned when they are already assigned to a fitness room at that time.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);

    DECLARE @startDate2 datetime = DATEADD(HOUR, -1, DATEADD(WEEK, 1, GETDATE()));
    DECLARE @endDate2 datetime = DATEADD(HOUR, 3, @startDate2);

    INSERT INTO dbo.FitnessRoomSchedule (employee_id, start_timestamp, end_timestamp) VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', @startDate2, @endDate2)

    --Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The employee has already been assigned at this time to a fitness room.';

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate);

END;
GO

/**
* T-04
* An employee cannot be assigned to a fitness room when they give a group class at that time.
*
* Expects
*   - Exception: 'The employee has already been assigned at this time to a fitness room.'
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test if an employee cannot be assigned when they give a group class at that time.];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test if an employee cannot be assigned when they give a group class at that time.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);

    DECLARE @startDate2 datetime = DATEADD(HOUR, -1, DATEADD(WEEK, 1, GETDATE()));
    DECLARE @endDate2 datetime = DATEADD(HOUR, 3, @startDate2);

    INSERT INTO dbo.GroupClass (employee_id, start_timestamp, end_timestamp) VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', @startDate2, @endDate2)

    --Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The employee is already assigned to a group class at this time.';

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate);

END;
GO

/**
* T-05
* An employee cannot be assigned to a fitness room when don't have the role 'Employee'
*
* Expects
*   - Exception: 'The employee does not have the role Employee.'
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test if an employee cannot be assigned to a fitness room when do not have the role Employee.];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test if an employee cannot be assigned to a fitness room when do not have the role Employee.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);

    UPDATE EmployeeRole SET role_name = 'Roster maker' WHERE employee_id = 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP';

    --Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The employee does not have the role Employee.';

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate);

END;
GO

/**
* T-06
* An employee cannot be assigned to a fitness room when another employee is then already assigned to work in the fitness room at that time.
*
* Expects
*   - Exception: 'Another employee is already assigned to work in the fitness room at that time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test if an employee cannot be assigned when another employee is already assigned.];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test if an employee cannot be assigned when another employee is already assigned.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);

    INSERT INTO FitnessRoomSchedule VALUES ('LMNOPQURSTU-987654321012-LMNOPQURSTU', 1, @startDate, @endDate);

    --Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Another employee is already assigned to work in the fitness room at that time.';

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate);

END;
GO

/**
* T-07
* Multiple employees can be assigned to a fitness room.
*
* Expects
*   - The employees are assigned to the room.
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test to verify that multiple employees can be assigned to a fitness room];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test to verify that multiple employees can be assigned to a fitness room]
AS
BEGIN
    --Assemble
    IF OBJECT_ID('[testTriggerFitnessRoomSchedule].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testTriggerFitnessRoomSchedule].[expected]

    SELECT TOP 0 *
    INTO [testTriggerFitnessRoomSchedule].[expected]
    FROM dbo.FitnessRoomSchedule;

    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);
    DECLARE @startDate2 datetime = DATEADD(DAY, 3, GETDATE());
    DECLARE @endDate2 datetime = DATEADD(HOUR, 3, @startDate2);

    INSERT INTO [testTriggerFitnessRoomSchedule].[expected]
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate),
           ('LMNOPQURSTU-987654321012-LMNOPQURSTU', 1, @startDate2, @endDate2);

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate),
                                           ('LMNOPQURSTU-987654321012-LMNOPQURSTU', 1, @startDate2, @endDate2);

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testTriggerFitnessRoomSchedule.expected', 'dbo.FitnessRoomSchedule', '',
         'Tables do not match!';
END;
GO

/**
* T-08
* Multiple employees cannot be assigned to a rooms when one is not a fitness room.
*
* Expects
*   - Exception: 'The room is not a fitness room.'
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test if multiple employees can be assigned while one room is not a fitness room.];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test if multiple employees can be assigned while one room is not a fitness room.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);
    DECLARE @startDate2 datetime = DATEADD(DAY, 3, GETDATE());
    DECLARE @endDate2 datetime = DATEADD(HOUR, 3, @startDate2);

    INSERT INTO Room (room_id, functionality) VALUES (2, 'Squash')

    --Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The room is not a fitness room.';

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate),
                                           ('LMNOPQURSTU-987654321012-LMNOPQURSTU', 2, @startDate2, @endDate2);

END;
GO

/**
* T-09
* Multiple employees cannot be assigned to a fitness room when one is already assigned to a fitness room at that time.
*
* Expects
*   - Exception: 'The employee has already been assigned at this time to a fitness room.'
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test if multiple employees cannot be assigned when one is already assigned to a fitness room at that time.];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test if multiple employees cannot be assigned when one is already assigned to a fitness room at that time.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);
    DECLARE @startDate2 datetime = DATEADD(DAY, 3, GETDATE());
    DECLARE @endDate2 datetime = DATEADD(HOUR, 3, @startDate2);

    DECLARE @startDateTest datetime = DATEADD(HOUR, -1, DATEADD(WEEK, 1, GETDATE()));
    DECLARE @endDateTest datetime = DATEADD(HOUR, 3, @startDateTest);

    INSERT INTO dbo.FitnessRoomSchedule (employee_id, start_timestamp, end_timestamp) VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', @startDateTest, @endDateTest)

    --Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The employee has already been assigned at this time to a fitness room.';

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate),
                                           ('LMNOPQURSTU-987654321012-LMNOPQURSTU', 1, @startDate2, @endDate2);

END;
GO

/**
* T-10
* Multiple employees cannot be assigned to a fitness room when one gives a group class at that time.
*
* Expects
*   - Exception: 'The employee has already been assigned at this time to a fitness room.'
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test if multiple employees cannot be assigned when one gives a group class at that time.];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test if multiple employees cannot be assigned when one gives a group class at that time.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);
    DECLARE @startDate2 datetime = DATEADD(DAY, 3, GETDATE());
    DECLARE @endDate2 datetime = DATEADD(HOUR, 3, @startDate2);

    DECLARE @startDateGC datetime = DATEADD(HOUR, -1, DATEADD(WEEK, 1, GETDATE()));
    DECLARE @endDateGC datetime = DATEADD(HOUR, 3, @startDateGC);

    INSERT INTO dbo.GroupClass (employee_id, start_timestamp, end_timestamp) VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', @startDateGC, @endDateGC)

    --Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The employee is already assigned to a group class at this time.';

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate),
                                           ('LMNOPQURSTU-987654321012-LMNOPQURSTU', 1, @startDate2, @endDate2);

END;
GO

/**
* T-11
* Multiple employees cannot be assigned to a fitness room when one of them doesn't have the role 'Employee'
*
* Expects
*   - Exception: 'The employee does not have the role Employee.'
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test if multiple employees cannot be assigned to a fitness room when one does not have the role Employee.];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test if multiple employees cannot be assigned to a fitness room when one does not have the role Employee.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);
    DECLARE @startDate2 datetime = DATEADD(DAY, 3, GETDATE());
    DECLARE @endDate2 datetime = DATEADD(HOUR, 3, @startDate2);

    UPDATE EmployeeRole SET role_name = 'Roster maker' WHERE employee_id = 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP';

    --Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The employee does not have the role Employee.';

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate),
                                           ('LMNOPQURSTU-987654321012-LMNOPQURSTU', 1, @startDate2, @endDate2);
END;
GO

/**
* T-12
* Multiple employees cannot be assigned to a fitness room when another employee is then already assigned to work in the fitness room at that time.
*
* Expects
*   - Exception: 'Another employee is already assigned to work in the fitness room at that time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerFitnessRoomSchedule].[test if multiple employees cannot be assigned when another employee is already assigned.];
GO
CREATE PROCEDURE [testTriggerFitnessRoomSchedule].[test if multiple employees cannot be assigned when another employee is already assigned.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 3, @startDate);
    DECLARE @startDate2 datetime = DATEADD(DAY, 3, GETDATE());
    DECLARE @endDate2 datetime = DATEADD(HOUR, 3, @startDate2);

    INSERT INTO FitnessRoomSchedule VALUES ('LMNOPQURSTU-987654321012-LMNOPQURSTU', 1, @startDate, @endDate);

    --Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Another employee is already assigned to work in the fitness room at that time.';

    --Act
    INSERT INTO FitnessRoomSchedule VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @startDate, @endDate),
                                           ('LMNOPQURSTU-987654321012-LMNOPQURSTU', 1, @startDate2, @endDate2);
END;
GO

