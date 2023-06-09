EXEC [tSQLt].[NewTestClass] 'testSubscribeMember'
GO

DROP PROCEDURE IF EXISTS testSubscribeMember.[SetUp]
GO
CREATE PROCEDURE testSubscribeMember.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'

    INSERT INTO Member (member_id, email, birthdate) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'john@doe.com', DATEADD(YEAR, -30, GETDATE()));
    INSERT INTO SubscriptionType (type, min_length) VALUES ('All monthly', 4);
END
GO

/*
* T-01
* Test if a member can add a subscription.
*
* Expects
*   - No exceptions
*/
DROP PROCEDURE IF EXISTS testSubscribeMember.[test if a member can add a subscription]
GO
CREATE PROCEDURE testSubscribeMember.[test if a member can add a subscription]
AS
BEGIN
    -- Assemble
    DECLARE @a_month_from_now date = DATEADD(MONTH, 1, GETDATE())

    -- Expect
    EXEC [tSQLt].[ExpectNoException]

    -- Act
    EXEC sproc_subscribeMember 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'All monthly';
END
GO

/*
* T-02
* Test if a member can't add a subscription twice.
*
* Expects
*   - Exception like: Violation of PRIMARY KEY constraint ''pk_subscription''. 
*/
DROP PROCEDURE IF EXISTS testSubscribeMember.[test if a member can't add a subscription twice]
GO
CREATE PROCEDURE testSubscribeMember.[test if a member can't add a subscription twice]
AS
BEGIN
    -- Assemble
    EXEC [tSQLt].[ApplyConstraint] 'dbo.Subscription', 'pk_subscription'

    -- Expect
    EXEC [tSQLt].[ExpectException]
        @ExpectedMessagePattern = '%Violation of PRIMARY KEY constraint ''pk_subscription''.%'

    -- Act
    EXEC sproc_subscribeMember 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'All monthly';
    EXEC sproc_subscribeMember 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'All monthly';
END
GO

/*
* T-03
* test if a non-existing member can't add a subscription
*
* Expects
*   - Exception like: '%The INSERT statement conflicted with the FOREIGN KEY constraint%'
*/
DROP PROCEDURE IF EXISTS testSubscribeMember.[test if a non-existing member can't add a subscription]
GO
CREATE PROCEDURE testSubscribeMember.[test if a non-existing member can't add a subscription]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.ApplyConstraint 'dbo.Subscription', 'fk_subscrip_member_in_member'

    DECLARE @a_month_from_now date = DATEADD(MONTH, 1, GETDATE())

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessagePattern = '%The INSERT statement conflicted with the FOREIGN KEY constraint%'


    -- Act
    EXEC sproc_subscribeMember 'non-existent', 'All monthly';
END
GO

/*
* T-04
* Test if a member can't add a non-existing subscription
*
* Expects
*   - Exception like: '%The INSERT statement conflicted with the FOREIGN KEY constraint%'
*/
DROP PROCEDURE IF EXISTS testSubscribeMember.[test if a member can't add a non-existing subscription]
GO
CREATE PROCEDURE testSubscribeMember.[test if a member can't add a non-existing subscription]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.ApplyConstraint 'dbo.Subscription', 'fk_subscrip_subscript_subscrip'

    DECLARE @a_month_from_now date = DATEADD(MONTH, 3, GETDATE())

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessagePattern = '%The INSERT statement conflicted with the FOREIGN KEY constraint%'

    -- Act
    EXEC sproc_subscribeMember 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'non-existent';
END
GO
