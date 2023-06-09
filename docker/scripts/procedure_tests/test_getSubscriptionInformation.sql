EXEC tSQLt.NewTestClass 'testGetSubscriptionInformation';
GO

DROP PROCEDURE IF EXISTS testGetSubscriptionInformation.[SetUp]
GO
CREATE PROCEDURE testGetSubscriptionInformation.[SetUp]
AS
BEGIN
    IF OBJECT_ID('[testGetSubscriptionInformation].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testGetSubscriptionInformation].[expected]
    IF OBJECT_ID('[testGetSubscriptionInformation].[actual]', 'Table') IS NOT NULL
        DROP TABLE [testGetSubscriptionInformation].[actual]

    SELECT TOP 0 *
    INTO [testGetSubscriptionInformation].[expected]
    FROM dbo.Subscription;

    SELECT TOP 0 *
    INTO [testGetSubscriptionInformation].[actual]
    FROM dbo.Subscription;

    EXEC tSQLt.FakeTable 'dbo', 'Subscription';
    EXEC tSQLt.FakeTable 'dbo', 'SubscriptionType';

    INSERT INTO SubscriptionType (type, notice_period, min_length, min_age, max_age)
    VALUES  ('Dance monthly', 4, 1, NULL, NULL),
            ('Squash monthly', 4, 1, NULL, NULL),
            ('Adult monthly', 4, 1, NULL, NULL);
END
GO


/*
* T-01
* Returns correct single row of subscription information for a member.
*
* Expects:
*   - The stored procedure executes successfully without any exceptions.
*   - The stored procedure retrieves the subscription information for the specified member correctly.
*   - The retrieved subscription information matches the expected values.
*/
DROP PROCEDURE IF EXISTS testGetSubscriptionInformation.[test if stored procedure returns correct single subscription row of a member]
GO
CREATE PROCEDURE testGetSubscriptionInformation.[test if stored procedure returns correct single subscription row of a member]
AS
BEGIN
    --Assemble
    DECLARE @member_id VARCHAR(36) = 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK';
        
    INSERT INTO Subscription (member_id, type, start_date, end_date)
    VALUES ('ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 'Dance monthly', DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -1, GETDATE())),
           (@member_id, 'All monthly', GETDATE(), DATEADD(MONTH, 1, GETDATE())),
           ('LMNOPQRSTUV-567890123456-LMNOPQRSTUV', 'Squash monthly', GETDATE(), DATEADD(MONTH, 1, GETDATE()));

    INSERT INTO [testGetSubscriptionInformation].[expected] (member_id, type, start_date, end_date)
    VALUES (@member_id, 'All monthly', GETDATE(), DATEADD(MONTH, 1, GETDATE()));
    
    --Act
    INSERT INTO [testGetSubscriptionInformation].[actual]
    EXEC sproc_getSubscriptionInformation @member_id

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testGetSubscriptionInformation.expected', 'testGetSubscriptionInformation.actual', '',
         'Tables do not match!';
END;
GO

/*
* T-02
* Returns correct multiple rows of subscription information for a member.
*
* Expects
*   - The stored procedure executes successfully without any exceptions.
*   - The stored procedure retrieves the subscription information for the specified member correctly.
*   - The retrieved subscription information matches the expected values.
*/
DROP PROCEDURE IF EXISTS testGetSubscriptionInformation.[test if stored procedure returns correct multiple subscription rows of a member]
GO
CREATE PROCEDURE testGetSubscriptionInformation.[test if stored procedure returns correct multiple subscription rows of a member]
AS
BEGIN
    --Assemble
    DECLARE @member_id VARCHAR(36) = 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK';

    EXEC tSQLt.FakeTable 'dbo', 'Subscription';
    EXEC tSQLt.FakeTable 'dbo', 'SubscriptionType';

    INSERT INTO SubscriptionType (type, notice_period, min_length, min_age, max_age)
    VALUES  ('Dance monthly', 4, 1, NULL, NULL),
            ('Squash monthly', 4, 1, NULL, NULL),
            ('Adult monthly', 4, 1, NULL, NULL);

    INSERT INTO Subscription (member_id, type, start_date, end_date)
    VALUES ('ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 'Dance monthly', DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -1, GETDATE())),
           (@member_id, 'Adult monthly', GETDATE(), DATEADD(MONTH, 1, GETDATE())),
           (@member_id, 'Dance monthly', DATEADD(MONTH, 3, GETDATE()), DATEADD(MONTH, 4, GETDATE())),
           (@member_id, 'Squash monthly', DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -1, GETDATE())),
           ('LMNOPQRSTUV-567890123456-LMNOPQRSTUV', 'Squash monthly', GETDATE(), DATEADD(MONTH, 1, GETDATE())),
           ('LMNOPQRSTUV-567890123456-LMNOPQRSTUV', 'Dance monthly', DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -1, GETDATE()));

    INSERT INTO [testGetSubscriptionInformation].[expected] (member_id, type, start_date, end_date)
    VALUES (@member_id, 'Adult monthly', GETDATE(), DATEADD(MONTH, 1, GETDATE())),
           (@member_id, 'Dance monthly', DATEADD(MONTH, 3, GETDATE()), DATEADD(MONTH, 4, GETDATE())),
           (@member_id, 'Squash monthly', DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -1, GETDATE()));
    
    --Act
    INSERT INTO [testGetSubscriptionInformation].[actual]
    EXEC sproc_getSubscriptionInformation @member_id

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testGetSubscriptionInformation.expected', 'testGetSubscriptionInformation.actual', '',
         'Tables do not match!';
END;
GO