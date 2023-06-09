EXEC [tSQLt].[NewTestClass] 'testSignInGroupClass'
GO

DROP PROCEDURE IF EXISTS testSignInGroupClass.[SetUp]
GO
CREATE PROCEDURE [testSignInGroupClass].[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'GroupClassType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'GroupClassTypeSubscriptionType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'MemberGroupClass'

    INSERT INTO Subscription (member_id, type, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult monthly', DATEADD(MONTH, 3, GETDATE()));
    INSERT INTO GroupClassType (class_name, max_participants) VALUES ('Yoga', 10);
    INSERT INTO GroupClassTypeSubscriptionType (class_name, type) VALUES ('Yoga', 'Adult monthly');
END;
GO

/**
* T-01
* A member signs in for a group class.
*
* Expects
*   - The member_id and the group class PK are saved in the table MemberGroupClass.
*/
DROP PROCEDURE IF EXISTS testSignInGroupClass.[test if a member can sign in for a group class.]
GO
CREATE PROCEDURE testSignInGroupClass.[test if a member can sign in for a group class.]
AS
BEGIN
    DECLARE @startDateGroupClass DATETIME = DATEADD(MONTH, 1, GETDATE())
    EXEC [tSQLt].[ExpectNoException]
    EXEC sproc_signInGroupClass 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDateGroupClass ;
END
GO

/**
* T-02
* A member signs in for a group class that has already happened.
*
* Expects
*   - Exception: 'It is too late to sign up for this group class.'
*/
DROP PROCEDURE IF EXISTS testSignInGroupClass.[test if a member can't sign in for a group class that already happened.]
GO
CREATE PROCEDURE testSignInGroupClass.[test if a member can't sign in for a group class that already happened.]
AS
BEGIN
    DECLARE @startDateGroupClass DATETIME = DATEADD(MONTH, -1, GETDATE())
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_signInGroupClass''. Original message: ''It is too late to sign up for this group class.''';
    EXEC sproc_signInGroupClass 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDateGroupClass ;
END
GO

