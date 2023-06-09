EXEC tSQLt.NewTestClass 'testCancelReservation';
GO

DROP PROCEDURE IF EXISTS testCancelReservation.[SetUp]
GO
CREATE PROCEDURE testCancelReservation.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'RoomReservation'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'MachineReservation'
END
GO

/*
* T-01
* A member cancels a room reservation successfully.
*
* Expects
*   - This action gives no error. The reservation is cancelled successfully.
*/
DROP PROCEDURE IF EXISTS testCancelReservation.[test if room reservation can be cancelled]
GO
CREATE PROCEDURE testCancelReservation.[test if room reservation can be cancelled]
AS
BEGIN
    -- Assemble
    DECLARE @start_timestamp datetime = DATEADD(DAY, 3, GETDATE());
    DECLARE @end_timestamp datetime = DATEADD(MINUTE, 30, @start_timestamp);
    INSERT INTO RoomReservation (room_id, member_id, start_timestamp, end_timestamp) VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @start_timestamp, @end_timestamp);

    IF OBJECT_ID('[testCancelReservation].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testCancelReservation].[expected]

    SELECT TOP 0 *
    INTO [testCancelReservation].[expected]
    FROM dbo.RoomReservation;

    -- Act
    EXEC sproc_cancelReservation 'Room', 1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @start_timestamp;

    -- Assert
    EXEC tSQLt.AssertEqualsTable @Expected = '[testCancelReservation].[expected]', @Actual = 'dbo.RoomReservation';
END
GO

/*
* T-02
* A member cancels a machine reservation successfully.
*
* Expects
*   - This action gives no error. The reservation is cancelled successfully.
*/
DROP PROCEDURE IF EXISTS testCancelReservation.[test if machine reservation can be cancelled]
GO
CREATE PROCEDURE testCancelReservation.[test if machine reservation can be cancelled]
AS
BEGIN
    -- Assemble
    DECLARE @start_timestamp datetime = DATEADD(DAY, 3, GETDATE());
    DECLARE @end_timestamp datetime = DATEADD(MINUTE, 30, @start_timestamp);
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp) VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @start_timestamp, @end_timestamp);

    IF OBJECT_ID('[testCancelReservation].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testCancelReservation].[expected]

    SELECT TOP 0 *
    INTO [testCancelReservation].[expected]
    FROM dbo.MachineReservation;

    -- Act
    EXEC sproc_cancelReservation 'Machine', 1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @start_timestamp;

    -- Assert
    EXEC tSQLt.AssertEqualsTable @Expected = '[testCancelReservation].[expected]', @Actual = 'dbo.MachineReservation';
END
GO
/*
* T-03
* An employee tries to cancel a reservation with an invalid reservation type.
*
* Expects
*   - Exception: 'The reservation type is invalid.'
*/
DROP PROCEDURE IF EXISTS testCancelReservation.[test if a reservation with an invalid reservation type cannot be cancelled]
GO
CREATE PROCEDURE testCancelReservation.[test if a reservation with an invalid reservation type cannot be cancelled]
AS
BEGIN
    -- Assemble
    DECLARE @start_timestamp datetime = DATEADD(DAY, 3, GETDATE());

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_cancelReservation''. Original message: ''The reservation type is invalid.'''

    -- Act
    EXEC sproc_cancelReservation 'Invalid type', 1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @start_timestamp;
END
GO

/*
* T-04
* An employee tries to cancel a room reservation that does not exist.
*
* Expects
*   - Exception: 'The reservation does not exist.'
*/
DROP PROCEDURE IF EXISTS testCancelReservation.[test if a non-existent room reservation cannot be cancelled]
GO
CREATE PROCEDURE testCancelReservation.[test if a non-existent room reservation cannot be cancelled]
AS
BEGIN
    -- Assemble
    DECLARE @start_timestamp datetime = DATEADD(DAY, 3, GETDATE());

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_cancelReservation''. Original message: ''The reservation does not exist.'''

    -- Act
    EXEC sproc_cancelReservation 'Room', 1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @start_timestamp;
END
GO

/*
* T-05
* An employee tries to cancel a machine reservation that does not exist.
*
* Expects
*   - Exception: 'The reservation does not exist.'
*/
DROP PROCEDURE IF EXISTS testCancelReservation.[test if a non-existent machine reservation cannot be cancelled]
GO
CREATE PROCEDURE testCancelReservation.[test if a non-existent machine reservation cannot be cancelled]
AS
BEGIN
    -- Assemble
    DECLARE @start_timestamp datetime = DATEADD(DAY, 3, GETDATE());

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_cancelReservation''. Original message: ''The reservation does not exist.'''

    -- Act
    EXEC sproc_cancelReservation 'Machine', 1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @start_timestamp;
END
GO

/*
* T-06
* An employee tries to cancel a room reservation that has already ended.
*
* Expects
*   - Exception: 'The reservation has already ended.'
*/
DROP PROCEDURE IF EXISTS testCancelReservation.[test if a room reservation that has already ended cannot be cancelled]
GO
CREATE PROCEDURE testCancelReservation.[test if a room reservation that has already ended cannot be cancelled]
AS
BEGIN
    -- Assemble
    DECLARE @start_timestamp datetime = DATEADD(DAY, -3, GETDATE());
    DECLARE @end_timestamp datetime = DATEADD(MINUTE, 30, @start_timestamp);
    INSERT INTO RoomReservation (room_id, member_id, start_timestamp, end_timestamp) VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @start_timestamp, @end_timestamp);

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_cancelReservation''. Original message: ''The reservation has already ended.'''

    -- Act
    EXEC sproc_cancelReservation 'Room', 1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @start_timestamp;
END
GO

/*
* T-07
* An employee tries to cancel a machine reservation that has already ended.
*
* Expects
*   - Exception: 'The reservation has already ended.'
*/
DROP PROCEDURE IF EXISTS testCancelReservation.[test if a machine reservation that has already ended cannot be cancelled]
GO
CREATE PROCEDURE testCancelReservation.[test if a machine reservation that has already ended cannot be cancelled]
AS
BEGIN
    -- Assemble
    DECLARE @start_timestamp datetime = DATEADD(DAY, -3, GETDATE());
    DECLARE @end_timestamp datetime = DATEADD(MINUTE, 30, @start_timestamp);
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp) VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @start_timestamp, @end_timestamp);

    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessage = 'Error occurred in sproc ''sproc_cancelReservation''. Original message: ''The reservation has already ended.'''

    -- Act
    EXEC sproc_cancelReservation 'Machine', 1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @start_timestamp;
END
GO
