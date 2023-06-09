EXEC tSQLt.NewTestClass 'testTriggerRoomReservation';
GO

DROP PROCEDURE IF EXISTS [testTriggerRoomReservation].[SetUp]
GO
CREATE PROCEDURE [testTriggerRoomReservation].[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO Room (room_id, functionality, max_people) VALUES (1, 'Squash', 2), (2, 'Squash', 2), (3, 'Squash', 2);

    EXEC tSQLt.FakeTable 'dbo', 'RoomReservation';

    EXEC [tSQLt].[ApplyTrigger] @TableName = 'dbo.RoomReservation',
         @TriggerName = 'trg_RoomReservation_insertUpdate';
END
GO

/**
* T-01
* A member makes a successful squash reservation and gets through trigger checks.
*
* Expects
*   - The squash reservation is successfully created. No errors are thrown.
*/
DROP PROCEDURE IF EXISTS [testTriggerRoomReservation].[test to verify that a valid squash room reservation gets through trigger checks];
GO
CREATE PROCEDURE [testTriggerRoomReservation].[test to verify that a valid squash room reservation gets through trigger checks]
AS
BEGIN
    --Assemble
    IF OBJECT_ID('[testTriggerRoomReservation].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testTriggerRoomReservation].[expected]

    SELECT TOP 0 *
    INTO [testTriggerRoomReservation].[expected]
    FROM dbo.RoomReservation;

    INSERT INTO [testTriggerRoomReservation].[expected]
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, '11-06-2023 12:00:00:000', '11-06-2023 13:00:00:000', 2);

    --Act
    INSERT INTO RoomReservation
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, '11-06-2023 12:00:00:000', '11-06-2023 13:00:00:000', 2);

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testTriggerRoomReservation.expected', 'dbo.RoomReservation', '',
         'Tables do not match!';
END
GO

/*
 * T-02
 * A member makes a successful squash reservations and gets through trigger checks (batch).
 *
 * Expects
 *   - The squash reservations are successfully created. No errors are thrown.
 */
DROP PROCEDURE IF EXISTS [testTriggerRoomReservation].[test to verify that a valid squash room reservation gets through trigger checks (batch)];
GO
CREATE PROCEDURE [testTriggerRoomReservation].[test to verify that a valid squash room reservation gets through trigger checks (batch)]
AS
BEGIN
    --Assemble
    IF OBJECT_ID('[testTriggerRoomReservation].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testTriggerRoomReservation].[expected]

    SELECT TOP 0 *
    INTO [testTriggerRoomReservation].[expected]
    FROM dbo.RoomReservation;

    INSERT INTO [testTriggerRoomReservation].[expected]
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, '11-06-2023 12:00:00:000', '11-06-2023 13:00:00:000', 2),
           ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 2, '12-06-2023 16:00:00:000', '12-06-2023 17:00:00:000', 2);

    --Act
    INSERT INTO RoomReservation
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, '11-06-2023 12:00:00:000', '11-06-2023 13:00:00:000', 2),
           ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 2, '12-06-2023 16:00:00:000', '12-06-2023 17:00:00:000', 2);

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testTriggerRoomReservation.expected', 'dbo.RoomReservation', '',
         'Tables do not match!';
END
GO

/*
 * T-03
 * A member makes a squash room reservation which overlaps with existing reservation.
 *
 * Expects
 *   - Exception: 'Room Reservation Conflict: The reservation for the specified room overlaps with an existing reservation.'
 */
DROP PROCEDURE IF EXISTS [testTriggerRoomReservation].[test to verify that the trigger throws an error when a member tries to make an overlapping squash room reservation];
GO
CREATE PROCEDURE [testTriggerRoomReservation].[test to verify that the trigger throws an error when a member tries to make an overlapping squash room reservation]
AS
BEGIN
    --Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessage = 'Room Reservation Conflict: The reservation for the specified room overlaps with an existing reservation.'

    --Act
    INSERT INTO RoomReservation
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, '11-06-2023 12:00:00:000', '11-06-2023 13:00:00:000', 2),
           ('ZYWXORNEJFH-123456789012-HFDFJGNDMFJ', 1, '11-06-2023 12:30:00:000', '11-06-2023 13:30:00:000', 2);
END
GO

/*
 * T-04
 * A member makes two or more squash room reservations which overlap with existing reservations.
 *
 * Expects
 *   - Exception: 'Room Reservation Conflict: The reservation for the specified room overlaps with an existing reservation.'
 */
DROP PROCEDURE IF EXISTS [testTriggerRoomReservation].[test to verify that the trigger throws an error when a member tries to make two overlapping squash room reservations];
GO
CREATE PROCEDURE [testTriggerRoomReservation].[test to verify that the trigger throws an error when a member tries to make two overlapping squash room reservations]
AS
BEGIN
    --Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessage = 'Room Reservation Conflict: The reservation for the specified room overlaps with an existing reservation.'

    --Act
    INSERT INTO RoomReservation
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, '11-06-2023 12:00:00:000', '11-06-2023 13:00:00:000', 2),
           ('ZYWXORNEJFH-123456789012-HFDFJGNDMFJ', 1, '11-06-2023 12:30:00:000', '11-06-2023 13:30:00:000', 2),
           ('POIUYTREWQR-047204820485-GDNFJDNFGHD', 1, '11-06-2023 11:30:00:000', '11-06-2023 12:30:00:000', 2);
END
GO

/*
 * T-05
 * A member makes a squash room reservation for a non-existing room.
 *
 * Expects
 *   - Exception: 'Invalid Room Selection: The requested room (room_id: @room_id) does not exist or does not have the functionality of "Squash.'
 */
DROP PROCEDURE IF EXISTS [testTriggerRoomReservation].[test to verify that the trigger throws an error when a member tries to make a squash reservation in a non-existing room];
GO
CREATE PROCEDURE [testTriggerRoomReservation].[test to verify that the trigger throws an error when a member tries to make a squash reservation in a non-existing room]
AS
BEGIN
    --Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessage = 'Invalid Room Selection: The requested room (room_id: @room_id) does not exist or does not have the functionality of "Squash".'

    --Act
    INSERT INTO RoomReservation
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 4, '11-06-2023 12:00:00:000', '11-06-2023 13:00:00:000', 2);
END
GO

/*
 * T-06
 * A member makes two squash room reservations for a non-existing room.
 *
 * Expects
 *   - Exception: 'Invalid Room Selection: The requested room (room_id: @room_id) does not exist or does not have the functionality of "Squash.'
 */
DROP PROCEDURE IF EXISTS [testTriggerRoomReservation].[test to verify that the trigger throws an error when a member tries to make two squash reservations in a non-existing room];
GO
CREATE PROCEDURE [testTriggerRoomReservation].[test to verify that the trigger throws an error when a member tries to make two squash reservations in a non-existing room]
AS
BEGIN
    --Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessage = 'Invalid Room Selection: The requested room (room_id: @room_id) does not exist or does not have the functionality of "Squash".'

    --Act
    INSERT INTO RoomReservation
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 4, '11-06-2023 12:00:00:000', '11-06-2023 13:00:00:000', 2),
           ('ZYWXORNEJFH-123456789012-HFDFJGNDMFJ', 6, '12-06-2023 12:30:00:000', '12-06-2023 13:30:00:000', 2);
END
GO

/*
 * T-07
 * A member makes a squash room reservation when they already have a reservation in a different room at the same time.
 *
 * Expects
 *   - Exception: 'Member Reservation Conflict: The member is not available at the selected time.'
 */
DROP PROCEDURE IF EXISTS [testTriggerRoomReservation].[test to verify that the trigger throws an error when a reservation is made when a member is not available];
GO
CREATE PROCEDURE [testTriggerRoomReservation].[test to verify that the trigger throws an error when a reservation is made when a member is not available]
AS
BEGIN
    --Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessage = 'Member Reservation Conflict: The member is not available at the selected time.'

    --Act
    INSERT INTO RoomReservation
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, '11-06-2023 12:00:00:000', '11-06-2023 13:00:00:000', 2),
           ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 2, '11-06-2023 11:30:00:000', '11-06-2023 12:30:00:000', 2);
END
GO

/*
 * T-08
 * A member makes two squash room reservations when they already have a reservation in a different room at the same time.
 *
 * Expects
 *   - Exception: 'Member Reservation Conflict: The member is not available at the selected time.'
 */
DROP PROCEDURE IF EXISTS [testTriggerRoomReservation].[test to verify that the trigger throws an error when two reservation are made when a member is not available];
GO
CREATE PROCEDURE [testTriggerRoomReservation].[test to verify that the trigger throws an error when two reservation are made when a member is not available]
AS
BEGIN
    --Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessage = 'Member Reservation Conflict: The member is not available at the selected time.'

    --Act
    INSERT INTO RoomReservation
    VALUES ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 1, '11-06-2023 12:00:00:000', '11-06-2023 13:00:00:000', 2),
           ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 2, '11-06-2023 11:30:00:000', '11-06-2023 12:30:00:000', 2),
           ('ZYXWVUTSRQP-987654321012-ZYXWVUTSRQP', 3, '11-06-2023 11:45:00:000', '11-06-2023 12:45:00:000', 2);
END
GO