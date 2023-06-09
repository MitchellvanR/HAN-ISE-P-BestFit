EXEC [tSQLt].[NewTestClass] 'testBookMachine'
GO

DROP PROCEDURE IF EXISTS [testBookMachine].[SetUp]
GO
CREATE PROCEDURE [testBookMachine].[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = 'MachineReservation'
    EXEC tSQLt.ApplyConstraint 'MachineReservation', 'ck_machinereservation_start_end'
END;
GO

/**
* T-01
* Test that a member can successfully book a machine
*
* Expects:
*   - The preferred machine is booked
*/
DROP PROCEDURE IF EXISTS [testBookMachine].[test that a member can successfully book a machine]
GO
CREATE PROCEDURE [testBookMachine].[test that a member can successfully book a machine]
AS
BEGIN
    -- Assemble
    DECLARE @one_hour_from_now DATETIME = DATEADD(HOUR, 1, GETDATE())
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 2, GETDATE())

    SELECT TOP 0 *
    INTO [testGetSubscriptionInformation].[expected]
    FROM dbo.MachineReservation;

    INSERT INTO [testGetSubscriptionInformation].[expected]
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @one_hour_from_now, @two_hours_from_now)

    -- Act
    EXEC sproc_bookMachine 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 1, @one_hour_from_now, @two_hours_from_now

    -- Assert
    EXEC tSQLt.AssertEqualsTable 'testGetSubscriptionInformation.[expected]', 'MachineReservation'
END
GO

/**
* T-02
* Test that a member cannot book a machine in the past
*
* Expects:
*   - Error: 'Error occurred in sproc 'sproc_bookMachine'. Original message: 'The start time cannot be before the current time.'
*/
DROP PROCEDURE IF EXISTS [testBookMachine].[test that a member cannot book a machine in the past]
GO
CREATE PROCEDURE [testBookMachine].[test that a member cannot book a machine in the past]
AS
BEGIN
    -- Assemble
    DECLARE @yesterday DATETIME = DATEADD(DAY, -1, GETDATE())
    DECLARE @yesterday_plus_one_hour DATETIME = DATEADD(HOUR, 1, @yesterday)

    -- Expect
    EXEC tSQLt.ExpectException
         @ExpectedMessage = 'Error occurred in sproc ''sproc_bookMachine''. Original message: ''The start time cannot be before the current time.'''

    -- Act
    EXEC sproc_bookMachine 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 1, @yesterday, @yesterday_plus_one_hour
END
GO

/**
* T-03
* Test that a member cannot book a machine where the end time is before the start time
*
* Expects:
*   - Error: '%The INSERT statement conflicted with the CHECK constraint "ck_machinereservation_start_end".%'
*/
DROP PROCEDURE IF EXISTS [testBookMachine].[test that a member cannot book a machine where the end time is before the start time]
GO
CREATE PROCEDURE [testBookMachine].[test that a member cannot book a machine where the end time is before the start time]
AS
BEGIN
    -- Assemble
    DECLARE @one_hour_from_now DATETIME = DATEADD(HOUR, 1, GETDATE())
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 2, GETDATE())

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%The INSERT statement conflicted with the CHECK constraint "ck_machinereservation_start_end".%'

    -- Act
    EXEC sproc_bookMachine 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 1, @two_hours_from_now, @one_hour_from_now
END
GO