/**
* UC-15
* SPROC-12: stored procedure assign an employee to work in a fitness room at a specific time
*
* Parameters
*	@employee_id varchar(36) The employee's id
*	@room_id int The fitness room's id
*	@start_timestamp datetime The start date and time of the shift
*	@end_timestamp datetime The end date and time of the shift
*
* Return
*	- The employee is assigned to work in the fitness room at the specified time.
*
* Rollbacks when
*	- The employee does not have the role 'Employee'.
*   - The date and time of the shift is in the past.
*	- Another employee is already assigned to work in the fitness room at that time.
*/
DROP PROCEDURE  IF EXISTS sproc_assignEmployee;
GO
CREATE PROCEDURE sproc_assignEmployee
    @employee_id varchar(36),
    @room_id int,
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
            RAISERROR('The date and time of the shift is in the past.', 16, 1);

        INSERT INTO FitnessRoomSchedule VALUES (@employee_id, @room_id, @start_timestamp, @end_timestamp);

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