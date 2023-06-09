EXEC tSQLt.NewTestClass 'testCancelGroupClass';
GO

DROP PROCEDURE IF EXISTS testCancelGroupClass.[SetUp];
GO
CREATE PROCEDURE testCancelGroupClass.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Employee'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Room'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'GroupClass'

    INSERT INTO Employee (employee_id, first_name, last_name)
    VALUES ('ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 'John', 'Doe')
    INSERT INTO Room (room_id, functionality, max_people)
    VALUES (3, 'GroupClass', 20)
    INSERT INTO GroupClass (class_name, room_id, start_timestamp, employee_id, end_timestamp)
    VALUES ('Yoga', 3, '2023-05-30 12:00:00.000', 'ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', '2023-05-30 13:00:00.000');

END
GO

/*
* T-01
* An employee cancels a group class successfully.
*
* Expects
*   - This action gives no error. The group class is cancelled successfully.
*/
DROP PROCEDURE IF EXISTS testCancelGroupclass.[test if a group class can be cancelled successfully]
GO
CREATE PROCEDURE testCancelGroupClass.[test if a group class can be cancelled successfully]
AS
BEGIN
    -- Assemble
    SELECT TOP 0 *
    INTO [testCancelGroupClass].[expected]
    FROM dbo.GroupClass;

    -- Act
    EXEC sproc_cancelGroupClass 'ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 'Yoga', 3, '2023-05-30 12:00:00.000';

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testCancelGroupClass.expected', 'GroupClass'
END
GO

/*
* T-02
* An employee cancels a group class with the wrong room_id.
*
* Expects
*   - This action gives the error: Error occured in sproc sproc_cancelGroupClass. Original message: De room_id and/or the starttime of the group class does not match. The group class is not cancelled.
*/
DROP PROCEDURE IF EXISTS testCancelGroupclass.[test if a group class can't be cancelled when the room_id does not match]
GO
CREATE PROCEDURE testCancelGroupClass.[test if a group class can't be cancelled when the room_id does not match]
AS
BEGIN
    -- Assemble
    SELECT TOP 0 *
    INTO [testCancelGroupClass].[expected]
    FROM dbo.GroupClass;

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_cancelGroupClass''. Original message: ''De room_id and/or the starttime of the group class does not match'''

    -- Act
    EXEC sproc_cancelGroupClass 'ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 'Yoga', 1, '2023-05-30 12:00:00.000';
END
GO

/*
* T-03
* An employee cancels a group class where the start_timestamp doesn't match.
*
* Expects
*   - This action gives the error: De room_id and/or the starttime of the group class does not match. The group class is not cancelled.
*/
DROP PROCEDURE IF EXISTS testCancelGroupclass.[test if a group class can't be cancelled when the start_timestamp does't match]
GO
CREATE PROCEDURE testCancelGroupClass.[test if a group class can't be cancelled when the start_timestamp does't match]
AS
BEGIN
    -- Assemble
    SELECT TOP 0 *
    INTO [testCancelGroupClass].[expected]
    FROM dbo.GroupClass;

    INSERT INTO [testCancelGroupClass].[expected] (class_name, room_id, start_timestamp, employee_id, end_timestamp)
    VALUES ('Yoga', 3, '2023-05-30 12:00:00.000', 'ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', '2023-05-30 13:00:00.000');

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_cancelGroupClass''. Original message: ''De room_id and/or the starttime of the group class does not match'''

    -- Act
    EXEC sproc_cancelGroupClass 'ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 'Yoga', 3, '2023-05-31 13:10:00.000';
END
GO

/*
* T-04
* An employee cancels a group class which doesn't exist.
*
* Expects
*   - This action gives the error: Error occured in sproc sproc_cancelGroupClass. Original message: De employee_id and/or the group class name does not match. The group class is not cancelled.
*/
DROP PROCEDURE IF EXISTS testCancelGroupclass.[test if a non-existing group class can't be cancelled]
GO
CREATE PROCEDURE testCancelGroupClass.[test if a non-existing group class can't be cancelled]
AS
BEGIN
    -- Assemble
    SELECT TOP 0 *
    INTO [testCancelGroupClass].[expected]
    FROM dbo.GroupClass;

    INSERT INTO [testCancelGroupClass].[expected] (class_name, room_id, start_timestamp, employee_id, end_timestamp)
    VALUES ('Yoga', 3, '2023-05-30 12:00:00.000', 'ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', '2023-05-30 13:00:00.000');

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_cancelGroupClass''. Original message: ''De employee_id and/or the group class name does not match'''
    -- Act
    EXEC sproc_cancelGroupClass 'ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 'Dance', 3, '2023-05-30 12:00:00.000';
END
GO

/*
* T-05
* An employee cancels a group class with the wrong teacher_id who doesn't match.
*
* Expects
*   - This action gives the error: Error occured in sproc sproc_cancelGroupClass. Original message: De employee_id and/or the group class name does not match. The group class is not cancelled.
*/
DROP PROCEDURE IF EXISTS testCancelGroupclass.[test if a group class can't be cancelled when the teacher does not match]
GO
CREATE PROCEDURE testCancelGroupClass.[test if a group class can't be cancelled when the teacher does not match]
AS
BEGIN
    -- Assemble
    SELECT TOP 0 *
    INTO [testCancelGroupClass].[expected]
    FROM dbo.GroupClass;

    INSERT INTO [testCancelGroupClass].[expected] (class_name, room_id, start_timestamp, employee_id, end_timestamp)
    VALUES ('Yoga', 3, '2023-05-30 12:00:00.000', 'ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', '2023-05-30 13:00:00.000');

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_cancelGroupClass''. Original message: ''De employee_id and/or the group class name does not match'''

    -- Act
    EXEC sproc_cancelGroupClass 'YYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 'Yoga', 3, '2023-05-30 12:00:00.000';
END
GO