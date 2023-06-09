EXEC tSQLt.NewTestClass 'testScheduleGroupClass';
GO

DROP PROCEDURE IF EXISTS testScheduleGroupClass.[SetUp]
GO
CREATE PROCEDURE testScheduleGroupClass.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'GroupClass'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'EmployeeGroupClassType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Room'
END
GO


/**
* T-01
* An employee attempts to schedule a valid group class.
*
* Expects
*   - The group class is saved in the GroupClass table.
*/
DROP PROCEDURE IF EXISTS [testScheduleGroupClass].[test to verify that a valid group class gets inserted correctly]
GO
CREATE PROCEDURE [testScheduleGroupClass].[test to verify that a valid group class gets inserted correctly]
AS
BEGIN
    --Assemble
    INSERT INTO dbo.EmployeeGroupClassType
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'DanceA')

    INSERT INTO dbo.Room
    VALUES (2, 'GroupClass', 8)

    --Expect
    EXEC [tSQLt].[ExpectNoException]

    --Act
    EXEC sproc_ScheduleGroupClass 'DanceA', 2, '2023-05-09 17:44:30', 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', '2023-05-09 18:44:30'
END


/**
* T-02
* An employee attempts to schedule a group class with an instructor that doesn't exist.
*
* Expects
*   - Exception like: '%The INSERT statement conflicted with the FOREIGN KEY constraint%'
*/
DROP PROCEDURE IF EXISTS [testScheduleGroupClass].[test if an employee that doesn't exist can be assigned as an instructor]
GO
CREATE PROCEDURE [testScheduleGroupClass].[test if an employee that doesn't exist can be assigned as an instructor]
AS
BEGIN
    --Assemble
    INSERT INTO dbo.Room VALUES (2, 'GroupClass', 8)
    EXEC tSQLt.ApplyConstraint 'dbo.GroupClass', 'fk_groupclass_employee'

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessagePattern = '%The INSERT statement conflicted with the FOREIGN KEY constraint%'

    --Act
    EXEC sproc_ScheduleGroupClass 'DanceA', 2, '2023-05-09 17:44:30', 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', '2023-05-09 18:44:30'
END

/**
* T-03
* An employee attempts to schedule a group class in a room that doesn't exist.
*
* Expects
*   - Exception like: '%The INSERT statement conflicted with the FOREIGN KEY constraint%'
*/
DROP PROCEDURE IF EXISTS [testScheduleGroupClass].[test if a room that doesn't exist can be assigned as a group class room]
GO
CREATE PROCEDURE [testScheduleGroupClass].[test if a room that doesn't exist can be assigned as a group class room]
AS
BEGIN
    --Assemble
    INSERT INTO dbo.EmployeeGroupClassType
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'DanceA')

    EXEC tSQLt.ApplyConstraint 'dbo.GroupClass', 'fk_groupcla_group_cla_room'

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessagePattern = '%The INSERT statement conflicted with the FOREIGN KEY constraint%'

    --Act
    EXEC sproc_ScheduleGroupClass 'DanceA', 2, '2023-05-09 17:44:30', 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', '2023-05-09 18:44:30'
END

/**
* T-04
* An employee attempts to schedule a group class of a type that doesn't exist.
*
* Expects
*   - Exception like: '%The INSERT statement conflicted with the FOREIGN KEY constraint%'
*/
DROP PROCEDURE IF EXISTS [testScheduleGroupClass].[test if a group class can be scheduled for a class type that doesn't exist]
GO
CREATE PROCEDURE [testScheduleGroupClass].[test if a group class can be scheduled for a class type that doesn't exist]
AS
BEGIN
    --Assemble
    INSERT INTO dbo.EmployeeGroupClassType
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'DanceA')

    INSERT INTO dbo.Room
    VALUES (2, 'GroupClass', 8)

    EXEC tSQLt.ApplyConstraint 'dbo.GroupClass', 'fk_groupcla_group_cla_groupcla'

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessagePattern = '%The INSERT statement conflicted with the FOREIGN KEY constraint%'

    --Act
    EXEC sproc_ScheduleGroupClass 'DanceA', 2, '2023-05-09 17:44:30', 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', '2023-05-09 18:44:30'
END
GO