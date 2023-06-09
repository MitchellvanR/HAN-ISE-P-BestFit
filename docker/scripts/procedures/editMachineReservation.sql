/**
* UC-09
* SPROC-19: stored procedure to edit a machine reservation.
*
* Parameters
*   @identifying_machine_id The id of the machine of which a reservation needs to be edited.
*   @identifying_member_id The id of the member whose reservation needs to be edited.
*   @identifying_start_timestamp datetime The timestamp on which the reservation that needs to be edited will start.
*   @machine_id The new machine_id for the reservation.
*   @start_timestamp The new timestamp on which the reservation will start.
*   @end_timestamp The new timestamp on which the reservation will end.
*
* Rollbacks when
*   - The reservation that is supposed to be updated doesn't exist.
*	- Error occurs in an update trigger on the RoomReservation table.
*/
DROP PROCEDURE IF EXISTS sproc_editMachineReservation
GO
CREATE PROCEDURE sproc_editMachineReservation @identifying_machine_id INT,
                                              @identifying_member_id VARCHAR(36),
                                              @identifying_start_timestamp DATETIME,
                                              @machine_id INT = NULL,
                                              @start_timestamp DATETIME = NULL,
                                              @end_timestamp DATETIME = NULL
AS
BEGIN
    DECLARE @savepoint VARCHAR(128)= CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3));
    DECLARE @startTrancount INT= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;

        IF (NOT EXISTS(SELECT *
                       FROM MachineReservation
                       WHERE machine_id = @identifying_machine_id
                         AND member_id = @identifying_member_id
                         AND start_timestamp = @identifying_start_timestamp))
            THROW 50000, 'This machine reservation does not exist.', 1

        UPDATE MachineReservation
        SET machine_id      = ISNULL(@machine_id, machine_id),
            start_timestamp = ISNULL(@start_timestamp, start_timestamp),
            end_timestamp   = ISNULL(@end_timestamp, end_timestamp)
        WHERE machine_id = @identifying_machine_id
          AND member_id = @identifying_member_id
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
        DECLARE @errormessage VARCHAR(2000);
        SET @errormessage =
                    'Error occurred in sproc ''' + OBJECT_NAME(@@PROCID) + '''. Original message: ''' +
                    ERROR_MESSAGE() +
                    '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END;
GO