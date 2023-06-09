EXEC tSQLt.newTestClass 'testTriggerSubscription'
GO

DROP PROCEDURE IF EXISTS testTriggerSubscription.[SetUp]
GO
CREATE PROCEDURE testTriggerSubscription.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Member', @Identity = 1;
    EXEC tSQLt.FakeTable @TableName = N'SubscriptionType', @Identity = 1;
    EXEC tSQLt.FakeTable @TableName = N'Subscription', @Identity = 1;

    EXEC tSQLt.ApplyTrigger @TriggerName = N'trg_Subscription_insertUpdate', @TableName = N'Subscription';

    INSERT INTO SubscriptionType (type, min_age, max_age) VALUES ('Adult', 18, 65);
    INSERT INTO Member (member_id, birthdate) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', DATEADD(YEAR, -20, GETDATE()));
END
GO

/*
* T-01
* Test inserting member that is too young for a subscription
*
* Expects
*   - Exception like: '%The member is too young to fit this subscription type.%'
*/
DROP PROCEDURE testTriggerSubscription.[test inserting member that is too young for a subscription]
GO
CREATE PROCEDURE testTriggerSubscription.[test inserting member that is too young for a subscription]
AS
BEGIN
    -- Arrange
    DECLARE @seventeen_years_ago DATE = DATEADD(YEAR, -17, GETDATE());

    UPDATE Member SET birthdate = @seventeen_years_ago WHERE member_id = 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK';

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%The member is too young to fit this subscription type.%';

    -- Act
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult', GETDATE(), DATEADD(MONTH, 1, GETDATE()));
END
GO

/*
* T-02
* Test inserting old member that is too old for a subscription
*
* Expects
*   - Exception like: '%The member is too old to fit this subscription type.%'
*/
DROP PROCEDURE testTriggerSubscription.[test inserting old member that is too old for a subscription]
GO
CREATE PROCEDURE testTriggerSubscription.[test inserting old member that is too old for a subscription]
AS
BEGIN
    -- Arrange
    DECLARE @sixtysix_years_ago DATE = DATEADD(YEAR, -66, GETDATE());

    UPDATE Member SET birthdate = @sixtysix_years_ago WHERE member_id = 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK';

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%The member is too old to fit this subscription type.%';

    -- Act
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult', GETDATE(), DATEADD(MONTH, 1, GETDATE()));
END
GO

/*
* T-03
* Test inserting a member with a correct age for a subscription
*
* Expects
*   - The new subscription is registered in the Subscription table and no exception is thrown
*/
DROP PROCEDURE IF EXISTS testTriggerSubscription.[test if a subscription with correct data gets inserted correctly]
GO
CREATE PROCEDURE testTriggerSubscription.[test if a subscription with correct data gets inserted correctly]
AS
BEGIN
    -- Expect
    EXEC tSQLt.ExpectNoException;

    -- Act
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult', GETDATE(), DATEADD(MONTH, 1, GETDATE()));
END
GO

/*
* T-04
* Test updating a member's subscription to a subscription that is too young
*
* Expects
*   - Exception like: '%The member is too old to fit this subscription type.%'
*/
DROP PROCEDURE IF EXISTS testTriggerSubscription.[test updating a member's subscription to a subscription that is too young]
GO
CREATE PROCEDURE testTriggerSubscription.[test updating a member's subscription to a subscription that is too young]
AS
BEGIN
    -- Arrange
    INSERT INTO SubscriptionType (TYPE, min_age, max_age) VALUES ('Junior', 0, 17);
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult', GETDATE(), DATEADD(MONTH, 1, GETDATE()));

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%The member is too old to fit this subscription type.%';

    -- Act
    UPDATE Subscription SET type = 'Junior' WHERE member_id = 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK';
END
GO

/*
* T-05
* Test updating a member's subscription to a subscription that is too old
*
* Expects
*   - Exception like: '%The member is too young to fit this subscription type.%'
*/
DROP PROCEDURE IF EXISTS testTriggerSubscription.[test updating a member's subscription to a subscription that is too old]
GO
CREATE PROCEDURE testTriggerSubscription.[test updating a member's subscription to a subscription that is too old]
AS
BEGIN
    -- Arrange
    INSERT INTO SubscriptionType (TYPE, min_age, max_age) VALUES ('Senior', 66, 120);
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult', GETDATE(), DATEADD(MONTH, 1, GETDATE()));

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%The member is too young to fit this subscription type.%';

    -- Act
    UPDATE Subscription SET type = 'Senior' WHERE member_id = 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK';
END
GO

/*
* T-06
* Test if a subscription with correct data gets updated correctly
*
* Expects
*   - The subscription entry is updated correctly and no exception is thrown
*/
DROP PROCEDURE IF EXISTS testTriggerSubscription.[test if a subscription with correct data gets updated correctly]
GO
CREATE PROCEDURE testTriggerSubscription.[test if a subscription with correct data gets updated correctly]
AS
BEGIN
    -- Arrange
    INSERT INTO SubscriptionType (TYPE, min_age, max_age) VALUES ('Adult 2.0', 18, 65);
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult', GETDATE(), DATEADD(MONTH, 1, GETDATE()));

    -- Expect
    EXEC tSQLt.ExpectNoException;

    -- Act
    UPDATE Subscription SET type = 'Adult 2.0' WHERE member_id = 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK';
END
GO

/*
* T-07
* Test inserting the same subscription twice for a member
*
* Expects
*   - Exception like: '%The member already has a subscription of this type.%'
*/
DROP PROCEDURE IF EXISTS testTriggerSubscription.[test inserting the same subscription twice for a member]
GO
CREATE PROCEDURE testTriggerSubscription.[test inserting the same subscription twice for a member]
AS
BEGIN
    -- Arrange
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult', GETDATE(), DATEADD(MONTH, 1, GETDATE()));

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%The member already has a subscription of this type.%';

    -- Act
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult', GETDATE(), DATEADD(MONTH, 1, GETDATE()));
END
GO

/*
* T-08
* Test if a member can insert two subscriptions of different types
*
* Expects
*   - The new subscription gets inserted correctly and no exception is thrown
*/
DROP PROCEDURE IF EXISTS testTriggerSubscription.[test if a member can insert two subscriptions of different types]
GO
CREATE PROCEDURE testTriggerSubscription.[test if a member can insert two subscriptions of different types]
AS
BEGIN
    -- Arrange
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult', GETDATE(), DATEADD(MONTH, 1, GETDATE()));

    -- Expect
    EXEC tSQLt.ExpectNoException;

    -- Act
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult 2.0', GETDATE(), DATEADD(MONTH, 1, GETDATE()));
END
GO

/*
* T-09
* Test updating a member's subscription to a subscription that is already active
*
* Expects
*   - Exception like: '%The member already has a subscription of this type.%'
*/
DROP PROCEDURE IF EXISTS testTriggerSubscription.[test updating a member's subscription to a subscription that is already active]
GO
CREATE PROCEDURE testTriggerSubscription.[test updating a member's subscription to a subscription that is already active]
AS
BEGIN
    -- Arrange
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult', GETDATE(), DATEADD(MONTH, 1, GETDATE()));
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult 2.0', GETDATE(), DATEADD(MONTH, 1, GETDATE()));

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%The member already has a subscription of this type.%';

    -- Act
    UPDATE Subscription SET type = 'Adult' WHERE member_id = 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK' AND type = 'Adult 2.0';
END
GO

/*
* T-10
* Test updating a member's subscription to a different subscription
*
* Expects
*   - The subscription is updated correctly and no exception is thrown
*/
DROP PROCEDURE IF EXISTS testTriggerSubscription.[test if an existing subscription can be updated while having a different subscription active]
GO
CREATE PROCEDURE testTriggerSubscription.[test if an existing subscription can be updated while having a different subscription active]
AS
BEGIN
    -- Arrange
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult', GETDATE(), DATEADD(MONTH, 1, GETDATE()));
    INSERT INTO Subscription (member_id, type, start_date, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult 2.0', GETDATE(), DATEADD(MONTH, 1, GETDATE()));

    -- Expect
    EXEC tSQLt.ExpectNoException;

    -- Act
    UPDATE Subscription SET type = 'Adult 3.0' WHERE member_id = 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK' AND type = 'Adult';
END
GO
