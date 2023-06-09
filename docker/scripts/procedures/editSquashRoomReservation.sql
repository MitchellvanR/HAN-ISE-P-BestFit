/**
* UC-09
* SPROC-20: stored procedure to edit a squash room reservation.
*
* Parameters
*
*   @identifying_member_id The id of the member whose reservation needs to be edited.
*   @identifying_room_id int The room_id of the reservation that needs to be edited.
*   @identifying_start_timestamp datetime The timestamp on which the reservation that needs to be edited will start.
*   @room_id The new room_id for the reservation.
*   @start_timestamp The new timestamp on which the reservation will start.
*   @end_timestamp The new timestamp on which the reservation will end.
*   @quantity datetime The new amount quantity of people that are expected to attend the reservation.
*
* Rollbacks when
*   - The reservation that is supposed to be updated doesn't exist.
*	- Error occurs in an update trigger on the RoomReservation table.
*/
DROP PROCEDURE IF EXISTS sproc_editSquashRoomReservation
GO
CREATE PROCEDURE sproc_editSquashRoomReservation @identifying_member_id varchar(36),
                                                 @identifying_room_id int,
                                                 @identifying_start_timestamp datetime,
                                                 @room_id int = NULL,
                                                 @start_timestamp datetime = NULL,
                                                 @end_timestamp datetime = NULL,
                                                 @quantity int = NULL
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;

        IF (NOT EXISTS(SELECT *
                       FROM RoomReservation
                       WHERE member_id = @identifying_member_id
                         AND room_id = @identifying_room_id
                         AND start_timestamp = @identifying_start_timestamp))
            THROW 50000, 'This room reservation does not exist.', 1

        UPDATE RoomReservation
        SET room_id         = ISNULL(@room_id, room_id),
            start_timestamp = ISNULL(@start_timestamp, start_timestamp),
            end_timestamp   = ISNULL(@end_timestamp, end_timestamp),
            quantity        = ISNULL(@quantity, quantity)
        WHERE member_id = @identifying_member_id
          AND room_id = @identifying_room_id
          AND start_timestamp = @identifying_start_timestamp
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
                    'Error occurred in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                    '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END;
GO