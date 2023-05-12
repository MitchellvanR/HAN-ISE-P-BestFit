-- US-24 Add member
EXEC [tSQLt].[NewTestClass] 'testAddMember'
GO

CREATE OR ALTER PROC testAddMember.[test if a member can be added and get a subscription correctly.]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member', @Identity = 1
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'
    EXEC tSQLt.SpyProcedure @ProcedureName = 'sproc_subscribeMember'

    EXEC [tSQLt].[ExpectNoException]
    EXEC sproc_addMember 'Maartje', 'Westerman', NULL, 'boo@gmail.nl', '2004-08-20', NULL, NULL, NULL, NULL, NULL, 'ALL', '2023-06-09'
END
GO

CREATE OR ALTER PROC testAddMember.[test if an underage member can't be added without guardian information.]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member', @Identity = 1
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'
    EXEC tSQLt.SpyProcedure @ProcedureName = 'sproc_subscribeMember'

    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occured in sproc ''sproc_addMember''. Original message: ''The guardian their first name, last name, email and birthdate are required.'''
    EXEC sproc_addMember 'Linda', 'Westerman', NULL, 'linda@gmail.nl', '2010-08-30', NULL, NULL, NULL, NULL, NULL, 'ALL', '2023-06-09'
END
GO

CREATE OR ALTER PROC testAddMember.[test if a member can't be added with the same email as someone else.]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member', @Identity = 1
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'
    EXEC tSQLt.SpyProcedure @ProcedureName = 'sproc_subscribeMember'

    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occured in sproc ''sproc_addMember''. Original message: ''There is already a member with that email adres.'''
    INSERT INTO Member (email) VALUES ('existing@member.com');
    EXEC sproc_addMember 'Maartje', 'Westerman', NULL, 'existing@member.com', '2004-08-20', NULL, NULL, NULL, NULL, NULL, 'ALL', '2023-06-09'
END
GO
