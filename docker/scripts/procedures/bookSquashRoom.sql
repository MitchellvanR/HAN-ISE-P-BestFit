/**
* UC-07
* SPROC-16: stored procedure to create a squash room reservation.
*
* Parameters
*	@member_id varchar(36) The employee's id
*	@room_id int The fitness room's id
*	@start_timestamp datetime The start date and time of the shift
*	@end_timestamp datetime The end date and time of the shift
*   @quantity int The quantity of people you want to book a squash room with
*
* Return
*	- The squash room reservation is created.
*/
DROP PROCEDURE IF EXISTS sproc_bookSquashRoom;
GO
CREATE PROCEDURE sproc_bookSquashRoom @member_id varchar(36),
                                               @room_id int,
                                               @start_timestamp datetime,
                                               @end_timestamp datetime,
                                               @quantity int
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;

        INSERT INTO RoomReservation(member_id, room_id, start_timestamp, end_timestamp, quantity)
        VALUES (@member_id, @room_id, @start_timestamp, @end_timestamp, @quantity);

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
