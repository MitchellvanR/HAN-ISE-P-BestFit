EXEC [tSQLt].[NewTestClass] 'testEditSquashRoomReservation'
GO

DROP PROCEDURE IF EXISTS testEditSquashRoomReservation.[SetUp]
GO
CREATE PROCEDURE testEditSquashRoomReservation.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable 'dbo', 'RoomReservation'

    INSERT INTO RoomReservation (member_id, room_id, start_timestamp, end_timestamp, quantity)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 1, '2023-05-09 17:44:30', '2023-05-09 18:44:30', 2)
END
GO

/**
* T-01
* Edit a room reservation in a way that should be allowed.
*
* Expects
*   - The room reservation is successfully edited and no exceptions are thrown.
*/
DROP PROCEDURE IF EXISTS testEditSquashRoomReservation.[test if a squash room reservation can't be edited]
GO
CREATE PROCEDURE testEditSquashRoomReservation.[test if a squash room reservation can't be edited]
AS
BEGIN
    -- Assemble
    IF OBJECT_ID('[testEditSquashRoomReservation].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testEditSquashRoomReservation].[expected]

    SELECT TOP 0 *
    INTO [testEditSquashRoomReservation].[expected]
    FROM dbo.RoomReservation;

    INSERT INTO expected (member_id, room_id, start_timestamp, end_timestamp, quantity)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 2, '2023-05-09 18:44:30', '2023-05-09 19:44:30', 2)

    -- Act
    EXEC sproc_editSquashRoomReservation 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 1, '2023-05-09 17:44:30', 2,
         '2023-05-09 18:44:30', '2023-05-09 19:44:30'

    -- Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testEditSquashRoomReservation.expected', 'dbo.RoomReservation', '',
         'Tables do not match!';
END

/**
* T-02
* Attempt to edit the room_id of a room reservation to a room that doesn't exist.
*
* Expects
*   - The room reservation is not edited and a foreign key error is thrown.
*/
DROP PROCEDURE IF EXISTS testEditSquashRoomReservation.[test if the room_id for a squash room reservation can't be edited to be a room that doesn't exist]
GO
CREATE PROCEDURE testEditSquashRoomReservation.[test if the room_id for a squash room reservation can't be edited to be a room that doesn't exist]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.FakeTable 'dbo', 'Room'
    INSERT INTO Room (room_id, functionality, max_people)
    VALUES (1, 'Squash', 4)
    EXEC tSQLt.ApplyConstraint 'dbo.RoomReservation', 'fk_roomrese_squash_ro_room';
    -- Expect
    EXEC [tSQLt].[ExpectException] @ExpectedMessagePattern = '%The UPDATE statement conflicted with the FOREIGN KEY constraint%'
    -- Act
    EXEC sproc_editSquashRoomReservation 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 1, '2023-05-09 17:44:30', 2,
         '2023-05-09 17:44:30', '2023-05-09 18:44:30'
END

/**
* T-03
* Attempt to edit a room reservation that doesn't exist.
*
* Expects
*   - The room reservation is not edited and an exception with the following error message will be thrown: 'This room reservation does not exist.'
*/
DROP PROCEDURE IF EXISTS testEditSquashRoomReservation.[test if a squash room reservation that doesn't exist can't be edited]
GO
CREATE PROCEDURE testEditSquashRoomReservation.[test if a squash room reservation that doesn't exist can't be edited]
AS
BEGIN
    -- Assemble
    DELETE FROM RoomReservation

    -- Expect
    EXEC tSQLt.ExpectException @ExpectedMessage = 'Error occurred in sproc ''sproc_editSquashRoomReservation''. Original message: ''This room reservation does not exist.''';

    -- Act
    EXEC sproc_editSquashRoomReservation 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 1, '2023-05-09 17:44:30', 2,
         '2023-05-09 17:44:30', '2023-05-09 18:44:30'
END