--US-01 Subscribe Member tests
EXEC [tSQLt].[NewTestClass] 'testSubscribeMember'
GO

CREATE OR ALTER PROC testSubscribeMember.[test if a member can add a subscription]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'

    EXEC [tSQLt].[ExpectNoException]
    INSERT INTO Member (member_id, birthdate) VALUES (1, '2000-01-01');
    INSERT INTO SubscriptionType (type, min_length, min_age, max_age) VALUES ('ALL', 3, 21, NULL);
    EXEC sproc_subscribeMember 1, 'ALL', '2023-06-09'
END
GO

CREATE OR ALTER PROC testSubscribeMember.[test if a member can't add a subscription twice]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'

    EXEC [tSQLt].[ExpectException]
    INSERT INTO Member (member_id, birthdate) VALUES (1, '2000-01-01');
    INSERT INTO SubscriptionType (type, min_length, min_age, max_age) VALUES ('ALL', 3, 21, NULL);
    EXEC sproc_subscribeMember 1, 'ALL', '2023-06-09'
    EXEC sproc_subscribeMember 1, 'ALL', '2023-06-09'
END
GO

CREATE OR ALTER PROC testSubscribeMember.[test if a member can't add a subscription when they're too young]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'

    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occured in sproc ''sproc_subscribeMember''. Original message: ''The member does not fit the subscription due to their age.'''
    INSERT INTO Member (member_id, birthdate) VALUES (1, '2020-01-01');
    INSERT INTO SubscriptionType (type, min_length, min_age, max_age) VALUES ('ALL', 3, 21, NULL);
    EXEC sproc_subscribeMember 1, 'ALL', '2023-06-09'
END
GO

CREATE OR ALTER PROC testSubscribeMember.[test if a member can't add a subscription when they're too old]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'

    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occured in sproc ''sproc_subscribeMember''. Original message: ''The member does not fit the subscription due to their age.'''
    INSERT INTO Member (member_id, birthdate) VALUES (1, '1990-01-01');
    INSERT INTO SubscriptionType (type, min_length, min_age, max_age) VALUES ('ALL', 3, NULL, 21);
    EXEC sproc_subscribeMember 1, 'ALL', '2023-06-09'
END
GO

CREATE OR ALTER PROC testSubscribeMember.[test if a non-existing member can't add a subscription]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'

    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occured in sproc ''sproc_subscribeMember''. Original message: ''This member does not exist.'''
    INSERT INTO SubscriptionType (type, min_length, min_age, max_age) VALUES ('ALL', 3, NULL, 21);
    EXEC sproc_subscribeMember 1, 'ALL', '2023-06-09'
END
GO

CREATE OR ALTER PROC testSubscribeMember.[test if a member can't add a non-existing subscription]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'

    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occured in sproc ''sproc_subscribeMember''. Original message: ''This subscription type does not exist.'''
    INSERT INTO Member (member_id, birthdate) VALUES (1, '1990-01-01');
    EXEC sproc_subscribeMember 1, 'ALL', '2023-06-09'
END
GO
