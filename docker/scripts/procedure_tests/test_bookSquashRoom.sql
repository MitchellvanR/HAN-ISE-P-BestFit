EXEC tSQLt.NewTestClass 'testBookSquashRoomReservation';
GO

/*
* T-01
* A member creates a squash room reservation successfully.
*
* Expects
*   - This action gives no error. The squash room reservation is created successfully.
*/
DROP PROCEDURE IF EXISTS testBookSquashRoomReservation.[test if a squash room reservation can be created successfully]
GO
CREATE PROCEDURE testBookSquashRoomReservation.[test if a squash room reservation can be created successfully]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.FakeTable 'dbo', 'Room';
    INSERT INTO Room (room_id, functionality, max_people) VALUES (1, 'Squash', 2), (2, 'Squash', 2), (3, 'Squash', 2);

    EXEC tSQLt.FakeTable 'dbo', 'RoomReservation';

    SELECT TOP 0 *
    INTO [testBookSquashRoomReservation].[expected]
    FROM dbo.RoomReservation;

    INSERT INTO [testBookSquashRoomReservation].[expected]
    VALUES ('ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 1, '11-06-2023 12:00:00:000', '11-06-2023 13:00:00:000', 2);

    -- Act
    EXEC sproc_bookSquashRoom 'ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 1, '11-06-2023 12:00:00:000',
         '11-06-2023 13:00:00:000', 2;

    --Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testBookSquashRoomReservation.expected', 'RoomReservation'
END
GO