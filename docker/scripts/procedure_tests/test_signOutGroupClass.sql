EXEC [tSQLt].[NewTestClass] 'testSignOutGroupClass'
GO

DROP PROCEDURE IF EXISTS testSignOutGroupClass.[Setup]
GO
CREATE PROCEDURE testSignOutGroupClass.[Setup]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'MemberGroupClass'

    INSERT INTO Member (member_id) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK');
END
GO

/*
* T-01
* Test if a member can sign out of a group class.
*
* Expects
*   - The member is signed out of the group class.
*/
CREATE OR ALTER PROC testSignOutGroupClass.[test if a member can sign out of a group class.]
AS
BEGIN
    -- Assemble
    DECLARE @dateGroupClass datetime = DATEADD(week, 1, GETDATE())
    INSERT INTO MemberGroupClass (member_id, class_name, room_id, start_timestamp) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 1, @dateGroupClass)

    -- Expect
    EXEC [tSQLt].[ExpectNoException]

    -- Act
    EXEC sproc_signOutGroupClass 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 1, @dateGroupClass
END
GO

/*
* T-02
* Test if a member cannot sign out of a group class that they are not registered for.
*
* Expects
*   - Exception: 'The member is not registered for this group class.'
*/
CREATE OR ALTER PROC testSignOutGroupClass.[test if a member cannot sign out of a group class that they are not registered for.]
AS
BEGIN
    -- Assemble
    DECLARE @dateGroupClass datetime = DATEADD(week, 1, GETDATE())

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_signOutGroupClass''. Original message: ''The member is not registered for this group class.'''

    -- Act
    EXEC sproc_signOutGroupClass 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 1, @dateGroupClass
END
GO

/*
* T-03
* Test if a member cannot sign out of a group class that has started.
*
* Expects
*   - Exception: 'The member cannot sign out once the group class has started.'
*/
CREATE OR ALTER PROC testSignOutGroupClass.[test if a member cannot sign out of a group class that has started.]
AS
BEGIN
    -- Assemble
    DECLARE @dateGroupClass datetime = DATEADD(week, -1, GETDATE())
    INSERT INTO MemberGroupClass (member_id, class_name, room_id, start_timestamp) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 1, @dateGroupClass)

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_signOutGroupClass''. Original message: ''The member cannot sign out once the group class has started.'''

    -- Act
    EXEC sproc_signOutGroupClass 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 1, @dateGroupClass
END
GO
