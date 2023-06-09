EXEC [tSQLt].[NewTestClass] 'testEditGroupClass'
GO

DROP PROCEDURE IF EXISTS testEditGroupClass.SetUp
GO
CREATE PROCEDURE testEditGroupClass.SetUp
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'GroupClass';
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Room';
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Employee';
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'EmployeeGroupClassType';

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, employee_id, end_timestamp) VALUES ('Zumba', 1, '2023-05-22 15:00', 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', '2023-05-22 16:00');
    INSERT INTO Room (room_id, functionality, max_people) VALUES (1, 'GroupClass', 20);
    INSERT INTO Employee (employee_id, first_name, last_name) VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 'John', 'Doe');
    INSERT INTO EmployeeGroupClassType (employee_id, class_name) VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 'Zumba');
END
GO

/*
* T-01
* Test if the class_name of a GroupClass gets edited without complications.
*
* Expects
*   - The new class_name is 'Yoga' instead of 'Zumba'.
*/
DROP PROCEDURE IF EXISTS  testEditGroupClass.[test to verify that title gets updated correctly]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that title gets updated correctly]
AS
BEGIN
    -- Assemble
    DECLARE @expected varchar(50);
    DECLARE @actual varchar(50);

    SET @expected = 'Yoga';

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', 'Yoga', 1, '2023-05-22 15:00', 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', '2023-05-22 16:00';
    SELECT @actual = class_name FROM GroupClass WHERE room_id=1 AND start_timestamp='2023-05-22 15:00';

    -- Assert
    EXEC tSQLt.assertEqualsString @expected, @actual;
END
GO

/*
* T-02
* Test if the room_id of a GroupClass gets edited without complications.
*
* Expects
*   - The new room_id is 2 instead of 1.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that room gets updated correctly]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that room gets updated correctly]
AS
BEGIN
    -- Assemble
    INSERT INTO Room (room_id, functionality, max_people) VALUES (2, 'GroupClass', 20);

    DECLARE @expected int;
    DECLARE @actual int;

    SET @expected = 2;

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', 'Zumba', 2, '2023-05-22 15:00', 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', '2023-05-22 16:00';
    SELECT @actual = room_id FROM GroupClass WHERE class_name='Zumba' AND start_timestamp='2023-05-22 15:00';

    -- Assert
    EXEC tSQLt.assertEquals @expected, @actual;
END
GO

/*
* T-03
* Test if the start_timestamp of a GroupClass gets edited without complications.
*
* Expects
*   - The new start_timestamp is '2023-05-22 15:30' instead of '2023-05-22 15:00'.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that start_timestamp gets updated correctly]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that start_timestamp gets updated correctly]
AS
BEGIN
    -- Assemble
    DECLARE @expected datetime;
    DECLARE @actual datetime;

    SET @expected = '2023-05-22 15:30';

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', 'Zumba', 1, '2023-05-22 15:30', 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', '2023-05-22 16:00';
    SELECT @actual = start_timestamp FROM GroupClass WHERE class_name='Zumba' AND room_id=1;

    -- Assert
    EXEC tSQLt.assertEquals @expected, @actual;
END
GO

/*
* T-04
* Test if the employee_id of a GroupClass gets edited without complications.
*
* Expects
*   - The new employee_id is 'ABCDEFGHIJK-123456789098-ABCDEFGHIJK' instead of 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP'.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that employee_id gets updated correctly]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that employee_id gets updated correctly]
AS
BEGIN
    -- Assemble
    INSERT INTO Employee (employee_id, first_name, last_name) VALUES ('ABCDEFGHIJK-123456789098-ABCDEFGHIJK', 'Jane', 'Doe');
    INSERT INTO EmployeeGroupClassType (employee_id, class_name) VALUES ('ABCDEFGHIJK-123456789098-ABCDEFGHIJK', 'Zumba');

    DECLARE @expected varchar(36);
    DECLARE @actual varchar(36);

    SET @expected = 'ABCDEFGHIJK-123456789098-ABCDEFGHIJK';

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', 'Zumba', 1, '2023-05-22 15:00', 'ABCDEFGHIJK-123456789098-ABCDEFGHIJK', '2023-05-22 16:00';
    SELECT @actual = employee_id FROM GroupClass WHERE class_name='Zumba' AND room_id=1 AND start_timestamp='2023-05-22 15:00';

    -- Assert
    EXEC tSQLt.assertEquals @expected, @actual;
END
GO

/*
* T-05
* Test if the end_timestamp of a GroupClass gets edited without complications.
*
* Expects
*   - The new end_timestamp is '2023-05-22 16:30' instead of '2023-05-22 16:00'.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that end_timestamp gets updated correctly]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that end_timestamp gets updated correctly]
AS
BEGIN
    -- Assemble
    DECLARE @expected datetime;
    DECLARE @actual datetime;

    SET @expected = '2023-05-22 16:30';

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', 'Zumba', 1, '2023-05-22 15:00', 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', '2023-05-22 16:30';
    SELECT @actual = end_timestamp FROM GroupClass WHERE class_name='Zumba' AND room_id=1 AND start_timestamp='2023-05-22 15:00';

    -- Assert
    EXEC tSQLt.assertEquals @expected, @actual;
END
GO

/*
* T-06
* Test if the class_name of a GroupClass gets edited without complications when entering NULL values for other parameters.
*
* Expects
*   - The new class_name is 'Yoga' instead of 'Zumba'.
*/
DROP PROCEDURE IF EXISTS  testEditGroupClass.[test to verify that title gets updated correctly when entering NULL values for other parameters]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that title gets updated correctly when entering NULL values for other parameters]
AS
BEGIN
    -- Assemble
    DECLARE @expected varchar(50);
    DECLARE @actual varchar(50);

    SET @expected = 'Yoga';

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', 'Yoga', NULL, NULL, NULL, NULL;
    SELECT @actual = class_name FROM GroupClass WHERE room_id=1 AND start_timestamp='2023-05-22 15:00';

    -- Assert
    EXEC tSQLt.assertEqualsString @expected, @actual;
END
GO

/*
* T-07
* Test if the room_id of a GroupClass gets edited without complications when entering NULL values for other parameters.
*
* Expects
*   - The new room_id is 2 instead of 1.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that room gets updated correctly when entering NULL values for other parameters]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that room gets updated correctly when entering NULL values for other parameters]
AS
BEGIN
    -- Assemble
    INSERT INTO Room (room_id, functionality, max_people) VALUES (2, 'GroupClass', 20);

    DECLARE @expected int;
    DECLARE @actual int;

    SET @expected = 2;

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', NULL, 2, NULL, NULL, NULL;
    SELECT @actual = room_id FROM GroupClass WHERE class_name='Zumba' AND start_timestamp='2023-05-22 15:00';

    -- Assert
    EXEC tSQLt.assertEquals @expected, @actual;
END
GO

/*
* T-08
* Test if the start_timestamp of a GroupClass gets edited without complications when entering NULL values for other parameters.
*
* Expects
*   - The new start_timestamp is '2023-05-22 15:30' instead of '2023-05-22 15:00'.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that start_timestamp gets updated correctly when entering NULL values for other parameters]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that start_timestamp gets updated correctly when entering NULL values for other parameters]
AS
BEGIN
    -- Assemble
    DECLARE @expected datetime;
    DECLARE @actual datetime;

    SET @expected = '2023-05-22 15:30';

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', NULL, NULL, '2023-05-22 15:30', NULL, NULL;
    SELECT @actual = start_timestamp FROM GroupClass WHERE class_name='Zumba' AND room_id=1;

    -- Assert
    EXEC tSQLt.assertEquals @expected, @actual;
END
GO

/*
* T-09
* Test if the employee_id of a GroupClass gets edited without complications when entering NULL values for other parameters.
*
* Expects
*   - The new employee_id is 2 instead of 1.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that employee_id gets updated correctly when entering NULL values for other parameters]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that employee_id gets updated correctly when entering NULL values for other parameters]
AS
BEGIN
    -- Assemble
    INSERT INTO Employee (employee_id, first_name, last_name) VALUES ('ABCDEFGHIJK-123456789098-ABCDEFGHIJK', 'Jane', 'Doe');
    INSERT INTO EmployeeGroupClassType (employee_id, class_name) VALUES ('ABCDEFGHIJK-123456789098-ABCDEFGHIJK', 'Zumba');

    DECLARE @expected varchar(36);
    DECLARE @actual varchar(36);

    SET @expected = 'ABCDEFGHIJK-123456789098-ABCDEFGHIJK';

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', NULL, NULL, NULL, 'ABCDEFGHIJK-123456789098-ABCDEFGHIJK', NULL;
    SELECT @actual = employee_id FROM GroupClass WHERE class_name='Zumba' AND room_id=1 AND start_timestamp='2023-05-22 15:00';

    -- Assert
    EXEC tSQLt.assertEquals @expected, @actual;
END
GO

/*
* T-10
* Test if the end_timestamp of a GroupClass gets edited without complications when entering NULL values for other parameters.
*
* Expects
*   - The new end_timestamp is '2023-05-22 16:30' instead of '2023-05-22 16:00'
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that end_timestamp gets updated correctly when entering NULL values for other parameters]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that end_timestamp gets updated correctly when entering NULL values for other parameters]
AS
BEGIN
    -- Assemble
    DECLARE @expected datetime;
    DECLARE @actual datetime;

    SET @expected = '2023-05-22 16:30';

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', NULL, NULL, NULL, NULL, '2023-05-22 16:30';
    SELECT @actual = end_timestamp FROM GroupClass WHERE class_name='Zumba' AND room_id=1 AND start_timestamp='2023-05-22 15:00';

    -- Assert
    EXEC tSQLt.assertEquals @expected, @actual;
END
GO

/*
* T-11
* Test if the room_id can't be changed into a room id that isn't coupled to an existing room.
*
* Expects
*   - Expects an error message to be thrown informing the user that the chosen room_id does not exist.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that room_id can't be updated to a room_id that isn't coupled to an existing room]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that room_id can't be updated to a room_id that isn't coupled to an existing room]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.ApplyConstraint 'dbo.GroupClass', 'fk_groupcla_group_cla_room';

    -- Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessagePattern = '%The UPDATE statement conflicted with the FOREIGN KEY constraint "fk_groupcla_group_cla_room"%'

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', 'Zumba', 3, '2023-05-22 15:00', 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', '2023-05-22 16:00';
END
GO

/*
* T-12
* Test if the start_timestamp can't be changed into a timestamp that is past the end_timestamp.
*
* Expects
*   - Expects an error message to be thrown informing the user that the start_timestamp can't be past the end_timestamp.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that start_timestamp can't be updated to a start_timestamp that is past the end_timestamp]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that start_timestamp can't be updated to a start_timestamp that is past the end_timestamp]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.ApplyConstraint 'dbo.GroupClass', 'ck_groupclass_start_end';

    -- Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessagePattern = '%The UPDATE statement conflicted with the CHECK constraint "ck_groupclass_start_end"%'

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', 'Zumba', 1, '2023-05-22 17:00', 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', '2023-05-22 16:00';
END
GO

/*
* T-13
* Test if the employee_id can't be changed into a employee_id that isn't registered to an employee.
*
* Expects
*   - Expects an error message to be thrown informing the user that the employee_id isn't registered to an employee.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that employee_id can't be updated to an employee_id that isn't registered to an employee]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that employee_id can't be updated to an employee_id that isn't registered to an employee]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.ApplyConstraint 'dbo.GroupClass', 'fk_groupclass_employee';

    -- Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessagePattern = '%The UPDATE statement conflicted with the FOREIGN KEY constraint "fk_groupclass_employee"%'

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', 'Zumba', 1, '2023-05-22 15:00', 'aaaaaaaaaaaa-000000000000-aaaaaaaaaaaa', '2023-05-22 16:00';
END
GO

/*
* T-14
* Test if the end_timestamp can't be changed into a end_timestamp that is before the start_timestamp.
*
* Expects
*   - Expects an error message to be thrown informing the user that the end_timestamp can't be before the starting time.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that end_timestamp can't be updated to an end_timestamp that is before the start_timestamp]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that end_timestamp can't be updated to an end_timestamp that is before the start_timestamp]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.ApplyConstraint 'dbo.GroupClass', 'ck_groupclass_start_end';

    -- Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessagePattern = '%The UPDATE statement conflicted with the CHECK constraint "ck_groupclass_start_end"%'

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '2023-05-22 15:00', 'Zumba', 1, '2023-05-22 15:00', 'ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', '2023-05-22 14:00';
END
GO

/*
* T-15
* Test if an error is thrown when the class_name was not found.
*
* Expects
*   - Expects an error message to be thrown informing the user that the primary key was not found.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that the identifying class_name has to exist]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that the identifying class_name has to exist]
AS
BEGIN
    -- Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessagePattern = '%No group class with this combination of name, location and starting time was found%'

    -- Act
    EXEC sproc_editGroupClass 'Non-existent-class-name', 1, '2023-05-22 15:00', NULL, NULL, NULL, NULL, NULL;
END
GO

/*
* T-16
* Test if an error is thrown when the room_id was not found.
*
* Expects
*   - Expects an error message to be thrown informing the user that the primary key was not found.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that the identifying room_id has to exist]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that the identifying room_id has to exist]
AS
BEGIN
    -- Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessagePattern = '%No group class with this combination of name, location and starting time was found%'

    -- Act
    EXEC sproc_editGroupClass 'Zumba', -1, '2023-05-22 15:00', NULL, NULL, NULL, NULL, NULL;
END
GO

/*
* T-17
* Test if an error is thrown when the start_timestamp was not found.
*
* Expects
*   - Expects an error message to be thrown informing the user that the primary key was not found.
*/
DROP PROCEDURE IF EXISTS testEditGroupClass.[test to verify that the identifying start_timestamp has to exist]
GO
CREATE PROCEDURE testEditGroupClass.[test to verify that the identifying start_timestamp has to exist]
AS
BEGIN
    -- Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessagePattern = '%No group class with this combination of name, location and starting time was found%'

    -- Act
    EXEC sproc_editGroupClass 'Zumba', 1, '1800-01-01 00:00', NULL, NULL, NULL, NULL, NULL;
END
GO