/**
* UC-07
* SPROC-17: stored procedure to book a machine for a member.
*
* Parameters
*	@member_id varchar(36) The member's ID.
*	@machine_id int The machine's ID.
*	@start_timestamp datetime The start time of the booking.
*	@end_timestamp datetime The end time of the booking.
*
* Rollbacks when
*   - The start_timestamp is before the current time.
*
*/
DROP PROCEDURE IF EXISTS sproc_bookMachine;
GO
CREATE PROCEDURE sproc_bookMachine @member_id varchar(36),
                                   @machine_id int,
                                   @start_timestamp datetime,
                                   @end_timestamp datetime
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;

        IF @start_timestamp < GETDATE()
            THROW 50000, 'The start time cannot be before the current time.', 1;


        INSERT INTO MachineReservation (member_id, machine_id, start_timestamp, end_timestamp)
        VALUES (@member_id, @machine_id, @start_timestamp, @end_timestamp);

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