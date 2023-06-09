EXEC [tSQLt].[NewTestClass] 'testViewGroupClass'
GO

/*
* T-01
* Test if a member can view their sign ins for group classes.
*
* Expects
*   - The member's sign ins for group classes.
*/
DROP PROCEDURE IF EXISTS testViewGroupClass.[test if a member can view their sign ins for group classes.]
GO
CREATE PROCEDURE testViewGroupClass.[test if a member can view their sign ins for group classes.]
AS
BEGIN
    -- Assemble
    IF OBJECT_ID('[testViewGroupClass].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testViewGroupClass].[expected]
    IF OBJECT_ID('[testViewGroupClass].[actual]', 'Table') IS NOT NULL
        DROP TABLE [testViewGroupClass].[actual]

    SELECT TOP 0 GC.class_name, GC.room_id, GC.start_timestamp, end_timestamp, employee_id
    INTO [testViewGroupClass].[expected]
    FROM GroupClass GC
             JOIN MemberGroupClass MGC ON GC.class_name = MGC.class_name AND GC.room_id = MGC.room_id AND
                                          GC.start_timestamp = MGC.start_timestamp

    SELECT TOP 0 GC.class_name, GC.room_id, GC.start_timestamp, end_timestamp, employee_id
    INTO [testViewGroupClass].[actual]
    FROM GroupClass GC
             JOIN MemberGroupClass MGC ON GC.class_name = MGC.class_name AND GC.room_id = MGC.room_id AND
                                          GC.start_timestamp = MGC.start_timestamp

    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'GroupClass'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'MemberGroupClass'

    DECLARE @start_timestamp1 datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @start_timestamp2 datetime = DATEADD(DAY, 3, GETDATE());

    INSERT INTO Member (member_id) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK');
    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp, employee_id)
    VALUES ('Yoga', 2, @start_timestamp1, DATEADD(HOUR, 1, @start_timestamp1), 'LMNOPQRST-123456789012-LMNOPQRST'),
           ('Dance', 3, @start_timestamp2, DATEADD(HOUR, 1, @start_timestamp2), 'LMNOPQRST-123456789012-LMNOPQRST');
    INSERT INTO MemberGroupClass(member_id, class_name, room_id, start_timestamp)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @start_timestamp1),
           ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, @start_timestamp2);

    INSERT INTO [testViewGroupClass].[expected] (class_name, room_id, start_timestamp, end_timestamp, employee_id)
    VALUES ('Yoga', 2, @start_timestamp1, DATEADD(HOUR, 1, @start_timestamp1), 'LMNOPQRST-123456789012-LMNOPQRST'),
           ('Dance', 3, @start_timestamp2, DATEADD(HOUR, 1, @start_timestamp2), 'LMNOPQRST-123456789012-LMNOPQRST');
    --Act
    INSERT INTO [testViewGroupClass].[actual]
        EXEC sproc_viewGroupClass 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK'

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testViewGroupClass.expected', 'testViewGroupClass.actual', '',
         'Tables do not match!';
END
GO


/*
* T-02
* Test if a non-existing member cannot view their sign ins for group classes.
*
* Expects
*   - Exception: 'Error occurred in sproc ''sproc_viewGroupClass''. Original message: ''This member does not exist.'''
*/
DROP PROCEDURE IF EXISTS testViewGroupClass.[test if a non-existing member cannot view their sign ins for group classes.]
GO
CREATE PROCEDURE testViewGroupClass.[test if a non-existing member cannot view their sign ins for group classes.]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'

    -- Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessage = 'Error occurred in sproc ''sproc_viewGroupClass''. Original message: ''This member does not exist.'''

    -- Act
    EXEC sproc_viewGroupClass 'ABCDEFGHIJK-123456789012'
END
GO