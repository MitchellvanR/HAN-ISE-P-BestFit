EXEC tSQLt.NewTestClass 'testTriggerGroupClass';
GO

DROP PROCEDURE IF EXISTS testTriggerGroupClass.[SetUp]
GO
CREATE PROCEDURE testTriggerGroupClass.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'GroupClass'
END
GO


/**
* T-01
* An employee attempts to schedule a valid group class.
*
* Expects
*   - The group class is saved in the GroupClass table.
*/
DROP PROCEDURE IF EXISTS [testTriggerGroupClass].[test to verify that a valid group class gets through trigger checks]
GO
CREATE PROCEDURE [testTriggerGroupClass].[test to verify that a valid group class gets through trigger checks]
AS
BEGIN
    --Assemble
    IF OBJECT_ID('[testTriggerGroupClass].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testTriggerGroupClass].[expected]

    SELECT TOP 0 *
    INTO [testTriggerGroupClass].[expected]
    FROM dbo.GroupClass;

    INSERT INTO [testTriggerGroupClass].[expected]
    VALUES ('DanceA', 2, '2023-05-09 17:44:30', 1, '2023-05-09 18:44:30')

    INSERT INTO [testTriggerGroupClass].[expected]
    VALUES ('DanceA', 2, '2023-05-09 19:44:30', 1, '2023-05-09 20:44:30'),
           ('DanceA', 2, '2023-05-09 21:44:30', 1, '2023-05-09 22:44:30')

    EXEC tSQLt.FakeTable 'dbo', 'EmployeeGroupClassType';
    INSERT INTO dbo.EmployeeGroupClassType VALUES (1, 'DanceA')

    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO dbo.Room VALUES (2, 'GroupClass', 8)


    EXEC [tSQLt].[ApplyTrigger] @TableName = 'dbo.GroupClass',
         @TriggerName = 'trg_GroupClass_insertUpdate'

    --Act
    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 2, '2023-05-09 17:44:30', 1, '2023-05-09 18:44:30')

    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 2, '2023-05-09 19:44:30', 1, '2023-05-09 20:44:30'),
           ('DanceA', 2, '2023-05-09 21:44:30', 1, '2023-05-09 22:44:30')

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testTriggerGroupClass.expected', 'dbo.GroupClass', '',
         'Tables do not match!';
END;
GO

/**
* T-02
* An employee that is not qualified to teach a specific kind of class is selected as its instructor.
*
* Expects
*   - Exception: 'This employee is not qualified to teach the selected class.'
*/
DROP PROCEDURE IF EXISTS [testTriggerGroupClass].[test to verify that data does not get inserted because employee isn't qualified to teach class]
GO
CREATE PROCEDURE [testTriggerGroupClass].[test to verify that data does not get inserted because employee isn't qualified to teach class]
AS
BEGIN
    --Assemble
    EXEC tSQLt.FakeTable 'dbo', 'EmployeeGroupClassType';
    INSERT INTO dbo.EmployeeGroupClassType VALUES (1, 'YogaB')

    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO dbo.Room VALUES (2, 'GroupClass', 8)


    EXEC [tSQLt].[ApplyTrigger] @TableName = 'dbo.GroupClass',
         @TriggerName = 'trg_GroupClass_insertUpdate'

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'This employee is not qualified to teach the selected class.'

    --Act
    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 2, '2023-05-09 17:44:30', 1, '2023-05-09 18:44:30')
END;
GO

/**
* T-03
* An employee attempts to schedule a group class in a room that is not suitable for group classes.
*
* Expects
*   - Exception: 'This room is not suitable for group classes.'
*/
DROP PROCEDURE IF EXISTS [testTriggerGroupClass].[test to verify that data does not get inserted because room isn't suitable for group classes]
GO
CREATE PROCEDURE [testTriggerGroupClass].[test to verify that data does not get inserted because room isn't suitable for group classes]
AS
BEGIN
    --Assemble
    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO dbo.Room VALUES (2, 'Fitness', 16)

    EXEC tSQLt.FakeTable 'dbo', 'EmployeeGroupClassType';
    INSERT INTO dbo.EmployeeGroupClassType VALUES (1, 'DanceA')


    EXEC [tSQLt].[ApplyTrigger] @TableName = 'dbo.GroupClass',
         @TriggerName = 'trg_GroupClass_insertUpdate'

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'This room is not suitable for group classes.'

    --Act
    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 2, '2023-05-09 17:44:30', 1, '2023-05-09 18:44:30')
END;
GO

/**
* T-04
* An employee attempts to schedule a group class with an instructor that is not available at the selected time.
*
* Expects
*   - Exception: 'This employee is not available at the selected time.
*/
DROP PROCEDURE IF EXISTS [testTriggerGroupClass].[test to verify that data does not get inserted because employee is not available at the selected time]
GO
CREATE PROCEDURE [testTriggerGroupClass].[test to verify that data does not get inserted because employee is not available at the selected time]
AS
BEGIN
    --Assemble
    EXEC tSQLt.FakeTable 'dbo', 'EmployeeGroupClassType';
    INSERT INTO dbo.EmployeeGroupClassType VALUES (1, 'DanceA')

    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO dbo.Room VALUES (1, 'GroupClass', 8)
    INSERT INTO dbo.Room VALUES (2, 'GroupClass', 8)


    EXEC [tSQLt].[ApplyTrigger] @TableName = 'dbo.GroupClass',
         @TriggerName = 'trg_GroupClass_insertUpdate'
    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 1, '2023-05-09 17:44:30', 1, '2023-05-09 18:44:30')

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'This employee is not available at the selected time.'

    --Act
    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 2, '2023-05-09 16:44:30', 1, '2023-05-09 18:44:30')
END;
GO

/**
* T-05
* An employee attempts to schedule a group class in a room that is not available at the selected time
*
* Expects
*   - Error: 'This room is not available at the selected time'
*/

CREATE OR ALTER PROCEDURE [testTriggerGroupClass].[test to verify that data does not get inserted because room is not available at the selected time]
AS
BEGIN
    --Assemble
    EXEC tSQLt.FakeTable 'dbo', 'EmployeeGroupClassType';
    INSERT INTO dbo.EmployeeGroupClassType VALUES (1, 'DanceA')
    INSERT INTO dbo.EmployeeGroupClassType VALUES (2, 'DanceA')

    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO dbo.Room VALUES (2, 'GroupClass', 8)


    EXEC [tSQLt].[ApplyTrigger] @TableName = 'dbo.GroupClass',
         @TriggerName = 'trg_GroupClass_insertUpdate'
    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 2, '2023-05-09 17:44:30', 1, '2023-05-09 18:44:30')

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'This room is not available at the selected time.'

    --Act
    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 2, '2023-05-09 16:44:30', 2, '2023-05-09 18:44:30')
END;
GO

/**
* T-06
* An employee that is not qualified to teach a specific kind of class is selected as its instructor in a batch insert.
*
* Expects
*   - Exception: 'This employee is not qualified to teach the selected class.'
*/
DROP PROCEDURE IF EXISTS [testTriggerGroupClass].[test to verify that batches of data do not get inserted because employee isn't qualified to teach class]
GO
CREATE PROCEDURE [testTriggerGroupClass].[test to verify that batches of data do not get inserted because employee isn't qualified to teach class]
AS
BEGIN
    --Assemble
    EXEC tSQLt.FakeTable 'dbo', 'EmployeeGroupClassType';
    INSERT INTO dbo.EmployeeGroupClassType VALUES (1, 'YogaB')

    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO dbo.Room VALUES (2, 'GroupClass', 8)


    EXEC [tSQLt].[ApplyTrigger] @TableName = 'dbo.GroupClass',
         @TriggerName = 'trg_GroupClass_insertUpdate'

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'This employee is not qualified to teach the selected class.'

    --Act
    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 2, '2023-05-09 17:44:30', 1, '2023-05-09 18:44:30'),
           ('DanceA', 2, '2023-05-09 19:44:30', 1, '2023-05-09 20:44:30')
END;
GO

/**
* T-07
* An employee attempts to schedule a group class in a room that is not suitable for group classes in a batch insert.
*
* Expects
*   - Exception: 'This room is not suitable for group classes.'
*/
DROP PROCEDURE IF EXISTS [testTriggerGroupClass].[test to verify that batches of data do not get inserted because room isn't suitable for group classes]
GO
CREATE PROCEDURE [testTriggerGroupClass].[test to verify that batches of data do not get inserted because room isn't suitable for group classes]
AS
BEGIN
    --Assemble
    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO dbo.Room VALUES (2, 'Fitness', 16)

    EXEC tSQLt.FakeTable 'dbo', 'EmployeeGroupClassType';
    INSERT INTO dbo.EmployeeGroupClassType VALUES (1, 'DanceA')


    EXEC [tSQLt].[ApplyTrigger] @TableName = 'dbo.GroupClass',
         @TriggerName = 'trg_GroupClass_insertUpdate'

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'This room is not suitable for group classes.'

    --Act
    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 2, '2023-05-09 17:44:30', 1, '2023-05-09 18:44:30'),
           ('DanceA', 2, '2023-05-09 19:44:30', 1, '2023-05-09 20:44:30')
END;
GO

/**
* T-08
* An employee attempts to schedule a group class with an instructor that is not available at the selected time in a batch insert.
*
* Expects
*   - Exception: 'This employee is not available at the selected time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerGroupClass].[test to verify that batches data of do not get inserted because employee is not available at the selected time]
GO
CREATE PROCEDURE [testTriggerGroupClass].[test to verify that batches data of do not get inserted because employee is not available at the selected time]
AS
BEGIN
    --Assemble
    EXEC tSQLt.FakeTable 'dbo', 'EmployeeGroupClassType';
    INSERT INTO dbo.EmployeeGroupClassType VALUES (1, 'DanceA')

    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO dbo.Room VALUES (1, 'GroupClass', 8)
    INSERT INTO dbo.Room VALUES (2, 'GroupClass', 8)


    EXEC [tSQLt].[ApplyTrigger] @TableName = 'dbo.GroupClass',
         @TriggerName = 'trg_GroupClass_insertUpdate'

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'This employee is not available at the selected time.'

    --Act
    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 1, '2023-05-09 17:44:30', 1, '2023-05-09 18:44:30'),
           ('DanceA', 2, '2023-05-09 16:44:30', 1, '2023-05-09 18:44:30')
END;
GO

/**
* T-09
* An employee attempts to schedule a group class with a room that is not available at the selected time in a batch insert.
*
* Expects
*   - Error: 'This room is not available at the selected time'
*/
CREATE OR ALTER PROCEDURE [testTriggerGroupClass].[test to verify that batches of data do not get inserted because room is not available at the selected time]
AS
BEGIN
    --Assemble
    EXEC tSQLt.FakeTable 'dbo', 'EmployeeGroupClassType';
    INSERT INTO dbo.EmployeeGroupClassType VALUES (1, 'DanceA')
    INSERT INTO dbo.EmployeeGroupClassType VALUES (2, 'DanceA')

    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO dbo.Room VALUES (2, 'GroupClass', 8)


    EXEC [tSQLt].[ApplyTrigger] @TableName = 'dbo.GroupClass',
         @TriggerName = 'trg_GroupClass_insertUpdate'


    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'This room is not available at the selected time.'

    --Act
    INSERT INTO dbo.GroupClass
    VALUES ('DanceA', 2, '2023-05-09 17:44:30', 1, '2023-05-09 18:44:30'),
           ('DanceA', 2, '2023-05-09 16:44:30', 2, '2023-05-09 18:44:30')
END;
GO