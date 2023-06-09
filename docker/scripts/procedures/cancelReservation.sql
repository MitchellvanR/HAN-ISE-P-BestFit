/**
* UC-08
* SPROC-15: Stored procedure to cancel a reservation
*
* Parameters
*   @reservation_type varchar(10) The type of reservation. Can be 'Room' or 'Machine'.
*   @reservation_id varchar(36) The room or machine ID of the reservation.
*	@member_id varchar(36) The member's ID.
*   @start_timestamp datetime() The time and date on which the reservation takes place.
*
* Return
*	- The reservation will be removed from the database.
*
* Rollbacks when
*  - The reservation type is not 'Room' or 'Machine'.
 */
DROP PROCEDURE IF EXISTS sproc_cancelReservation
GO
CREATE PROCEDURE sproc_cancelReservation @reservation_type varchar(10),
                                         @reservation_id int,
                                         @member_id varchar(36),
                                         @start_timestamp datetime
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;

        IF @reservation_type = 'Room'
            BEGIN
                IF NOT EXISTS (SELECT *
                               FROM RoomReservation
                               WHERE room_id = @reservation_id
                                 AND member_id = @member_id
                                 AND start_timestamp = @start_timestamp)
                    RAISERROR ('The reservation does not exist.', 16, 1);
                IF GETDATE() > (SELECT end_timestamp
                                FROM RoomReservation
                                WHERE room_id = @reservation_id
                                  AND member_id = @member_id
                                  AND start_timestamp = @start_timestamp)
                    RAISERROR ('The reservation has already ended.', 16, 1);
                DELETE
                FROM RoomReservation
                WHERE room_id = @reservation_id
                  AND member_id = @member_id
                  AND start_timestamp = @start_timestamp;
            END
        ELSE
            IF @reservation_type = 'Machine'
                BEGIN
                    IF NOT EXISTS (SELECT *
                                   FROM MachineReservation
                                   WHERE machine_id = @reservation_id
                                     AND member_id = @member_id
                                     AND start_timestamp = @start_timestamp)
                        RAISERROR ('The reservation does not exist.', 16, 1);
                    IF GETDATE() > (SELECT end_timestamp
                                    FROM MachineReservation
                                    WHERE machine_id = @reservation_id
                                      AND member_id = @member_id
                                      AND start_timestamp = @start_timestamp)
                        RAISERROR ('The reservation has already ended.', 16, 1);
                    DELETE
                    FROM MachineReservation
                    WHERE machine_id = @reservation_id
                      AND member_id = @member_id
                      AND start_timestamp = @start_timestamp;
                END
            ELSE
                RAISERROR ('The reservation type is invalid.', 16, 1);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() = -1 AND @startTrancount = 0
            BEGIN
                ROLLBACK TRANSACTION
            END
        ELSE
            BEGIN
                IF XACT_STATE() = 1
                    BEGIN
                        ROLLBACK TRANSACTION @savepoint;
                        COMMIT TRANSACTION;
                    END;
            END;
        DECLARE @errormessage varchar(2000);
        SET @errormessage =
                    'Error occurred in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' +
                    ERROR_MESSAGE() +
                    '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END;
GO