EXEC [tSQLt].[NewTestClass] 'testAssignEmployee'
GO

DROP PROCEDURE IF EXISTS testAssignEmployee.[SetUp]
GO
CREATE PROCEDURE testAssignEmployee.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'EmployeeRole'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'FitnessRoomSchedule'

    INSERT INTO EmployeeRole (employee_id, role_name) VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 'Employee');
END
GO

/*
* T-01
* Test if an employee can be assigned to a fitness room.
*
* Expects
*   - The employee is assigned to the fitness room.
*/
DROP PROCEDURE IF EXISTS testAssignEmployee.[test if an employee can be assigned to a fitness room.]
GO
CREATE PROCEDURE testAssignEmployee.[test if an employee can be assigned to a fitness room.]
AS
BEGIN
    -- Assemble
    DECLARE @start_timestamp datetime = DATEADD(WEEK, 1, GETDATE())
    DECLARE @end_timestamp datetime = DATEADD(HOUR, 3, @start_timestamp)

    -- Expect
    EXEC [tSQLt].[ExpectNoException]

    -- Act
    EXEC sproc_assignEmployee 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @start_timestamp,  @end_timestamp
END
GO

/*
* T-02
* Test if an employee cannot be assigned to a fitness room in the past.
*
* Expects
*   - Exception: 'The date and time of the shift is in the past.'
*/
DROP PROCEDURE IF EXISTS testAssignEmployee.[test if an employee cannot be assigned to a fitness room in the past.]
GO
CREATE PROCEDURE testAssignEmployee.[test if an employee cannot be assigned to a fitness room in the past.]
AS
BEGIN
    -- Assemble
    DECLARE @start_timestamp datetime = DATEADD(WEEK, -1, GETDATE())
    DECLARE @end_timestamp datetime = DATEADD(HOUR, 3, @start_timestamp)

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_assignEmployee''. Original message: ''The date and time of the shift is in the past.'''

    -- Act
    EXEC sproc_assignEmployee 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, @start_timestamp,  @end_timestamp
END
GO