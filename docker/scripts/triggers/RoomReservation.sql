/**
* TRG-05
* Trigger to make sure only valid squash reservations get inserted.
*
* Rollbacks when
*     - The member that has been selected doesn't exist.
*     - The member that has been selected isn't available at the selected time.
*	  - The room that has been selected isn't available at the selected time.
*     - The room that has been selected doesn't exist.
*	  - The reservation overlaps with an existing reservation for the specific room.
*	  - The selected room isn't suitable for squash.
*/
DROP TRIGGER IF EXISTS trg_RoomReservation_insertUpdate
GO
CREATE TRIGGER trg_RoomReservation_insertUpdate
    ON dbo.RoomReservation
    AFTER INSERT, UPDATE AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN
    SET NOCOUNT ON
    BEGIN TRY
        IF (NOT EXISTS(SELECT *
                       FROM inserted i
                                JOIN Room r ON i.room_id = r.room_id
                       WHERE functionality = 'Squash'))
            BEGIN
                THROW 50000, 'Invalid Room Selection: The requested room (room_id: @room_id) does not exist or does not have the functionality of "Squash".', 1
            END

        IF (EXISTS(SELECT *
                   FROM inserted i
                   WHERE room_id IN (SELECT room_id
                                     FROM Room R
                                     WHERE EXISTS(SELECT *
                                                  FROM RoomReservation
                                                  WHERE room_id = R.room_id
                                                    AND start_timestamp < i.end_timestamp
                                                    AND i.start_timestamp < end_timestamp
                                                  EXCEPT
                                                  SELECT *
                                                  FROM inserted
                                                  WHERE member_id = i.member_id
                                                    AND room_id = i.room_id
                                                    AND start_timestamp = i.start_timestamp))))
            BEGIN
                THROW 50000, 'Room Reservation Conflict: The reservation for the specified room overlaps with an existing reservation.', 1;
            END

        IF (EXISTS(SELECT *
                   FROM inserted i
                   WHERE EXISTS(SELECT *
                                FROM RoomReservation RR
                                WHERE RR.member_id = i.member_id
                                  AND i.start_timestamp < RR.end_timestamp
                                  AND RR.start_timestamp < i.end_timestamp
                                EXCEPT
                                SELECT *
                                FROM inserted
                                WHERE member_id = i.member_id
                                  AND room_id = i.room_id
                                  AND start_timestamp = i.start_timestamp)
                      OR EXISTS(SELECT *
                                FROM MachineReservation
                                WHERE member_id = i.member_id
                                  AND i.start_timestamp < end_timestamp
                                  AND start_timestamp < i.end_timestamp)
                      OR EXISTS(SELECT *
                                FROM MemberGroupClass MBC
                                         JOIN GroupClass GC on MBC.class_name = GC.class_name
                                WHERE member_id = i.member_id
                                  AND i.start_timestamp < GC.end_timestamp
                                  AND GC.start_timestamp < i.end_timestamp)))
            BEGIN
                THROW 50000, 'Member Reservation Conflict: The member is not available at the selected time.', 1;
            END
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO