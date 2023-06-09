EXEC tSQLt.NewTestClass 'testTriggerMemberGroupClass';
GO

DROP PROCEDURE  IF EXISTS [testTriggerMemberGroupClass].[SetUp]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[SetUp]
AS
BEGIN
    DECLARE @endSubscription datetime = DATEADD(MONTH, 3, GETDATE());

    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'GroupClass'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'GroupClassType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'GroupClassTypeSubscriptionType'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'MachineReservation'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'RoomReservation'

    INSERT INTO Subscription (member_id, type, end_date) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult monthly', @endSubscription),
                                                                     ('12345678901-ABCDEFGHIJK-12345678901', 'Adult monthly', @endSubscription);
    INSERT INTO GroupClassType (class_name, max_participants) VALUES ('Yoga', 10), ('Dance', 10);
    INSERT INTO GroupClassTypeSubscriptionType (class_name, type) VALUES ('Yoga', 'Adult monthly'), ('Dance', 'Adult monthly');

    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'MemberGroupClass'
    EXEC [tSQLt].[ApplyTrigger] @TableName = 'MemberGroupClass', @TriggerName = 'trg_MemberGroupClass_insertUpdate'

END
GO


/**
* T-01
* A member signs in for a group class.
*
* Expects
*   - The member_id and the group class are saved in the table MemberGroupClass.
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test to verify that a member can sign in to a group class.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test to verify that a member can sign in to a group class.]
AS
BEGIN
    --Assemble
    IF OBJECT_ID('[testTriggerMemberGroupClass].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testTriggerMemberGroupClass].[expected]

    SELECT TOP 0 *
    INTO [testTriggerMemberGroupClass].[expected]
    FROM dbo.MemberGroupClass;

    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO [testTriggerMemberGroupClass].[expected] VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate);

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testTriggerMemberGroupClass.expected', 'dbo.MemberGroupClass', '', 'Tables do not match!';
END
GO

/**
* T-02
* A member signs in for a group class, but was already signed in.
*
* Expects
*   - Exception: 'The member has already signed up for this group class.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if the member is already registered for the group class.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if the member is already registered for the group class.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO GroupClass(class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate);

    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member has already signed up for this group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);
END
GO

/**
* T-03
* A member signs in for a group class, but is already signed in for another group class at that time.
*
* Expects
*   - Exception: 'The member is already signed up for another group class at that time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if the member is already registered for another group class that is still ongoing.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if the member is already registered for another group class that is still ongoing.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                        ('Dance', 3, DATEADD(MINUTE, -15, @startDate), DATEADD(MINUTE, 45, @startDate));

    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(MINUTE, -15, @startDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member is already signed up for another group class at this time.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);
END
GO

/**
* T-04
* A member signs in for a group class, but is already signed in for another group class at that time.
*
* Expects
*   - Exception: 'The member is already signed up for another group class at that time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if the member is already registered for another group class that starts during the group class.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if the member is already registered for another group class that starts during the group class.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                         ('Dance', 3, DATEADD(MINUTE, 15, @startDate), DATEADD(MINUTE, 90, @startDate));

    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member is already signed up for another group class at this time.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(MINUTE, 15, @startDate));
END
GO


/**
* T-05
* A member signs in for a group class, but is already signed in for a machine reservation at that time.
*
* Expects
*   - Exception: 'The member has already signed up for a machine reservation at that time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if the member cannot sign in when the class starts during a machine reservation.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if the member cannot sign in when the class starts during a machine reservation.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate);
    INSERT INTO MachineReservation (member_id, start_timestamp, end_timestamp) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', DATEADD(MINUTE, -15, @startDate), DATEADD(MINUTE, 15, @startDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member already has a machine reservation at the time of the group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);
END
GO

/**
* T-06
* A member signs in for a group class, but is already signed in for a machine reservation at that time.
*
* Expects
*   - Exception: 'The member has already signed up for a machine reservation at that time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if the member cannot sign in when the class ends during a machine reservation.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if the member cannot sign in when the class ends during a machine reservation.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate);
    INSERT INTO MachineReservation (member_id, start_timestamp, end_timestamp) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', DATEADD(MINUTE, 15, @startDate), DATEADD(MINUTE, 45, @endDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member already has a machine reservation at the time of the group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);
END
GO

/**
* T-07
* A member signs in for a group class, but is already signed in for a room reservation at that time.
*
* Expects
*   - Exception: 'The member has already signed up for a room reservation at that time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if the member cannot sign in when the class starts during a room reservation.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if the member cannot sign in when the class starts during a room reservation.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate);
    INSERT INTO RoomReservation (member_id, start_timestamp, end_timestamp) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', DATEADD(MINUTE, -15, @startDate), DATEADD(MINUTE, 15, @startDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member already has a room reservation at the time of the group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);
END
GO

/**
* T-08
* A member signs in for a group class, but is already signed in for a room reservation at that time.
*
* Expects
*   - Exception: 'The member has already signed up for a room reservation at that time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if the member cannot sign in when the class ends during a room reservation.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if the member cannot sign in when the class ends during a room reservation.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate);
    INSERT INTO RoomReservation (member_id, start_timestamp, end_timestamp) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', DATEADD(MINUTE, 15, @startDate), DATEADD(MINUTE, 45, @endDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member already has a room reservation at the time of the group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);
END
GO

/**
* T-09
* A member signs in for a group class, but the group class is already full.
*
* Expects
*   - Exception: 'The group class is full.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if the member cannot sign in when the class is full.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if the member cannot sign in when the class is full.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    UPDATE GroupClassType SET max_participants = 0 WHERE class_name = 'Yoga';
    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate);

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The group class is full.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);
END
GO

/**
* T-10
* A member signs in for a group class, but doesn't have an ongoing subscription that fits the group class.
*
* Expects
*   - Exception: 'The member does not have an ongoing subscription that fits the group class.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if the member cannot sign in when they do not have an ongoing subscription that fits the group class.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if the member cannot sign in when they do not have an ongoing subscription that fits the group class.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    DELETE FROM Subscription WHERE member_id = 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK';
    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate);

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member has no active subscriptions that allows the member to follow the group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);
END
GO

/**
* T-11
* Multiple members sign in for a group class.
*
* Expects
*   - The member_id's and the group classes are saved in the table MemberGroupClass.
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test to verify that multiple members can sign in to group classes.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test to verify that multiple members can sign in to group classes.]
AS
BEGIN
    --Assemble
    IF OBJECT_ID('[testTriggerMemberGroupClass].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testTriggerMemberGroupClass].[expected]

    SELECT TOP 0 *
    INTO [testTriggerMemberGroupClass].[expected]
    FROM dbo.MemberGroupClass;

    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO [testTriggerMemberGroupClass].[expected] VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate),
                                                            ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(WEEK, 1, @startDate)),
                                                            ('12345678901-ABCDEFGHIJK-12345678901', 'Yoga', 2, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                        ('Dance', 3, DATEADD(WEEK, 1, @startDate), DATEADD(WEEK, 1, @endDate));

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate),
                                        ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(WEEK, 1, @startDate)),
                                        ('12345678901-ABCDEFGHIJK-12345678901', 'Yoga', 2, @startDate);

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testTriggerMemberGroupClass.expected', 'dbo.MemberGroupClass', '', 'Tables do not match!';
END
GO

/**
* T-12
* Multiple members sign in for a group class, but one of them was already signed in for that class.
*
* Expects
*   - Exception: 'The member is already signed in for this group class.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of them is already registered for the group class.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of them is already registered for the group class.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);
    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                        ('Dance', 3, DATEADD(WEEK, 1, @startDate), DATEADD(WEEK, 1, @endDate));

    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member has already signed up for this group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate),
                                        ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(WEEK, 1, @startDate)),
                                        ('12345678901-ABCDEFGHIJK-12345678901', 'Yoga', 2, @startDate);
END
GO

/**
* T-13
* Multiple members sign in for a group class, but one of them was already signed in for another group class at that time.
*
* Expects
*   - Exception: 'The member is already signed in for another group class at this time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of them is already registered for another group class that is still ongoing.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of them is already registered for another group class that is still ongoing.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);
    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                        ('Dance', 3, DATEADD(MINUTE, -30, @startDate), DATEADD(MINUTE, 30, @startDate));

    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(MINUTE, -30, @startDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member is already signed up for another group class at this time.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate),
                                        ('12345678901-ABCDEFGHIJK-12345678901', 'Yoga', 2, @startDate);
END
GO

/**
* T-14
* Multiple members sign in for a group class, but one of them was already signed in for another group class at that time.
*
* Expects
*   - Exception: 'The member is already signed in for another group class at this time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of them is already registered for another group class that starts during it.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of them is already registered for another group class that starts during it.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                        ('Dance', 3, DATEADD(MINUTE, 30, @startDate), DATEADD(MINUTE, 90, @startDate));

    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate);

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member is already signed up for another group class at this time.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(MINUTE, 30, @startDate)),
                                        ('12345678901-ABCDEFGHIJK-12345678901', 'Yoga', 2, @startDate);
END
GO

/**
* T-15
* Multiple members sign in for a group class, but one of them is already signed in for a machine reservation at that time.
*
* Expects
*   - Exception: 'The member is already signed in for a machine reservation at the time of the group class.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of the classes starts during a machine reservation.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of the classes starts during a machine reservation.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                        ('Dance', 3, DATEADD(WEEK, 1, @startDate), DATEADD(WEEK, 1, @endDate));
    INSERT INTO MachineReservation (member_id, start_timestamp, end_timestamp) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', DATEADD(MINUTE, -15, @startDate), DATEADD(MINUTE, 15, @startDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member already has a machine reservation at the time of the group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(WEEK, 1, @startDate)),
                                        ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate),
                                        ('12345678901-ABCDEFGHIJK-12345678901', 'Yoga', 2, @startDate);
END
GO

/**
* T-16
* Multiple members sign in for a group class, but one of them is already signed in for a machine reservation at that time.
*
* Expects
*   - Exception: 'The member is already signed in for a machine reservation at the time of the group class.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of the classes ends during a machine reservation.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of the classes ends during a machine reservation.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                        ('Dance', 3, DATEADD(WEEK, 1, @startDate), DATEADD(WEEK, 1, @endDate));
    INSERT INTO MachineReservation (member_id, start_timestamp, end_timestamp) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', DATEADD(MINUTE, -15, @endDate), DATEADD(MINUTE, 15, @endDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member already has a machine reservation at the time of the group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(WEEK, 1, @startDate)),
                                        ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate),
                                        ('12345678901-ABCDEFGHIJK-12345678901', 'Yoga', 2, @startDate);
END
GO

/**
* T-17
* Multiple members sign in for a group class, but one of them is already signed in for a room reservation at that time.
*
* Expects
*   - Exception: 'The member is already signed in for a room reservation at the time of the group class.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of the classes ends during a room reservation.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of the classes ends during a room reservation.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                        ('Dance', 3, DATEADD(WEEK, 1, @startDate), DATEADD(WEEK, 1, @endDate));
    INSERT INTO RoomReservation (member_id, start_timestamp, end_timestamp) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', DATEADD(MINUTE, -15, @startDate), DATEADD(MINUTE, 15, @startDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member already has a room reservation at the time of the group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(WEEK, 1, @startDate)),
                                        ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate),
                                        ('12345678901-ABCDEFGHIJK-12345678901', 'Yoga', 2, @startDate);
END
GO


/**
* T-18
* Multiple members sign in for a group class, but one of them is already signed in for a room reservation at that time.
*
* Expects
*   - Exception: 'The member is already signed in for a room reservation at the time of the group class.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of the classes starts during a room reservation.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if multiple members cannot sign up when one of the classes starts during a room reservation.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(WEEK, 1, @startDate);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                        ('Dance', 3, DATEADD(WEEK, 1, @startDate), DATEADD(WEEK, 1, @endDate));
    INSERT INTO RoomReservation (member_id, start_timestamp, end_timestamp) VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', DATEADD(MINUTE, 15, @startDate), DATEADD(MINUTE, 15, @endDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member already has a room reservation at the time of the group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(WEEK, 1, @startDate)),
                                        ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate),
                                        ('12345678901-ABCDEFGHIJK-12345678901', 'Yoga', 2, @startDate);
END
GO


/**
* T-19
* A member signs in for a group class, but the group class is already full.
*
* Expects
*   - Exception: 'The group class is full.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if multiple members cannot sign in when the class is full.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if multiple members cannot sign in when the class is full.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    UPDATE GroupClassType SET max_participants = 0 WHERE class_name = 'Dance';
    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                        ('Dance', 3, DATEADD(WEEK, 1, @startDate), DATEADD(WEEK, 1, @endDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The group class is full.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(WEEK, 1, @startDate)),
                                        ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate),
                                        ('12345678901-ABCDEFGHIJK-12345678901', 'Yoga', 2, @startDate);
END
GO

/**
* T-20
* A member signs in for a group class, but doesn't have an ongoing subscription that fits the group class.
*
* Expects
*   - Exception: 'The member does not have an ongoing subscription that fits the group class.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMemberGroupClass].[test if multiple members cannot sign in when they do not have an ongoing subscription that fits the group class.]
GO
CREATE PROCEDURE [testTriggerMemberGroupClass].[test if multiple members cannot sign in when they do not have an ongoing subscription that fits the group class.]
AS
BEGIN
    --Assemble
    DECLARE @startDate datetime = DATEADD(WEEK, 1, GETDATE());
    DECLARE @endDate datetime = DATEADD(HOUR, 1, @startDate);

    DELETE FROM Subscription WHERE member_id = '12345678901-ABCDEFGHIJK-12345678901';
    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp) VALUES ('Yoga', 2, @startDate, @endDate),
                                                                                        ('Dance', 3, DATEADD(WEEK, 1, @startDate), DATEADD(WEEK, 1, @endDate));

    --Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'The member has no active subscriptions that allows the member to follow the group class.'

    --Act
    INSERT INTO MemberGroupClass VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Dance', 3, DATEADD(WEEK, 1, @startDate)),
                                        ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @startDate),
                                        ('12345678901-ABCDEFGHIJK-12345678901', 'Yoga', 2, @startDate);
END
GO
