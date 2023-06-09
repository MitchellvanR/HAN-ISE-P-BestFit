EXEC [tSQLt].[NewTestClass] 'testTriggerMachineReservation'
GO

DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[SetUp]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[SetUp]
AS
BEGIN
    EXEC [tSQLt].FakeTable @TableName = 'Machine'
    EXEC [tSQLt].FakeTable @TableName = 'MachineReservation'
    EXEC [tSQLt].FakeTable @TableName = 'Subscription'

    INSERT INTO Machine VALUES (1, 1, 'Squat rack', 'Active')
    INSERT INTO Subscription (member_id, type, end_date)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Adult monthly', DATEADD(MONTH, 3, GETDATE()));

    EXEC [tSQLt].ApplyTrigger 'MachineReservation', 'trg_MachineReservation_insertUpdate'
END
GO

/**
* T-01
* Test if reservation is inserted when all data is correct
*
* Expects:
*   - No errors are raised and the reservation is inserted
*/
DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[test if reservation is inserted when all data is correct]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[test if reservation is inserted when all data is correct]
AS
BEGIN
    -- Assemble
    DECLARE @one_hour_from_now DATETIME = DATEADD(HOUR, 1, GETDATE())
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 2, GETDATE())

    SELECT TOP 0 *
    INTO [testTriggerMachineReservation].[expected]
    FROM MachineReservation

    INSERT INTO [testTriggerMachineReservation].[expected] (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @one_hour_from_now, @two_hours_from_now)

    -- Act
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @one_hour_from_now, @two_hours_from_now)

    -- Assert
    EXEC tSQLt.AssertEqualsTable '[testTriggerMachineReservation].[expected]', 'MachineReservation'
END
GO

/**
* T-02
* Test if the reservation is not inserted at a date where the member has no subscription
*
* Expects:
*   - Error: 'The subscription of the member will end before the reservation takes place.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[test if the reservation is not inserted at a date where the member has no subscription]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[test if the reservation is not inserted at a date where the member has no subscription]
AS
BEGIN
    -- Assemble
    DECLARE @four_months_from_now DATETIME = DATEADD(MONTH, 4, GETDATE())
    DECLARE @four_months_from_now_plus_one_hour DATETIME = DATEADD(HOUR, 1, @four_months_from_now)

    -- Expect
    EXEC tSQLt.ExpectException
         @ExpectedMessage = 'The subscription of the inserted member will end before the reservation takes place.'

    -- Act
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @four_months_from_now, @four_months_from_now_plus_one_hour)
END
GO

/**
* T-03
* Test if the reservation is not inserted when the machine is out of order
*
* Expects:
*   - Error: 'The machine of the inserted reservation is out of order.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[test if the reservation is not inserted when the machine is out of order]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[test if the reservation is not inserted when the machine is out of order]
AS
BEGIN
    -- Assemble
    DECLARE @one_hour_from_now DATETIME = DATEADD(HOUR, 1, GETDATE())
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 2, GETDATE())

    UPDATE Machine
    SET machine_status = 'Out of order'
    WHERE machine_id = 1

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The machine of the inserted reservation is out of order.'

    -- Act
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @one_hour_from_now, @two_hours_from_now)
END
GO

/**
* T-04
* Test if the reservation is not inserted when the given member already booked this machine at the given start time.
*
* Expects:
*   - Error: 'The inserted member already booked this machine at the inserted time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already booked this machine at the given start time]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already booked this machine at the given start time]
AS
BEGIN
    -- Assemble
    DECLARE @one_hour_from_now DATETIME = DATEADD(HOUR, 1, GETDATE())
    DECLARE @one_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @one_hour_from_now)
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 2, GETDATE())
    DECLARE @two_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @two_hours_from_now)

    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @one_hour_from_now, @two_hours_from_now)

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The inserted member already booked this machine at the inserted time.'

    -- Act
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @one_and_a_half_hour_from_now, @two_and_a_half_hour_from_now)
END
GO

/**
* T-05
* Test if the reservation is not inserted when the given member already booked this machine at the given end time.
*
* Expects:
*   - Error: 'The inserted member already booked this machine at the inserted time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already booked this machine at the given end time]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already booked this machine at the given end time]
AS
BEGIN
    -- Assemble
    DECLARE @a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, GETDATE())
    DECLARE @one_hour_from_now DATETIME = DATEADD(MINUTE, 30, @a_half_hour_from_now)
    DECLARE @one_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @one_hour_from_now)
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 1, @one_hour_from_now)

    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @one_hour_from_now, @two_hours_from_now)

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The inserted member already booked this machine at the inserted time.'

    -- Act
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @a_half_hour_from_now, @one_and_a_half_hour_from_now)
END
GO

/**
* T-06
* Test if the reservation is not inserted when the given machine is already booked at the given start time
*
* Expects:
*   - Error: 'The machine of the inserted reservation is already booked at the inserted time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[test if the reservation is not inserted when the given machine is already booked at the given start time]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[test if the reservation is not inserted when the given machine is already booked at the given start time]
AS
BEGIN
    -- Assemble
    DECLARE @one_hour_from_now DATETIME = DATEADD(HOUR, 1, GETDATE())
    DECLARE @one_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @one_hour_from_now)
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 2, GETDATE())
    DECLARE @two_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @two_hours_from_now)

    INSERT INTO Subscription (member_id, type, end_date)
    VALUES ('123456789012-ABCDEFGHIJK-ABCDEFGHIJK', 'Yoga', DATEADD(MONTH, 1, GETDATE()))

    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, '123456789012-ABCDEFGHIJK-ABCDEFGHIJK', @one_hour_from_now, @two_hours_from_now)

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The machine of the inserted reservation is already booked at the inserted time.'

    -- Act
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @one_and_a_half_hour_from_now, @two_and_a_half_hour_from_now)
END
GO

/**
* T-07
* Test if the reservation is not inserted when the given machine is already booked at the given end time
*
* Expects:
*   - Error: 'The machine of the inserted reservation is already booked at the inserted time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[test if the reservation is not inserted when the given machine is already booked at the given end time]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[test if the reservation is not inserted when the given machine is already booked at the given end time]
AS
BEGIN
    -- Assemble
    DECLARE @a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, GETDATE())
    DECLARE @one_hour_from_now DATETIME = DATEADD(HOUR, 1, GETDATE())
    DECLARE @one_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @one_hour_from_now)
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 2, GETDATE())

    INSERT INTO Subscription (member_id, type, end_date)
    VALUES ('123456789012-ABCDEFGHIJK-ABCDEFGHIJK', 'Yoga', DATEADD(MONTH, 1, GETDATE()))

    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, '123456789012-ABCDEFGHIJK-ABCDEFGHIJK', @one_hour_from_now, @two_hours_from_now)

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The machine of the inserted reservation is already booked at the inserted time.'

    -- Act
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @a_half_hour_from_now, @one_and_a_half_hour_from_now)
END
GO

/**
* T-08
* Test if the reservation is not inserted when the given member already has a group class at the given start time
*
* Expects:
*   - Error: 'The inserted member already has another reservation at the inserted time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already has a group class at the given start time]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already has a group class at the given start time]
AS
BEGIN
    -- Assemble
    DECLARE @one_hour_from_now DATETIME = DATEADD(HOUR, 1, GETDATE())
    DECLARE @one_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @one_hour_from_now)
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 2, GETDATE())
    DECLARE @two_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @two_hours_from_now)

    EXEC tSQLt.FakeTable @TableName = 'GroupClass'
    EXEC tSQLt.FakeTable @TableName = 'MemberGroupClass'

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp)
    VALUES ('Yoga', 2, @one_hour_from_now, @two_hours_from_now)

    INSERT INTO MemberGroupClass (member_id, class_name, room_id, start_timestamp)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @one_hour_from_now)

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The inserted member already has another reservation at the inserted time.'

    -- Act
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @one_and_a_half_hour_from_now, @two_and_a_half_hour_from_now)
END
GO

/**
* T-09
* Test if the reservation is not inserted when the given member already has a group class at the given end time
*
* Expects:
*   - Error: 'The inserted member already has another reservation at the inserted time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already has a group class at the given end time]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already has a group class at the given end time]
AS
BEGIN
    -- Assemble
    DECLARE @a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, GETDATE())
    DECLARE @one_hour_from_now DATETIME = DATEADD(HOUR, 1, GETDATE())
    DECLARE @one_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @one_hour_from_now)
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 2, GETDATE())

    EXEC tSQLt.FakeTable @TableName = 'GroupClass'
    EXEC tSQLt.FakeTable @TableName = 'MemberGroupClass'

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp)
    VALUES ('Yoga', 2, @one_hour_from_now, @two_hours_from_now)

    INSERT INTO MemberGroupClass (member_id, class_name, room_id, start_timestamp)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Yoga', 2, @one_hour_from_now)

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The inserted member already has another reservation at the inserted time.'

    -- Act
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @a_half_hour_from_now, @one_and_a_half_hour_from_now)
END
GO

/**
* T-10
* Test if the reservation is not inserted when the given member already has a squash reservation at the given start time
*
* Expects:
*   - Error: 'The inserted member already has another reservation at the inserted time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already has a squash reservation at the given end time]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already has a squash reservation at the given end time]
AS
BEGIN
    -- Assemble
    DECLARE @one_hour_from_now DATETIME = DATEADD(HOUR, 1, GETDATE())
    DECLARE @one_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @one_hour_from_now)
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 2, GETDATE())
    DECLARE @two_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @two_hours_from_now)

    EXEC tSQLt.FakeTable @TableName = 'RoomReservation'

    INSERT INTO RoomReservation (member_id, room_id, start_timestamp, end_timestamp, quantity)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 2, @one_hour_from_now, @two_hours_from_now, 2)

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The inserted member already has another reservation at the inserted time.'

    -- Act
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @one_and_a_half_hour_from_now, @two_and_a_half_hour_from_now)
END
GO

/**
* T-11
* Test if the reservation is not inserted when the given member already has a squash reservation at the given end time
*
* Expects:
*   - Error: 'The inserted member already has another reservation at the inserted time.'
*/
DROP PROCEDURE IF EXISTS [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already has a squash reservation at the given end time]
GO
CREATE PROCEDURE [testTriggerMachineReservation].[test if the reservation is not inserted when the given member already has a squash reservation at the given end time]
AS
BEGIN
    -- Assemble
    DECLARE @a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, GETDATE())
    DECLARE @one_hour_from_now DATETIME = DATEADD(HOUR, 1, GETDATE())
    DECLARE @one_and_a_half_hour_from_now DATETIME = DATEADD(MINUTE, 30, @one_hour_from_now)
    DECLARE @two_hours_from_now DATETIME = DATEADD(HOUR, 2, GETDATE())

    EXEC tSQLt.FakeTable @TableName = 'RoomReservation'

    INSERT INTO RoomReservation (member_id, room_id, start_timestamp, end_timestamp, quantity)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 2, @one_hour_from_now, @two_hours_from_now, 2)

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'The inserted member already has another reservation at the inserted time.'

    -- Act
    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @a_half_hour_from_now, @one_and_a_half_hour_from_now)
END
GO