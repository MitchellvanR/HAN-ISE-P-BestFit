EXEC tSQLt.NewTestClass 'testCancelSubscription';
GO

DROP PROCEDURE IF EXISTS testCancelSubscription.[SetUp]
GO
CREATE PROCEDURE testCancelSubscription.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'

    DECLARE @start_date DATE = DATEADD(MONTH, -3, GETDATE());
    DECLARE @end_date DATE = DATEADD(WEEK, 4, GETDATE());

    INSERT INTO Subscription (member_id, type, start_date, end_date)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Zumba monthly', @start_date, @end_date);
    INSERT INTO SubscriptionType (type, notice_period)
    VALUES ('Zumba monthly', 3);

END
GO

/*
* T-01
* A member cancels their subscription without complications.
*
* Expects
*   - All actions executed successfully. The subscription is cancelled.
*/
DROP PROCEDURE IF EXISTS testCancelSubscription.[test if an subscription can be cancelled successfully]
GO
CREATE PROCEDURE testCancelSubscription.[test if an subscription can be cancelled successfully]
AS
BEGIN
    -- Expect
    EXEC [tSQLt].[ExpectNoException]

    -- Act
    EXEC sproc_cancelSubscription 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Zumba monthly'
END;
GO

/*
* T-02
* A member cancels a subscription which doesn't exist.
*
* Expects
*   - This action gives an error. The subscription is not cancelled.
*   - Exception: Error occured in sproc 'sproc_cancelSubscription'. Original message: 'This member does not have an active subscription/this subscription is not between the start- and end date of the subscription.'
*/
DROP PROCEDURE IF EXISTS testCancelSubscription.[test if an non-existing subscription can't be cancelled]
GO
CREATE PROCEDURE testCancelSubscription.[test if an non-existing subscription can't be cancelled]
AS
BEGIN
    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occured in sproc ''sproc_cancelSubscription''. Original message: ''This member does not have an active subscription/this subscription is not between the start- and end date of the subscription.''';

    -- Act
    EXEC sproc_cancelSubscription 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'non-existing subscription'
END;
GO


/*
* T-03
* A member cancels a subscription which already has been cancelled.
*
* Expects
*   - This action gives an error. The subscription is not cancelled.
*   - Exception: Error occured in sproc 'sproc_cancelSubscription'. Original message: 'This member does not have an active subscription/this subscription is not between the start- and end date of the subscription.'
*/
DROP PROCEDURE IF EXISTS testCancelSubscription.[test if an inactive subscription can't be cancelled]
GO
CREATE PROCEDURE testCancelSubscription.[test if an inactive subscription can't be cancelled]
AS
BEGIN
    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occured in sproc ''sproc_cancelSubscription''. Original message: ''This member does not have an active subscription/this subscription is not between the start- and end date of the subscription.''';

    -- Act
    EXEC sproc_cancelSubscription 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Zumba monthly'
    EXEC sproc_cancelSubscription 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Zumba monthly'
END;
GO