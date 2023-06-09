EXEC [tSQLt].[NewTestClass] 'testProlongSubscription'
GO

DROP PROCEDURE IF EXISTS testProlongSubscription.[SetUp]
GO
CREATE PROCEDURE testProlongSubscription.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'

    DECLARE @eighteen_years_ago DATETIME = DATEADD(YEAR, -18, GETDATE());

    INSERT INTO Member (member_id, birthdate) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @eighteen_years_ago);
    INSERT INTO SubscriptionType (type, max_age) VALUES ('All monthly', 21);
    INSERT INTO Subscription (member_id, type, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'All monthly', GETDATE());
END
GO

/*
* T-01
* Test if a subscription can be prolonged.
*
* Expects
*   - No exceptions
*/
DROP PROCEDURE IF EXISTS testProlongSubscription.[test if a subscription can be prolonged.]
GO
CREATE PROCEDURE testProlongSubscription.[test if a subscription can be prolonged.]
AS
BEGIN
    -- Expect
    EXEC [tSQLt].[ExpectNoException]

    -- Act
    EXEC sproc_prolongSubscription 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'All monthly', 3
END
GO

/*
* T-02
* Test if a subscription can't be prolonged when it does not exist.
*
* Expects
*   - Exception: 'Error occurred in sproc ''sproc_prolongSubscription''. Original message: ''Your subscription is not found.'''
*/
DROP PROCEDURE IF EXISTS testProlongSubscription.[test if a subscription can't be prolonged when it does not exist.]
GO
CREATE PROCEDURE testProlongSubscription.[test if a subscription can't be prolonged when it does not exist.]
AS
BEGIN
    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_prolongSubscription''. Original message: ''Your subscription is not found.'''

    -- Act
    EXEC sproc_prolongSubscription 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'non-existent', 3
END
GO

/*
* T-03
* Test if a subscription can be prolonged when the member doesn't exist.
*
* Expects
*   - Exception: 'Error occurred in sproc ''sproc_prolongSubscription''. Original message: ''This member does not exist.'''
*/
DROP PROCEDURE IF EXISTS testProlongSubscription.[test if a subscription can be prolonged when the member doesn't exist.]
GO
CREATE PROCEDURE testProlongSubscription.[test if a subscription can be prolonged when the member doesn't exist.]
AS
BEGIN
    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_prolongSubscription''. Original message: ''This member does not exist.'''

    -- Act
    EXEC sproc_prolongSubscription 'non-existent', 'All monthly', 3
END
GO

/*
* T-04
* Test if a subscription can't be shortened.
*
* Expects
*   - Exception: 'Error occurred in sproc ''sproc_prolongSubscription''. Original message: ''The amount of months prolonged is less than 1.'''
*/
DROP PROCEDURE IF EXISTS testProlongSubscription.[test if a subscription can't be shortened.]
GO
CREATE PROCEDURE testProlongSubscription.[test if a subscription can't be shortened.]
AS
BEGIN
    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_prolongSubscription''. Original message: ''The amount of months prolonged is less than 1.'''

    -- Act
    EXEC sproc_prolongSubscription 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'All monthly', -3
END
GO