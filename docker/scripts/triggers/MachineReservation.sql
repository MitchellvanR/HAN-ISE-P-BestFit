/**
* TRG-06
* Trigger to verify that a member books a machine correctly.
*
* Rollbacks when
*	- A subscription of a member will end before the reservation takes place.
*	- An inserted machine is out of order.
*	- A member already reserved an inserted machine at the given time.
*	- An inserted machine is already booked at the inserted time.
*	- An inserted member already has another reservation at the inserted time.
*/
DROP TRIGGER IF EXISTS trg_MachineReservation_insertUpdate;
GO
CREATE TRIGGER trg_MachineReservation_insertUpdate
    ON MachineReservation
    AFTER INSERT, UPDATE
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS (SELECT *
                   FROM inserted i
                            INNER JOIN Subscription S ON i.member_id = S.member_id
                   WHERE S.end_date <= i.start_timestamp)
            BEGIN
                RAISERROR ('The subscription of the inserted member will end before the reservation takes place.', 16, 1);
            END

        IF EXISTS (SELECT *
                   FROM inserted i
                   WHERE EXISTS(SELECT *
                                FROM MachineReservation MR
                                         INNER JOIN Machine M ON MR.machine_id = M.machine_id
                                    AND M.machine_status = 'Out of order'
                                WHERE MR.machine_id = i.machine_id
                                  AND MR.member_id = i.member_id
                                  AND MR.start_timestamp = i.start_timestamp))
            BEGIN
                RAISERROR ('The machine of the inserted reservation is out of order.', 16, 1)
            END

        IF EXISTS (SELECT *
                   FROM inserted i
                   WHERE (SELECT COUNT(*)
                          FROM MachineReservation MR
                          WHERE MR.machine_id = i.machine_id
                            AND MR.member_id = i.member_id
                            AND (i.start_timestamp BETWEEN MR.start_timestamp
                                     AND MR.end_timestamp
                              OR i.end_timestamp BETWEEN MR.start_timestamp
                                     AND MR.end_timestamp)) > 1)
            BEGIN
                RAISERROR ('The inserted member already booked this machine at the inserted time.', 16, 1)
            END

        IF EXISTS (SELECT *
                   FROM inserted i
                   WHERE (SELECT COUNT(*)
                          FROM MachineReservation MR
                          WHERE MR.machine_id = i.machine_id
                            AND (i.start_timestamp BETWEEN MR.start_timestamp
                                     AND MR.end_timestamp
                              OR i.end_timestamp BETWEEN MR.start_timestamp
                                     AND MR.end_timestamp)) > 1)
            BEGIN
                RAISERROR ('The machine of the inserted reservation is already booked at the inserted time.', 16, 1)
            END

        IF EXISTS (SELECT *
                   FROM inserted i
                   WHERE EXISTS(SELECT *
                                FROM RoomReservation RR
                                WHERE RR.member_id = i.member_id
                                  AND (i.start_timestamp BETWEEN RR.start_timestamp
                                           AND RR.end_timestamp
                                    OR i.end_timestamp BETWEEN RR.start_timestamp
                                           AND RR.end_timestamp))
                      OR EXISTS(SELECT *
                                FROM MemberGroupClass MGC
                                         INNER JOIN GroupClass GC
                                                    ON MGC.class_name = GC.class_name AND
                                                       MGC.room_id = GC.room_id AND
                                                       MGC.start_timestamp = GC.start_timestamp
                                WHERE MGC.member_id = i.member_id
                                  AND (i.start_timestamp BETWEEN GC.start_timestamp
                                           AND GC.end_timestamp
                                    OR i.end_timestamp BETWEEN GC.start_timestamp
                                           AND GC.end_timestamp)))
            BEGIN
                RAISERROR ('The inserted member already has another reservation at the inserted time.', 16, 1)
            END
    END TRY
    BEGIN CATCH
        ;
        THROW
    END CATCH
END
GO